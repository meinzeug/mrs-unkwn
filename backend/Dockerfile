# Build stage
FROM node:20-alpine AS build
WORKDIR /app

RUN apk add --no-cache python3 make g++  # native deps falls nötig

# Manifest + Lockfiles zuerst (Cache)
COPY package.json ./
COPY package-lock.json . 2>/dev/null || true
COPY yarn.lock . 2>/dev/null || true
COPY pnpm-lock.yaml . 2>/dev/null || true

# Corepack aktivieren für yarn/pnpm
RUN corepack enable

# Install je nach Lockfile
RUN if [ -f pnpm-lock.yaml ]; then \
      pnpm install --frozen-lockfile --prod; \
    elif [ -f yarn.lock ]; then \
      yarn install --production --frozen-lockfile; \
    elif [ -f package-lock.json ]; then \
      npm ci --omit=dev; \
    else \
      npm install --omit=dev; \
    fi

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
