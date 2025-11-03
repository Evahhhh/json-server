# Dockerfile
FROM node:18

WORKDIR /app

# Copier package.json + package-lock.json pour installer dépendances
COPY package*.json ./
ENV HUSKY=0

RUN npm install --production

# Copier le code
COPY . .

# Construire le projet TypeScript
RUN npm run build

# Exposer le port si nécessaire
EXPOSE 3000

# Lancer le serveur
CMD ["npx", "json-server", "db.json"]
