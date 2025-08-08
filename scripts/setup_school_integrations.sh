#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
CONFIG_DIR="$BACKEND_DIR/src/integrations"
CONFIG_FILE="$CONFIG_DIR/school.config.json"

cd "$BACKEND_DIR"
echo "Installing school integration dependencies..."
npm install ldapjs passport-saml --no-save --package-lock=false

mkdir -p "$CONFIG_DIR"
if [ ! -f "$CONFIG_FILE" ]; then
  cat <<'EOF' > "$CONFIG_FILE"
{
  "ldap": {
    "url": "ldap://school.example.com",
    "baseDN": "dc=example,dc=com"
  },
  "sso": {
    "entryPoint": "https://school.example.com/sso",
    "issuer": "mrs-unkwn"
  }
}
EOF
  echo "Created default config at $CONFIG_FILE"
else
  echo "Config already exists at $CONFIG_FILE"
fi

