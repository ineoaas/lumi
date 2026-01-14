@echo off
echo ===================================
echo Starting LUMI Project
echo ===================================
echo.

REM Get local IP address
echo Detecting your local IP address...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set IP=%%a
    goto :found
)
:found
set IP=%IP:~1%
echo Your IP address is: %IP%
echo.

REM Start backend server
echo Starting backend server on http://0.0.0.0:8000
start "LUMI Backend" cmd /k "cd /d %~dp0 && python -m uvicorn backend.main:app --host 0.0.0.0 --port 8000"
timeout /t 3 /nobreak >nul

REM Build Flutter web app
echo.
echo Building Flutter web app...
cd flutter_app
call flutter build web --release
if %errorlevel% neq 0 (
    echo Flutter build failed! Make sure Flutter is installed.
    pause
    exit /b 1
)

REM Start web server
echo.
echo Starting web server on http://0.0.0.0:8090
cd build\web
start "LUMI Web Server" cmd /k "python -m http.server 8090"

echo.
echo ===================================
echo LUMI is now running!
echo ===================================
echo.
echo Backend API: http://%IP%:8000
echo Web App (Mobile): http://%IP%:8090
echo Web App (Local): http://localhost:8090
echo.
echo Share the Web App URL with your phone/team to access the app!
echo.
echo Press Ctrl+C in each window to stop the servers.
echo ===================================
pause
