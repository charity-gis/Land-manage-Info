@echo off
REM Starts everything LandTrust needs on this computer, then opens the map.
REM Double-click it. Closing the two server windows stops the app.
cd /d "%~dp0"

docker info >nul 2>&1
if errorlevel 1 (
  echo Starting Docker Desktop...
  start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
  :waitdocker
  timeout /t 3 /nobreak >nul
  docker info >nul 2>&1
  if errorlevel 1 goto waitdocker
)

echo Starting database and tile server...
docker compose up -d

echo Starting API and web app in their own windows...
start "LandTrust API (port 4000)" cmd /k "%~dp0run-api.bat"
start "LandTrust web (port 3000)" cmd /k npm --prefix apps/web run dev

echo Waiting for the web app...
:waitweb
timeout /t 3 /nobreak >nul
curl -s -o nul http://localhost:3000/
if errorlevel 1 goto waitweb

start "" http://localhost:3000
