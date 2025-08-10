#!/usr/bin/env bash
set -euo pipefail

#=============================================================
# Mrs-Unkwn Production Setup Script (HOST-NGINX VERSION)
# - Backend in Docker (host network)
# - Nginx + Certbot auf dem Host (erst HTTP, dann Certbot → HTTPS)
# - API: https://<DOMAIN>/api
# - APK-Build & Auslieferung: https://<DOMAIN>/mrs-unkwn.apk
# - Persistente Defaults: ~/.config/mrs-unkwn/setup.json
# - Secrets (JWT/SESSION/ENCRYPTION) mit Default-Vorschlägen
# - Lockfile-Handling: erzeugt package-lock.json automatisch (npm)
# - Flutter-Image: frei pullbar (Docker Hub), Dart >= 3.5
#=============================================================

#--------------- Konstante/Defaults --------------------------
FLUTTER_IMAGE="${FLUTTER_IMAGE:-instrumentisto/flutter:3.32.8}"  # Dart 3.8 / Flutter 3.32.x
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mrs-unkwn"
CONFIG_FILE="$CONFIG_DIR/setup.json"

#--------------- Utility Functions ---------------------------
info()  { echo -e "\e[32m[✓]\e[0m $*"; }
warn()  { echo -e "\e[33m[!]\e[0m $*"; }
error() { echo -e "\e[31m[✗]\e[0m $*" >&2; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || { error "Befehl $1 erforderlich"; exit 1; }; }

prompt_secret() {
  local var="$1" prompt="$2" value
  if [[ -n "${!var:-}" ]]; then return 0; fi
  local default="$(gen_secret)"
  read -r -s -p "$prompt (Enter für Vorschlag): " value || true; echo
  if [[ -z "$value" ]]; then value="$default"; fi
  export "$var"="$value"
}

gen_secret() { openssl rand -base64 32; }

write_if_diff() {
  local file="${1:-}"
  if [[ -z "$file" ]]; then
    error "write_if_diff: fehlender Dateiname"; cat >/dev/null; return 1
  fi
  local tmp="${file}.tmp"
  cat >"$tmp"
  if [[ ! -f "$file" ]] || ! cmp -s "$tmp" "$file"; then
    mv "$tmp" "$file"
    info "schreibe $file"
  else
    rm "$tmp"
    info "$file unverändert"
  fi
}

backup_if_exists() { [[ -f "$1" ]] && cp "$1" "$1.bak$(date +%s)"; }

#--------------- Persistente Konfiguration -------------------
mkdir -p "$CONFIG_DIR"

ensure_pkg_jq() {
  if ! command -v jq >/dev/null 2>&1; then
    info "Installiere jq für JSON-Handling"
    apt-get update -y
    apt-get install -y jq
  fi
}

cfg_has() { [[ -f "$CONFIG_FILE" ]] && jq -e ".\"$1\" != null" "$CONFIG_FILE" >/dev/null 2>&1; }
cfg_get()  { jq -r ".\"$1\" // empty" "$CONFIG_FILE" 2>/dev/null || true; }

config_load() {
  [[ -f "$CONFIG_FILE" ]] || return 0
  local key val
  while IFS= read -r key; do
    val="$(cfg_get "$key")"
    if [[ -n "$val" && -z "${!key:-}" ]]; then
      export "$key"="$val"
    fi
  done < <(jq -r 'keys[]' "$CONFIG_FILE")
  info "Vorhandene Konfiguration geladen: $CONFIG_FILE"
}

config_save() {
  ensure_pkg_jq
  info "Speichere Konfiguration nach $CONFIG_FILE"
  jq -n \
    --arg DOMAIN "${DOMAIN:-}" \
    --arg EMAIL "${EMAIL:-}" \
    --arg ENVIRONMENT "${ENVIRONMENT:-}" \
    --arg BACKEND_PORT "${BACKEND_PORT:-}" \
    --arg EXTERNAL_PORT_HTTP "${EXTERNAL_PORT_HTTP:-}" \
    --arg EXTERNAL_PORT_HTTPS "${EXTERNAL_PORT_HTTPS:-}" \
    --arg CORS_ORIGINS "${CORS_ORIGINS:-}" \
    --arg APP_BASE_URL "${APP_BASE_URL:-}" \
    --arg API_BASE_URL_FOR_APP "${API_BASE_URL_FOR_APP:-}" \
    --arg OPENROUTER_API_KEY "${OPENROUTER_API_KEY:-}" \
    --arg OPENROUTER_MODEL "${OPENROUTER_MODEL:-}" \
    --arg OPENROUTER_BASE_URL "${OPENROUTER_BASE_URL:-}" \
    --arg OPENROUTER_BUDGET_LIMIT "${OPENROUTER_BUDGET_LIMIT:-}" \
    --arg JWT_SECRET "${JWT_SECRET:-}" \
    --arg SESSION_SECRET "${SESSION_SECRET:-}" \
    --arg ENCRYPTION_KEY "${ENCRYPTION_KEY:-}" \
    --arg ADMIN_EMAIL "${ADMIN_EMAIL:-}" \
    --arg DB_ENGINE "${DB_ENGINE:-}" \
    --arg DB_HOST "${DB_HOST:-}" \
    --arg DB_PORT "${DB_PORT:-}" \
    --arg DB_NAME "${DB_NAME:-}" \
    --arg DB_USER "${DB_USER:-}" \
    --arg DB_PASS "${DB_PASS:-}" \
    --arg USE_REDIS "${USE_REDIS:-}" \
    --arg USE_S3 "${USE_S3:-}" \
    --arg ANDROID_APP_ID "${ANDROID_APP_ID:-}" \
    --arg ANDROID_SIGNING "${ANDROID_SIGNING:-}" \
    --arg FLAVOR "${FLAVOR:-}" \
    --arg BUILD_MODE "${BUILD_MODE:-}" \
    --arg ENABLE_UFW "${ENABLE_UFW:-}" \
    --arg BACKEND_DIR "${BACKEND_DIR:-}" \
    --arg APP_DIR "${APP_DIR:-}" \
    --arg FLUTTER_IMAGE "${FLUTTER_IMAGE:-}" \
    '{
      DOMAIN:$DOMAIN, EMAIL:$EMAIL, ENVIRONMENT:$ENVIRONMENT,
      BACKEND_PORT:$BACKEND_PORT, EXTERNAL_PORT_HTTP:$EXTERNAL_PORT_HTTP, EXTERNAL_PORT_HTTPS:$EXTERNAL_PORT_HTTPS,
      CORS_ORIGINS:$CORS_ORIGINS, APP_BASE_URL:$APP_BASE_URL, API_BASE_URL_FOR_APP:$API_BASE_URL_FOR_APP,
      OPENROUTER_API_KEY:$OPENROUTER_API_KEY, OPENROUTER_MODEL:$OPENROUTER_MODEL,
      OPENROUTER_BASE_URL:$OPENROUTER_BASE_URL, OPENROUTER_BUDGET_LIMIT:$OPENROUTER_BUDGET_LIMIT,
      JWT_SECRET:$JWT_SECRET, SESSION_SECRET:$SESSION_SECRET, ENCRYPTION_KEY:$ENCRYPTION_KEY,
      ADMIN_EMAIL:$ADMIN_EMAIL,
      DB_ENGINE:$DB_ENGINE, DB_HOST:$DB_HOST, DB_PORT:$DB_PORT, DB_NAME:$DB_NAME, DB_USER:$DB_USER, DB_PASS:$DB_PASS,
      USE_REDIS:$USE_REDIS, USE_S3:$USE_S3,
      ANDROID_APP_ID:$ANDROID_APP_ID, ANDROID_SIGNING:$ANDROID_SIGNING, FLAVOR:$FLAVOR, BUILD_MODE:$BUILD_MODE,
      ENABLE_UFW:$ENABLE_UFW, BACKEND_DIR:$BACKEND_DIR, APP_DIR:$APP_DIR,
      FLUTTER_IMAGE:$FLUTTER_IMAGE
    }' > "$CONFIG_FILE"
}

#--------------- Flags & Defaults ----------------------------
YES=false
SKIP_APK=false
NO_FIREWALL=false
REISSUE_CERT=false
WITH_DB=false
NO_DB=false
DEBUG=false
BACKEND_DIR="${BACKEND_DIR:-}"
APP_DIR="${APP_DIR:-}"

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
esac
if [[ $EUID -ne 0 ]]; then error "Bitte als root oder mit sudo ausführen"; exit 1; fi

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
    ensure_pkg ca-certificates; ensure_pkg curl; ensure_pkg gnupg
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL "https://download.docker.com/linux/$OS_ID/gpg" | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS_ID $(. /etc/os-release && echo "$VERSION_CODENAME") stable" >/etc/apt/sources.list.d/docker.list
    apt-get update -y
    ensure_pkg docker-ce; ensure_pkg docker-ce-cli; ensure_pkg containerd.io
    ensure_pkg docker-buildx-plugin; ensure_pkg docker-compose-plugin
  fi
}

ensure_nginx_certbot() { ensure_pkg nginx; ensure_pkg certbot; ensure_pkg python3-certbot-nginx; }

ensure_ufw() {
  ensure_pkg ufw
  ufw status | grep -q inactive && ufw --force enable
  ufw allow 22/tcp
  ufw allow "${EXTERNAL_PORT_HTTP}"/tcp
  ufw allow "${EXTERNAL_PORT_HTTPS}"/tcp
}

#--------------- Input Handling (+ persistente Defaults) -----
ask() {
  local var="$1" prompt="$2" default="$3"
  if [[ -z "${!var:-}" && -f "$CONFIG_FILE" ]] && cfg_has "$var"; then
    default="$(cfg_get "$var")"
  fi
  if [[ -n "${!var:-}" ]]; then return; fi
  if $YES; then
    export "$var"="$default"
  else
    read -r -p "$prompt [${default}]: " input
    export "$var"="${input:-$default}"
  fi
}

#--------------- Defaults & Load previous config -------------
EXTERNAL_PORT_HTTP=${EXTERNAL_PORT_HTTP:-80}
EXTERNAL_PORT_HTTPS=${EXTERNAL_PORT_HTTPS:-443}
ENVIRONMENT=${ENVIRONMENT:-production}
BACKEND_PORT=${BACKEND_PORT:-3000}
ENABLE_UFW=${ENABLE_UFW:-true}
OPENROUTER_BASE_URL=${OPENROUTER_BASE_URL:-https://openrouter.ai/api/v1}
OPENROUTER_MODEL=${OPENROUTER_MODEL:-qwen/qwen2.5-coder:latest}
ANDROID_SIGNING=${ANDROID_SIGNING:-none}
BUILD_MODE=${BUILD_MODE:-release}
APP_BASE_URL=${APP_BASE_URL:-}
CORS_ORIGINS=${CORS_ORIGINS:-}
API_BASE_URL_FOR_APP=${API_BASE_URL_FOR_APP:-}

config_load

#--------------- Prompts ------------------------------------
ask DOMAIN "Domain für HTTPS" "${DOMAIN:-}"
ask EMAIL "Let’s Encrypt E-Mail" "${EMAIL:-}"
ask ENVIRONMENT "Environment" "${ENVIRONMENT:-production}"
ask BACKEND_PORT "Interner Backend-Port" "${BACKEND_PORT:-3000}"
ask EXTERNAL_PORT_HTTP "Externer HTTP-Port" "${EXTERNAL_PORT_HTTP:-80}"
ask EXTERNAL_PORT_HTTPS "Externer HTTPS-Port" "${EXTERNAL_PORT_HTTPS:-443}"

# Automatisch aus Domain ableiten
APP_BASE_URL="https://${DOMAIN}"
API_BASE_URL_FOR_APP="https://${DOMAIN}/api"
ask CORS_ORIGINS "CORS Origins" "${CORS_ORIGINS:-https://${DOMAIN}}"

# KI / OpenRouter
if [[ -z "${OPENROUTER_API_KEY:-}" ]]; then prompt_secret OPENROUTER_API_KEY "OpenRouter API Key"; fi
ask OPENROUTER_MODEL "OpenRouter Modell" "${OPENROUTER_MODEL:-qwen/qwen2.5-coder:latest}"
ask OPENROUTER_BASE_URL "OpenRouter Base URL" "${OPENROUTER_BASE_URL:-https://openrouter.ai/api/v1}"
ask OPENROUTER_BUDGET_LIMIT "OpenRouter Budget Limit" "${OPENROUTER_BUDGET_LIMIT:-}"

# Secrets mit Vorschlag (Enter = Vorschlag übernehmen)
prompt_secret JWT_SECRET "JWT Secret"
prompt_secret SESSION_SECRET "Session Secret"
prompt_secret ENCRYPTION_KEY "Encryption Key (32 Byte Base64)"

ask ADMIN_EMAIL "Admin Email" "${ADMIN_EMAIL:-}"
ask USE_REDIS "Redis verwenden? (true/false)" "${USE_REDIS:-false}"
ask USE_S3 "S3 Storage verwenden? (true/false)" "${USE_S3:-false}"

ask DB_ENGINE "DB Engine (postgres/mysql/sqlite/none)" "${DB_ENGINE:-sqlite}"
if [[ "${DB_ENGINE}" != "none" && "${DB_ENGINE}" != "sqlite" ]]; then
  ask DB_HOST "DB Host" "${DB_HOST:-db}"
  if [[ "${DB_ENGINE}" == "postgres" ]]; then
    ask DB_PORT "DB Port" "${DB_PORT:-5432}"
  else
    ask DB_PORT "DB Port" "${DB_PORT:-3306}"
  fi
  ask DB_NAME "DB Name" "${DB_NAME:-mrsunkwn}"
  ask DB_USER "DB User" "${DB_USER:-mrsunkwn}"
  if [[ -z "${DB_PASS:-}" ]]; then prompt_secret DB_PASS "DB Passwort"; fi
fi

ask ANDROID_APP_ID "Android App ID" "${ANDROID_APP_ID:-com.meinzeug.mrsunkwn}"
ask ANDROID_SIGNING "Android Signing (none/debug/release)" "${ANDROID_SIGNING:-none}"
ask FLAVOR "Flutter Flavor" "${FLAVOR:-}"
ask BUILD_MODE "Build Mode" "${BUILD_MODE:-release}"

#--------------- Auto-Discovery -----------------------------
auto_detect_backend() {
  if [[ -n "${BACKEND_DIR:-}" ]]; then return; fi
  mapfile -d '' -t paths < <(find . -maxdepth 3 -name package.json -print0)
  if (( ${#paths[@]} == 1 )); then
    BACKEND_DIR="$(dirname "${paths[0]}")"
  elif (( ${#paths[@]} > 1 )); then
    warn "Mehrere Backend-Verzeichnisse gefunden"
    select p in "${paths[@]}"; do BACKEND_DIR="$(dirname "$p")"; break; done
  else
    error "Kein Backend (package.json) gefunden"; exit 1
  fi
}
auto_detect_app() {
  if [[ -n "${APP_DIR:-}" ]]; then return; fi
  mapfile -d '' -t paths < <(find . -maxdepth 3 -name pubspec.yaml -print0)
  if (( ${#paths[@]} == 1 )); then
    APP_DIR="$(dirname "${paths[0]}")"
  elif (( ${#paths[@]} > 1 )); then
    warn "Mehrere Flutter-Apps gefunden"
    select p in "${paths[@]}"; do APP_DIR="$(dirname "$p")"; break; done
  else
    warn "Keine Flutter-App gefunden – APK-Build wird übersprungen"; SKIP_APK=true
  fi
}
auto_detect_backend
auto_detect_app

info "Backend-Verzeichnis: ${BACKEND_DIR}"
info "Flutter-App-Verzeichnis: ${APP_DIR:-<keins gefunden>}"

# Speichere Defaults inkl. detektierter Pfade und Image
config_save

#--------------- Install Dependencies -----------------------
ensure_docker
ensure_nginx_certbot
if [[ "${ENABLE_UFW:-true}" == "true" && "${NO_FIREWALL:-false}" == "false" ]]; then ensure_ufw; fi
ensure_pkg_jq

#--------------- Lockfile-Handling (npm) ---------------------
generate_lockfile_if_missing() {
  local dir="$1"
  if [[ ! -f "$dir/package.json" ]]; then return 0; fi
  if [[ -f "$dir/package-lock.json" ]]; then
    info "Lockfile gefunden (package-lock.json)"
    return 0
  fi
  info "Kein Lockfile gefunden – erzeuge package-lock.json im Docker-Container"
  docker run --rm -v "$PWD/$dir":/app -w /app node:20-alpine sh -lc \
    "apk add --no-cache git >/dev/null 2>&1 || true; npm install --package-lock-only"
  if [[ -f "$dir/package-lock.json" ]]; then
    info "package-lock.json erzeugt: $dir/package-lock.json"
  else
    warn "Konnte kein package-lock.json erzeugen – es wird npm install (ohne ci) verwendet"
  fi
}
generate_lockfile_if_missing "$BACKEND_DIR"

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
API_BASE_URL_FOR_APP=$API_BASE_URL_FOR_APP
OPENROUTER_API_KEY=$OPENROUTER_API_KEY
OPENROUTER_MODEL=$OPENROUTER_MODEL
OPENROUTER_BASE_URL=$OPENROUTER_BASE_URL
OPENROUTER_BUDGET_LIMIT=$OPENROUTER_BUDGET_LIMIT
JWT_SECRET=$JWT_SECRET
SESSION_SECRET=$SESSION_SECRET
ENCRYPTION_KEY=$ENCRYPTION_KEY
ADMIN_EMAIL=$ADMIN_EMAIL
DB_ENGINE=${DB_ENGINE:-none}
DB_HOST=${DB_HOST:-}
DB_PORT=${DB_PORT:-}
DB_NAME=${DB_NAME:-}
DB_USER=${DB_USER:-}
DB_PASS=${DB_PASS:-}
USE_REDIS=$USE_REDIS
USE_S3=$USE_S3
EOF_ENV

mkdir -p "$BACKEND_DIR"
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
DB_ENGINE=${DB_ENGINE:-none}
DB_HOST=${DB_HOST:-}
DB_PORT=${DB_PORT:-}
DB_NAME=${DB_NAME:-}
DB_USER=${DB_USER:-}
DB_PASS=${DB_PASS:-}
USE_REDIS=$USE_REDIS
ADMIN_EMAIL=$ADMIN_EMAIL
EOF_BENV

#--------------- Dockerfiles / Compose -----------------------
write_if_diff "$BACKEND_DIR/Dockerfile.backend" <<'EOF_DOCKER'
# Build stage
FROM node:20-alpine AS build
WORKDIR /app

RUN apk add --no-cache python3 make g++  # native deps falls nötig

# Manifest & Lockfile (npm)
COPY package.json ./
COPY package-lock.json ./

# Install (nutzt Lockfile; fallback auf install)
RUN npm ci --omit=dev || npm install --omit=dev

# Restliche Quellen
COPY . .

# Build (falls vorhanden)
RUN npm run build || true

# Run stage
FROM node:20-alpine
WORKDIR /app
RUN apk add --no-cache curl
COPY --from=build /app /app
ENV NODE_ENV=production
USER node
CMD ["node", "dist/index.js"]
EOF_DOCKER

write_if_diff docker-compose.yml <<EOF_COMPOSE
services:
  backend:
    build:
      context: $BACKEND_DIR
      dockerfile: Dockerfile.backend
    env_file: $BACKEND_DIR/.env
    environment:
      - PORT=${BACKEND_PORT}
    network_mode: "host"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://127.0.0.1:${BACKEND_PORT}/health"]
      interval: 30s
      timeout: 10s
      retries: 3
EOF_COMPOSE

#--------------- Host-Nginx: erst NUR HTTP -------------------
systemctl stop nginx || true
systemctl disable nginx || true

mkdir -p /var/www/certbot
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/certbot /var/www/html

VHOST_PATH="/etc/nginx/sites-available/mrs-unkwn.conf"

write_if_diff "$VHOST_PATH" <<EOF_VHOST_HTTP
server {
    listen 80;
    server_name $DOMAIN;

    # ACME Challenge (Certbot)
    location ^~ /.well-known/acme-challenge/ {
        default_type "text/plain";
        root /var/www/certbot;
    }

    # API (HTTP bis SSL da)
    location /api/ {
        proxy_pass http://127.0.0.1:$BACKEND_PORT/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }

    # APK Download (HTTP → später Redirect auf HTTPS)
    location = /mrs-unkwn.apk {
        root /var/www/html;
        types { }
        default_type application/vnd.android.package-archive;
    }

    location / {
        return 200 "OK";
        add_header Content-Type text/plain;
    }
}
EOF_VHOST_HTTP

ln -sf "$VHOST_PATH" /etc/nginx/sites-enabled/mrs-unkwn.conf
[ -e /etc/nginx/sites-enabled/default ] && rm -f /etc/nginx/sites-enabled/default

nginx -t
systemctl enable nginx
systemctl start nginx

#--------------- Zertifikat via Certbot (webroot) ------------
if [[ "${REISSUE_CERT:-false}" == "true" ]]; then
  info "Erzwinge Neu-Ausstellung des Zertifikats"
  rm -rf /etc/letsencrypt/live/"$DOMAIN" /etc/letsencrypt/archive/"$DOMAIN" /etc/letsencrypt/renewal/"$DOMAIN".conf || true
fi

CERT_OK=false
if certbot certonly --webroot -w /var/www/certbot \
    -d "$DOMAIN" -m "$EMAIL" --agree-tos --no-eff-email --non-interactive; then
  CERT_OK=true
else
  warn "Let's Encrypt Zertifikat konnte nicht ausgestellt werden. HTTPS wird nicht aktiviert."
fi

#--------------- Wenn Zertifikat ok: HTTPS-Konfig schreiben ---
if $CERT_OK; then
  write_if_diff "$VHOST_PATH" <<EOF_VHOST_SSL
server {
    listen 80;
    server_name $DOMAIN;
    location ^~ /.well-known/acme-challenge/ {
        default_type "text/plain";
        root /var/www/certbot;
    }
    location / {
        return 301 https://$DOMAIN\$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # API unter /api → Backend
    location /api/ {
      proxy_pass http://127.0.0.1:$BACKEND_PORT/;
      proxy_http_version 1.1;
      proxy_set_header Host \$host;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto \$scheme;
      proxy_redirect off;
    }

    # APK Download unter https://$DOMAIN/mrs-unkwn.apk
    location = /mrs-unkwn.apk {
      root /var/www/html;
      types { }
      default_type application/vnd.android.package-archive;
      add_header Content-Disposition "attachment; filename=mrs-unkwn.apk";
    }

    # Optional: statische Inhalte
    location / {
      root /var/www/html;
      index index.html;
      try_files \$uri \$uri/ =404;
    }

    client_max_body_size 50m;
}
EOF_VHOST_SSL

  nginx -t && systemctl reload nginx
  info "HTTPS aktiviert."
fi

#--------------- Docker Compose Up (Backend) -----------------
docker compose build backend
docker compose up -d backend

#--------------- Flutter Build (inkl. intl-Fix) --------------
APK_DEST="/var/www/html/mrs-unkwn.apk"
if ! $SKIP_APK; then
  if [[ -n "${APP_DIR:-}" && -d "$APP_DIR" ]]; then
    mkdir -p /var/www/html
    # Fix für intl-Versionskonflikt: hebe intl auf >=0.20.2 an (kompatibel zu flutter_localizations)
    docker run --rm -v "$PWD/$APP_DIR":/app -w /app "$FLUTTER_IMAGE" bash -lc \
      "flutter --version && \
       flutter pub add intl:^0.20.2 || true && \
       flutter clean && flutter pub get && \
       flutter build apk --${BUILD_MODE} ${FLAVOR:+--flavor $FLAVOR} \
       --dart-define=API_BASE_URL=${API_BASE_URL_FOR_APP} \
       --dart-define=OPENROUTER_MODEL=${OPENROUTER_MODEL} && \
       cp build/app/outputs/flutter-apk/app-${BUILD_MODE}.apk /app/app-release.apk"
    cp "$APP_DIR/app-release.apk" "$APK_DEST"
    chown www-data:www-data "$APK_DEST" || true
    info "APK bereit unter $APK_DEST (Download: https://$DOMAIN/mrs-unkwn.apk)"
  else
    warn "Flutter-App-Verzeichnis nicht gefunden – APK-Build übersprungen."
  fi
fi

#--------------- Health Check -------------------------------
sleep 5
default_health="http://127.0.0.1:${BACKEND_PORT}/health"
if curl -sSf "$default_health" >/dev/null 2>&1; then
  info "Backend Healthcheck (lokal) erfolgreich: $default_health"
else
  warn "Backend Healthcheck fehlgeschlagen (lokal): $default_health"
fi

if $CERT_OK; then
  https_health="https://$DOMAIN/api/health"
  if curl -k --silent --fail "$https_health" >/dev/null; then
    info "HTTPS Healthcheck erfolgreich: $https_health"
  else
    warn "HTTPS Healthcheck fehlgeschlagen: $https_health"
  fi
fi

CERT_INFO="$(certbot certificates 2>/dev/null | awk '/Domains: .*'"$DOMAIN"'/,0')"

cat <<SUMMARY
----- Setup Zusammenfassung -----
Domain: $DOMAIN
API-Basis: https://$DOMAIN/api
Backend-Port (intern): $BACKEND_PORT
APK Download: https://$DOMAIN/mrs-unkwn.apk
Docker Befehle:
  docker compose logs -f
  docker compose restart backend
Zertifikat (ausgestellt): $CERT_OK
$CERT_INFO
Konfig gespeichert unter: $CONFIG_FILE
Flutter-Image: $FLUTTER_IMAGE
---------------------------------
SUMMARY

