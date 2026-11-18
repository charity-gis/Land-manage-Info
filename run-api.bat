@echo off
REM Keeps the LandTrust API running: builds it, starts it, and restarts it
REM if it ever stops. Output also goes to apps\api\api.log so a crash can be
REM diagnosed afterwards. Close this window to stop the API.
title LandTrust API (port 4000)
cd /d "%~dp0apps\api"
call npm run build
:loop
echo [%date% %time%] starting API >> api.log
node dist/main.js >> api.log 2>&1
echo [%date% %time%] API exited with code %errorlevel%, restarting in 3s >> api.log
echo API stopped (code %errorlevel%), restarting in 3 seconds...
timeout /t 3 /nobreak >nul
goto loop
