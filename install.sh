#!/bin/bash

# Définir les variables
APP_NAME="server"
APP_DIR="/opt/$APP_NAME"
SERVICE_FILE="/etc/systemd/system/$APP_NAME.service"

# Mettre à jour le système
echo "Mise à jour du système..."
sudo apt-get update -y

# Installer les dépendances nécessaires (par exemple Node.js, Python, ou autres)
echo "Installation des dépendances..."
sudo apt-get install -y curl wget git build-essential

# Créer le répertoire pour l'application
echo "Création du répertoire de l'application..."
sudo mkdir -p $APP_DIR

# Copier l'application dans le répertoire
echo "Téléchargement de l'application..."
# Remplacez cette ligne par la méthode d'installation spécifique à votre application
git clone https://github.com/votre-repository/$APP_NAME.git $APP_DIR

# Accéder au répertoire de l'application
cd $APP_DIR

# Si vous utilisez Node.js, par exemple, installez les dépendances
# npm install
# Ou si c'est Python, vous pouvez faire :
# python3 -m venv venv
# source venv/bin/activate
# pip install -r requirements.txt

# Créer le fichier de service systemd
echo "Création du fichier de service systemd..."
cat <<EOL | sudo tee $SERVICE_FILE > /dev/null
[Unit]
Description=Service $APP_NAME
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$APP_DIR
ExecStart=$APP_DIR/start.sh
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOL

# Donner les permissions nécessaires
sudo chmod +x $APP_DIR/start.sh

# Activer et démarrer le service
echo "Activation et démarrage du service..."
sudo systemctl daemon-reload
sudo systemctl enable $APP_NAME.service
sudo systemctl start $APP_NAME.service

echo "Le service $APP_NAME est maintenant installé et en cours d'exécution."
