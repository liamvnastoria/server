#!/bin/bash

# Définir les variables
APP_NAME="server"
APP_DIR="/opt/$APP_NAME"
SERVICE_FILE="/etc/systemd/system/$APP_NAME.service"
NGINX_CONF="/etc/nginx/sites-available/$APP_NAME"
NGINX_LINK="/etc/nginx/sites-enabled/$APP_NAME"

# Mettre à jour le système
echo "Mise à jour du système..."
sudo apt-get update -y

# Installer les dépendances nécessaires (par exemple Node.js, Python, ou autres)
echo "Installation des dépendances..."
sudo apt-get install -y curl wget git build-essential nginx

# Créer le répertoire pour l'application
echo "Création du répertoire de l'application..."
sudo mkdir -p $APP_DIR

# Copier l'application dans le répertoire
echo "Téléchargement de l'application..."
git clone https://github.com/liamvnastoria/$APP_NAME.git $APP_DIR

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

# Configurer Nginx
echo "Configuration de Nginx..."
cat <<EOL | sudo tee $NGINX_CONF > /dev/null
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3000; # Remplacez 3000 par le port utilisé par votre application
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    error_page 404 /404.html;
    location = /404.html {
        root /var/www/html;
    }
}
EOL

# Activer la configuration Nginx
sudo ln -s $NGINX_CONF $NGINX_LINK
sudo nginx -t
sudo systemctl restart nginx

echo "Le service $APP_NAME et le serveur Nginx sont maintenant configurés et en cours d'exécution."
echo "Installation terminée !"
echo "Vous pouvez accéder à l'application via http://<votre_ip>."
