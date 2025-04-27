@echo off

REM Définir les variables
set APP_NAME=server
set APP_DIR=C:\%APP_NAME%
set SERVICE_NAME=%APP_NAME%_service

REM Vérifier si les outils nécessaires sont installés
echo Vérification de l'installation de Git et de PowerShell...

REM Vérifier si Git est installé
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Git n'est pas installé, installation de Git...
    REM Ajouter votre méthode pour installer Git si nécessaire
)

REM Vérifier si PowerShell est installé
powershell -Command "Write-Host 'Hello'" > nul 2>&1
if %errorlevel% neq 0 (
    echo PowerShell n'est pas installé, il est nécessaire pour la gestion des services.
    exit /b
)

REM Créer le répertoire pour l'application
echo Création du répertoire de l'application...
mkdir %APP_DIR%

REM Télécharger l'application depuis Git (ou autre méthode)
echo Téléchargement de l'application...
git clone https://github.com/liamvnastoria/%APP_NAME% %APP_DIR%

REM Aller dans le répertoire de l'application
cd %APP_DIR%

REM Installer les dépendances (si nécessaire)
REM Exemple pour Node.js :
REM npm install
REM Exemple pour Python :
REM python -m venv venv
REM .\venv\Scripts\activate
REM pip install -r requirements.txt

REM Créer un fichier PowerShell pour exécuter l'application
echo Nouveau fichier PowerShell pour exécuter l'application...
echo Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command \"& '%APP_DIR%\start.ps1'\"" > %APP_DIR%\start_service.ps1

REM Créer le service Windows
echo Création du service...
sc create %SERVICE_NAME% binPath= "powershell -ExecutionPolicy Bypass -File %APP_DIR%\start_service.ps1" start= auto

REM Démarrer le service
echo Démarrage du service...
sc start %SERVICE_NAME%

echo Le service %APP_NAME% est maintenant installé et en cours d'exécution sur Windows.
