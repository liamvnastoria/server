@echo off

:: Définir les variables
set APP_NAME=server
set APP_DIR=C:\%APP_NAME%
set SERVICE_NAME=%APP_NAME%
set NGINX_CONF=C:\nginx\conf\%APP_NAME%.conf

:: Mettre à jour le système (non applicable sur Windows, mais vous pouvez installer manuellement les dépendances nécessaires)

:: Installer les dépendances nécessaires (Git, Node.js, Python, etc.)
echo Vérifiez que Git, Node.js et Python sont installés sur votre système.

:: Créer le répertoire pour l'application
echo Création du répertoire de l'application...
mkdir %APP_DIR%

:: Télécharger l'application
echo Téléchargement de l'application...
git clone https://github.com/liamvnastoria/%APP_NAME%.git %APP_DIR%

:: Accéder au répertoire de l'application
cd %APP_DIR%

:: Installer les dépendances (Node.js ou Python)
:: Si Node.js :
:: npm install
:: Si Python :
:: python -m venv venv
:: venv\Scripts\activate
:: pip install -r requirements.txt

:: Configurer Nginx
echo Configuration de Nginx...
(
echo server {
echo     listen 80;
echo     server_name localhost;
echo
echo     location / {
echo         proxy_pass http://localhost:3000; :: Remplacez 3000 par le port utilisé par votre application
echo         proxy_http_version 1.1;
echo         proxy_set_header Upgrade ^$http_upgrade;
echo         proxy_set_header Connection 'upgrade';
echo         proxy_set_header Host ^$host;
echo         proxy_cache_bypass ^$http_upgrade;
echo     }
echo
echo     error_page 404 /404.html;
echo     location = /404.html {
echo         root html;
echo     }
echo }
) > %NGINX_CONF%

:: Démarrer Nginx
echo Démarrage de Nginx...
cd C:\nginx
start nginx.exe

:: Configurer le service Windows
echo Configuration du service Windows...
sc create %SERVICE_NAME% binPath= "%APP_DIR%\start.bat" start= auto
sc start %SERVICE_NAME%

echo Le service %APP_NAME% et le serveur Nginx sont maintenant configurés et en cours d'exécution.
echo Installation terminée !
pause
