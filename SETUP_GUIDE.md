# LUMI Project Setup Guide

## Quick Start (For Team Members)

### Prerequisites
1. **Python 3.8+** - [Download here](https://www.python.org/downloads/)
2. **Flutter** - [Download here](https://flutter.dev/docs/get-started/install)
3. **Git** - [Download here](https://git-scm.com/downloads)

### First Time Setup

#### 1. Configure Database (Supabase)
```bash
# Copy the example environment file
cp .env.example .env

# Edit .env and add your Supabase credentials:
# SUPABASE_URL=https://your-project.supabase.co
# SUPABASE_KEY=your-anon-key-here
```

Get your Supabase URL and key from:
- Go to your Supabase project dashboard
- Settings → API
- Copy "Project URL" and "anon public" key

#### 2. Install Python Dependencies
```bash
pip install -r requirements.txt
```

#### 3. Install Flutter (if not already installed)

**Windows:**
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git C:\flutter

# Add to PATH (run in PowerShell as Admin)
setx PATH "%PATH%;C:\flutter\bin"

# Verify installation
flutter doctor
```

**macOS/Linux:**
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git ~/flutter

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter doctor
```

### Running the Project

#### Option 1: Easy Startup Script (Recommended)

**Windows:**
```bash
start.bat
```

**macOS/Linux:**
```bash
chmod +x start.sh
./start.sh
```

This will:
- Start the backend API server on port 8000
- Build the Flutter web app
- Start the web server on port 8090
- Display your local IP address for mobile access

#### Option 2: Manual Startup

**Terminal 1 - Backend:**
```bash
python -m uvicorn backend.main:app --host 0.0.0.0 --port 8000
```

**Terminal 2 - Flutter Web:**
```bash
cd flutter_app
flutter build web --release
cd build/web
python -m http.server 8090
```

### Accessing the App

- **On your computer:** http://localhost:8090
- **On your phone (same WiFi):** http://YOUR_IP_ADDRESS:8090
  - Replace `YOUR_IP_ADDRESS` with the IP shown by the startup script
  - Example: http://192.168.0.85:8090

### Troubleshooting

**Port already in use:**
```bash
# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# macOS/Linux
lsof -ti:8000 | xargs kill -9
```

**Backend not connecting:**
- Make sure Python dependencies are installed: `pip install -r requirements.txt`
- Check firewall settings allow connections on ports 8000 and 8090
- Ensure you're on the same WiFi network as your phone

**Flutter build fails:**
- Run `flutter doctor` to check installation
- Run `flutter pub get` in the flutter_app directory

## Project Structure

```
lumi-demo/
├── backend/              # FastAPI backend (Python)
│   ├── main.py          # API endpoints
│   └── core.py          # Emotion analysis engine
├── flutter_app/         # Flutter mobile app
│   └── lib/
│       ├── screens/     # All app screens
│       └── services/    # API client
├── start.bat            # Windows startup script
├── start.sh             # macOS/Linux startup script
└── requirements.txt     # Python dependencies
```

## Features

- Journal entry with 5 daily prompts
- AI-powered emotion analysis
- Color visualization based on emotions
- Calendar view of past entries
- Chart of emotions for the day

## Tech Stack

- **Backend:** Python, FastAPI, Hugging Face Transformers
- **Frontend:** Flutter (Dart)
- **Database:** PostgreSQL (Supabase)
- **ML Models:** Emotion classification + Zero-shot learning

## Database API Endpoints

Once configured, the backend provides these endpoints:

- `POST /predict` - Analyze journal entry and save to database (include `user_id` in request)
- `GET /colors/{user_id}` - Get recent daily colors
- `GET /colors/{user_id}/date/{date}` - Get color for specific date
- `GET /colors/{user_id}/range?start_date=...&end_date=...` - Get colors in date range
- `GET /stats/{user_id}` - Get mood statistics for charts
