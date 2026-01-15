@echo off
echo Starting Lumi App for Android...
echo.

:: Start backend server in a new window
echo [1/3] Starting backend server...
start "Lumi Backend" cmd /k "cd /d c:\Users\sergc\Desktop\lumi-demo && python -m uvicorn backend.main:app --host 0.0.0.0 --port 8000"

:: Wait for backend to start
timeout /t 3 /nobreak > nul

:: Set up ADB reverse port forwarding
echo [2/3] Setting up USB tunnel...
"C:\Users\sergc\AppData\Local\Android\Sdk\platform-tools\adb.exe" reverse tcp:8000 tcp:8000

:: Run Flutter app on connected phone
echo [3/3] Launching Flutter app on phone...
cd /d c:\Users\sergc\Desktop\lumi-demo\flutter_app
flutter run -d R5CW91DQ0HJ

pause
