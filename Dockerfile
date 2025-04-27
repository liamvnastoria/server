# Utiliser une image de base officielle (par exemple Node.js, Python, ou autre en fonction de votre application)
FROM node:23-slime

# Définir le répertoire de travail à l'intérieur du conteneur
WORKDIR /usr/src/app

# Copier les fichiers de votre application dans le conteneur
COPY . .

# Installer les dépendances de l'application (si c'est un projet Node.js)
RUN npm install

# Exposer le port sur lequel l'application va tourner
EXPOSE 3000

# Commande pour démarrer l'application
CMD ["npm", "start"]
