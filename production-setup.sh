#!/usr/bin/env bash
set -euo pipefail

#=============================================================
# Mrs-Unkwn Production Setup Script
# Automates Docker/Nginx/Certbot/Flutter APK build
#=============================================================

#--------------- Utility Functions ---------------------------
info() { echo -e "\e[32m[✓]\e[0m $*"; }
warn() { echo -e "\e[33m[!]\e[0m $*"; }
error() { echo -e "\e[31m[✗]\e[0m $*" >&2; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || { error "Befehl $1 erforderlich"; exit 1; }; }

prompt_secret() {
  local var="$1" prompt="$2" value
  if [[ -n "${!var:-}" ]]; then return 0; fi
  read -r -s -p "$prompt" value; echo; export "$var"="$value"
}

gen_secret() { openssl rand -base64 32; }

write_if_diff() {
  local file="$1" tmp="${file}.tmp"
  cat >"$tmp"
  if [[ ! -f "$file" || ! cmp -s "$tmp" "$file" ]]; then
    mv "$tmp" "$file"
    info "schreibe $file"
  else
    rm "$tmp"
    info "$file unverändert"
  fi
}

backup_if_exists() {
  [[ -f "$1" ]] && cp "$1" "$1.bak$(date +%s)"
}

#--------------- Flag Parsing -------------------------------
YES=false
SKIP_APK=false
NO_FIREWALL=false
REISSUE_CERT=false
WITH_DB=false
NO_DB=false
DEBUG=false
BACKEND_DIR=""
APP_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -y|--yes) YES=true;;
    --skip-apk) SKIP_APK=true;;
    --no-firewall) NO_FIREWALL=true;;
    --reissue-cert) REISSUE_CERT=true;;
    --with-db) WITH_DB=true;;
    --no-db) NO_DB=true;;
    --backend-dir) BACKEND_DIR="$2"; shift;;
    --app-dir) APP_DIR="$2"; shift;;
    --debug) DEBUG=true;;
    *) warn "Unbekannte Option $1";;
  esac
  shift
done

$DEBUG && set -x

#--------------- Preflight Checks ---------------------------
require_cmd uname
OS_ID="$(. /etc/os-release && echo "$ID")"
case "$OS_ID" in
  ubuntu|debian) :;;
  *) error "Unsupported OS: $OS_ID"; exit 1;;
endcase

if [[ $EUID -ne 0 ]]; then
  error "Bitte als root oder mit sudo ausführen"; exit 1;
fi

#--------------- Package Installation -----------------------
apt_update_once=false
ensure_pkg() {
  local pkg="$1"
  if ! dpkg -s "$pkg" >/dev/null 2>&1; then
    $apt_update_once || { apt-get update -y; apt_update_once=true; }
    apt-get install -y "$pkg"
  fi
}

ensure_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    info "Installiere Docker"
    ensure_pkg ca-certificates
    ensure_pkg curl
    ensure_pkg gnupg
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$OS_ID/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS_ID $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
      >/etc/apt/sources.list.d/docker.list
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi
}

ensure_nginx_certbot() {
  ensure_pkg nginx
  ensure_pkg certbot
  ensure_pkg python3-certbot-nginx
}

ensure_ufw() {
  ensure_pkg ufw
  ufw status | grep -q inactive && ufw --force enable
  ufw allow 22/tcp
  ufw allow "$EXTERNAL_PORT_HTTP"/tcp
  ufw allow "$EXTERNAL_PORT_HTTPS"/tcp
}

#--------------- Input Handling -----------------------------
ask() {
  local var="$1" prompt="$2" default="$3"
  if [[ -n "${!var:-}" ]]; then return; fi
  if $YES; then
    export "$var"="$default"
  else
    read -r -p "$prompt [$default]: " input
    export "$var"="${input:-$default}"
  fi
}

ask SECRET "" ""

# Defaults
EXTERNAL_PORT_HTTP=${EXTERNAL_PORT_HTTP:-80}
EXTERNAL_PORT_HTTPS=${EXTERNAL_PORT_HTTPS:-443}
ENVIRONMENT=${ENVIRONMENT:-production}
BACKEND_PORT=${BACKEND_PORT:-3000}
ENABLE_UFW=${ENABLE_UFW:-true}
API_BASE_URL_FOR_APP=${API_BASE_URL_FOR_APP:-}
OPENROUTER_BASE_URL=${OPENROUTER_BASE_URL:-https://openrouter.ai/api/v1}
OPENROUTER_MODEL=${OPENROUTER_MODEL:-qwen/qwen2.5-coder:latest}
APP_BASE_URL=${APP_BASE_URL:-}
CORS_ORIGINS=${CORS_ORIGINS:-}
ANDROID_SIGNING=${ANDROID_SIGNING:-none}
BUILD_MODE=${BUILD_MODE:-release}

# Prompt
ask DOMAIN "Domain für HTTPS" ""
ask EMAIL "Let’s Encrypt E-Mail" ""
ask ENVIRONMENT "Environment" "production"
ask BACKEND_PORT "Interner Backend-Port" "3000"
ask EXTERNAL_PORT_HTTP "Externer HTTP-Port" "80"
ask EXTERNAL_PORT_HTTPS "Externer HTTPS-Port" "443"
ask APP_BASE_URL "App-Basis-URL" "https://$DOMAIN"
ask API_BASE_URL_FOR_APP "API-Basis-URL für App" "https://$DOMAIN"
ask CORS_ORIGINS "CORS Origins" "https://$DOMAIN"
ask OPENROUTER_API_KEY "OpenRouter API Key" ""
ask OPENROUTER_MODEL "OpenRouter Modell" "$OPENROUTER_MODEL"
ask OPENROUTER_BASE_URL "OpenRouter Base URL" "$OPENROUTER_BASE_URL"
ask OPENROUTER_BUDGET_LIMIT "OpenRouter Budget Limit" ""
ask JWT_SECRET "JWT Secret" "$(gen_secret)"
ask SESSION_SECRET "Session Secret" "$(gen_secret)"
ask ENCRYPTION_KEY "Encryption Key (32 Byte Base64)" "$(gen_secret)"
ask ADMIN_EMAIL "Admin Email" ""
ask USE_REDIS "Redis verwenden? (true/false)" "false"
ask USE_S3 "S3 Storage verwenden? (true/false)" "false"
ask DB_ENGINE "DB Engine (postgres/mysql/sqlite/none)" "sqlite"
if [[ "$DB_ENGINE" != "none" && "$DB_ENGINE" != "sqlite" ]]; then
  ask DB_HOST "DB Host" "db"
  ask DB_PORT "DB Port" "$([[ "$DB_ENGINE" == postgres ]] && echo 5432 || echo 3306)"
  ask DB_NAME "DB Name" "mrsunkwn"
  ask DB_USER "DB User" "mrsunkwn"
  ask DB_PASS "DB Passwort" "$(gen_secret)"
fi

ask ANDROID_APP_ID "Android App ID" "com.meinzeug.mrsunkwn"
ask ANDROID_SIGNING "Android Signing (none/debug/release)" "none"
ask FLAVOR "Flutter Flavor" ""
ask BUILD_MODE "Build Mode" "release"

#--------------- Auto-Discovery -----------------------------
auto_detect_backend() {
  local paths
  if [[ -n "$BACKEND_DIR" ]]; then echo "$BACKEND_DIR"; return; fi
  IFS=$'\n' read -r -d '' -a paths < <(find . -maxdepth 3 -name package.json -print0)
  if [[ ${#paths[@]} -eq 1 ]]; then
    BACKEND_DIR="$(dirname "${paths[0]}")"
  else
    warn "Mehrere Backend-Verzeichnisse gefunden"
    select p in "${paths[@]}"; do BACKEND_DIR="$(dirname "$p")"; break; done
  fi
}

auto_detect_app() {
  local paths
  if [[ -n "$APP_DIR" ]]; then echo "$APP_DIR"; return; fi
  IFS=$'\n' read -r -d '' -a paths < <(find . -maxdepth 3 -name pubspec.yaml -print0)
  if [[ ${#paths[@]} -eq 1 ]]; then
    APP_DIR="$(dirname "${paths[0]}")"
  else
    warn "Mehrere Flutter Apps gefunden"
    select p in "${paths[@]}"; do APP_DIR="$(dirname "$p")"; break; done
  fi
}

auto_detect_backend
auto_detect_app

info "Backend-Verzeichnis: $BACKEND_DIR"
info "Flutter-App-Verzeichnis: $APP_DIR"

#--------------- Install Dependencies -----------------------
ensure_docker
ensure_nginx_certbot
if [[ "$ENABLE_UFW" == true && $NO_FIREWALL == false ]]; then
  ensure_ufw
fi

#--------------- Generate .env ------------------------------
cat > .env <<EOF_ENV
DOMAIN=$DOMAIN
EMAIL=$EMAIL
ENVIRONMENT=$ENVIRONMENT
BACKEND_PORT=$BACKEND_PORT
EXTERNAL_PORT_HTTP=$EXTERNAL_PORT_HTTP
EXTERNAL_PORT_HTTPS=$EXTERNAL_PORT_HTTPS
CORS_ORIGINS=$CORS_ORIGINS
APP_BASE_URL=$APP_BASE_URL
OPENROUTER_API_KEY=$OPENROUTER_API_KEY
OPENROUTER_MODEL=$OPENROUTER_MODEL
OPENROUTER_BASE_URL=$OPENROUTER_BASE_URL
OPENROUTER_BUDGET_LIMIT=$OPENROUTER_BUDGET_LIMIT
JWT_SECRET=$JWT_SECRET
SESSION_SECRET=$SESSION_SECRET
ENCRYPTION_KEY=$ENCRYPTION_KEY
ADMIN_EMAIL=$ADMIN_EMAIL
DB_ENGINE=$DB_ENGINE
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
USE_REDIS=$USE_REDIS
USE_S3=$USE_S3
EOF_ENV

# Backend env
cat > "$BACKEND_DIR/.env" <<EOF_BENV
PORT=$BACKEND_PORT
NODE_ENV=$ENVIRONMENT
OPENROUTER_API_KEY=$OPENROUTER_API_KEY
OPENROUTER_MODEL=$OPENROUTER_MODEL
OPENROUTER_BASE_URL=$OPENROUTER_BASE_URL
OPENROUTER_BUDGET_LIMIT=$OPENROUTER_BUDGET_LIMIT
JWT_SECRET=$JWT_SECRET
SESSION_SECRET=$SESSION_SECRET
ENCRYPTION_KEY=$ENCRYPTION_KEY
DB_ENGINE=$DB_ENGINE
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
USE_REDIS=$USE_REDIS
ADMIN_EMAIL=$ADMIN_EMAIL
EOF_BENV

#--------------- Generate Dockerfile ------------------------
write_if_diff "$BACKEND_DIR/Dockerfile.backend" <<'EOF_DOCKER'
# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
RUN npm run build || true

# Run stage
FROM node:20-alpine
WORKDIR /app
COPY --from=build /app /app
ENV NODE_ENV=production
USER node
CMD ["node", "dist/index.js"]
EOF_DOCKER

#--------------- Generate docker-compose --------------------
write_if_diff docker-compose.yml <<EOF_COMPOSE
services:
  backend:
    build:
      context: $BACKEND_DIR
      dockerfile: Dockerfile.backend
    env_file: .env
    ports:
      - "${BACKEND_PORT}:${BACKEND_PORT}"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:${BACKEND_PORT}/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  nginx:
    image: nginx:alpine
    ports:
      - "${EXTERNAL_PORT_HTTP}:80"
      - "${EXTERNAL_PORT_HTTPS}:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - certbot-etc:/etc/letsencrypt
      - certbot-var:/var/www/certbot
    depends_on:
      - backend

  certbot:
    image: certbot/certbot
    volumes:
      - certbot-etc:/etc/letsencrypt
      - certbot-var:/var/www/certbot
    entrypoint: sh -c "trap exit TERM; while :; do certbot renew --webroot -w /var/www/certbot; sleep 12h; done"

volumes:
  certbot-etc:
  certbot-var:
EOF_COMPOSE

#--------------- Generate nginx.conf ------------------------
write_if_diff nginx.conf <<EOF_NGINX
events {}
http {
  server {
    listen 80;
    server_name $DOMAIN;
    location /.well-known/acme-challenge/ {
      root /var/www/certbot;
    }
    location / {
      return 301 https://$DOMAIN$request_uri;
    }
  }
  server {
    listen 443 ssl;
    server_name $DOMAIN;
    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    location / {
      proxy_pass http://backend:$BACKEND_PORT;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    }
    client_max_body_size 50m;
  }
}
EOF_NGINX

#--------------- TLS Setup ----------------------------------
if [[ ! -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" || $REISSUE_CERT == true ]]; then
  docker compose up -d nginx
  certbot certonly --webroot -w /var/www/certbot -d "$DOMAIN" -m "$EMAIL" --agree-tos --no-eff-email --deploy-hook "docker compose reload nginx" || true
fi

#--------------- Docker Compose Up --------------------------
docker compose up -d --build

#--------------- Flutter Build ------------------------------
if ! $SKIP_APK; then
  mkdir -p dist
  docker run --rm -v "$PWD/$APP_DIR":/app -w /app cirrusci/flutter:stable bash -c "flutter clean && flutter pub get && flutter build apk --${BUILD_MODE} ${FLAVOR:+--flavor $FLAVOR} --dart-define=API_BASE_URL=${API_BASE_URL_FOR_APP} --dart-define=OPENROUTER_MODEL=${OPENROUTER_MODEL} && cp build/app/outputs/flutter-apk/app-${BUILD_MODE}.apk /app/../dist/app-release.apk"
  info "APK erstellt unter dist/app-release.apk"
fi

#--------------- Health Check -------------------------------
sleep 5
default_health="https://$DOMAIN/health"
if curl -k --silent --fail "$default_health" >/dev/null; then
  info "Healthcheck erfolgreich: $default_health"
else
  warn "Healthcheck fehlgeschlagen: $default_health"
fi

if command -v certbot >/dev/null 2>&1; then
  CERT_INFO=$(certbot certificates 2>/dev/null | grep -A1 "Domains: $DOMAIN" || true)
fi

cat <<SUMMARY
----- Setup Zusammenfassung -----
Domain: $DOMAIN
Backend erreichbar unter: https://$DOMAIN
APK Pfad: dist/app-release.apk
Docker Befehle: docker compose logs, docker compose restart
Zertifikat: $CERT_INFO
---------------------------------
SUMMARY
