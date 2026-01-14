# Quick Setup Guide

## Step 1: Install Flutter Dependencies

```bash
cd flutter_app
flutter pub get
```

## Step 2: Configure Backend URL

Open `lib/services/lumi_service.dart` and set your backend URL:

- **Android Emulator**: `http://10.0.2.2:8000`
- **iOS Simulator**: `http://127.0.0.1:8000`
- **Physical Device**: `http://YOUR_LOCAL_IP:8000`

## Step 3: Start Backend (if not running)

Open a terminal and run:

```bash
cd c:/Users/sergc/Desktop/lumi-demo
cd backend
python -m uvicorn main:app --host 0.0.0.0 --port 8000
```

## Step 4: Run the Flutter App

```bash
flutter run
```

That's it! The app should connect to your backend and work.

## Testing Without a Device

If you don't have a physical device or emulator set up, you can run on Chrome:

```bash
flutter run -d chrome
```

Note: For Chrome, you might need to update the baseUrl to `http://127.0.0.1:8000` in `lumi_service.dart`.
