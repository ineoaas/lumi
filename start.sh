#!/bin/bash

echo "==================================="
echo "Starting LUMI Project"
echo "==================================="
echo ""

# Get local IP address
echo "Detecting your local IP address..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)
else
    # Linux
    IP=$(hostname -I | awk '{print $1}')
fi
echo "Your IP address is: $IP"
echo ""

# Start backend server
echo "Starting backend server on http://0.0.0.0:8000"
python -m uvicorn backend.main:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
sleep 3

# Build Flutter web app
echo ""
echo "Building Flutter web app..."
cd flutter_app
flutter build web --release
if [ $? -ne 0 ]; then
    echo "Flutter build failed! Make sure Flutter is installed."
    kill $BACKEND_PID
    exit 1
fi

# Start web server
echo ""
echo "Starting web server on http://0.0.0.0:8090"
cd build/web
python -m http.server 8090 &
WEB_PID=$!

echo ""
echo "==================================="
echo "LUMI is now running!"
echo "==================================="
echo ""
echo "Backend API: http://$IP:8000"
echo "Web App (Mobile): http://$IP:8090"
echo "Web App (Local): http://localhost:8090"
echo ""
echo "Share the Web App URL with your phone/team to access the app!"
echo ""
echo "Press Ctrl+C to stop all servers."
echo "==================================="

# Trap Ctrl+C to kill both processes
trap "kill $BACKEND_PID $WEB_PID; exit" INT
wait
