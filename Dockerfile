# ==========================================
# Étape 1 : deps (installation des dépendances)
# ==========================================
FROM node:24-alpine AS deps
WORKDIR /app
# On copie UNIQUEMENT les fichiers de dépendances pour maximiser le cache
COPY package*.json ./
RUN npm ci

# ==========================================
# Étape 2 : build (compilation TypeScript)
# ==========================================
FROM node:24-alpine AS build
WORKDIR /app
# On récupère les node_modules de l'étape deps
COPY --from=deps /app/node_modules ./node_modules
# On copie le reste des sources
COPY . .
RUN npm run build
# On supprime les dépendances de dev pour alléger l'image finale
RUN npm prune --omit=dev

# ==========================================
# Étape 3 : runtime (image finale ultra-légère)
# ==========================================
FROM node:24-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app

# On copie uniquement ce qui est nécessaire à l'exécution, en tant qu'utilisateur node
COPY --from=build --chown=node:node /app/dist ./dist
COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/package.json ./package.json

# Utilisateur non-root (sécurité)
USER node

# Exposition du port
EXPOSE 3000

# Healthcheck (vérifie que l'app répond)
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Commande de démarrage
CMD ["npm", "start"]
