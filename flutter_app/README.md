# Lumi Flutter App

A beautiful Flutter mobile app for Lumi AI - emotion-to-color sentiment analysis.

## Features

- 5 text input fields to describe your day
- Real-time emotion analysis using the Lumi AI backend
- Animated color orb visualization
- One-sentence summary of your day
- Alternative emotion candidates display
- Beautiful, modern UI with smooth animations

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Lumi AI backend running (see parent directory)

## Setup

### 1. Install Dependencies

```bash
cd flutter_app
flutter pub get
```

### 2. Configure Backend URL

Edit `lib/services/lumi_service.dart` and update the `baseUrl`:

**For Android Emulator:**
```dart
final String baseUrl = 'http://10.0.2.2:8000';
```

**For iOS Simulator (macOS):**
```dart
final String baseUrl = 'http://127.0.0.1:8000';
```

**For Physical Device on LAN:**
```dart
final String baseUrl = 'http://YOUR_LOCAL_IP:8000';  // e.g., 'http://192.168.1.100:8000'
```

**For Production:**
```dart
final String baseUrl = 'https://your-server.com';
```

### 3. Start the Backend

Make sure the Lumi AI backend is running:

```bash
cd ..  # Go back to lumi-demo root
cd backend
python -m uvicorn main:app --host 0.0.0.0 --port 8000
```

### 4. Run the Flutter App

```bash
# For Android
flutter run

# For iOS
flutter run

# For web (if you want to test in browser)
flutter run -d chrome
```

## Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── screens/
│   │   └── lumi_home_screen.dart      # Main screen with UI
│   ├── services/
│   │   └── lumi_service.dart          # API client for Lumi backend
│   └── widgets/
│       └── color_orb.dart             # Animated color orb widget
├── pubspec.yaml                        # Dependencies
└── README.md                          # This file
```

## How It Works

1. User enters 5 short descriptions of their day
2. Taps "Reveal My Color" button
3. App sends data to Lumi AI backend API
4. Backend analyzes emotion using ML models
5. App displays:
   - Animated color orb with the emotion color
   - Emotion label (Joyful, Calm, Sad, etc.)
   - Confidence score
   - One-sentence summary of the day
   - Alternative emotion candidates

## Customization

### Change Theme Colors

Edit `lib/main.dart` and modify the `ThemeData`:

```dart
theme: ThemeData(
  primarySwatch: Colors.deepPurple,  // Change this
  // ... other theme properties
),
```

### Adjust Orb Size

Edit `lib/screens/lumi_home_screen.dart`:

```dart
ColorOrb(
  color: color,
  size: 150,  // Change this value
),
```

### Modify Animation Duration

Edit `lib/widgets/color_orb.dart`:

```dart
animationDuration: const Duration(milliseconds: 800),  // Change this
```

## Troubleshooting

### "Network Error" or "Connection Refused"

**Problem:** App can't connect to backend.

**Solutions:**
1. Make sure backend is running on port 8000
2. Check `baseUrl` in `lumi_service.dart` is correct
3. For Android emulator, use `10.0.2.2` instead of `localhost`
4. For physical device, use your computer's LAN IP address
5. Make sure firewall allows connections on port 8000

### "Please enter at least one description"

**Problem:** All input fields are empty.

**Solution:** Enter text in at least one of the 5 fields.

### Backend Takes Too Long

**Problem:** First request is very slow.

**Solution:** This is normal! The backend downloads AI models (~500MB) on first run. Subsequent requests will be much faster.

## Building for Production

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS App (requires macOS)

```bash
flutter build ios --release
```

Then open Xcode to archive and distribute.

## API Response Format

The app expects this JSON format from the backend:

```json
{
  "emotion": "Calm",
  "hue": 120,
  "confidence": "85.3%",
  "raw_emotion": "Calm/Relaxed",
  "method": "emotion-model",
  "summary": "You woke up early, got promoted, caught up with a friend.",
  "candidates": [
    {
      "source": "emotion-model",
      "label": "Calm/Relaxed",
      "hue": 120,
      "score": 0.853
    }
  ]
}
```

## License

Same as parent Lumi AI project.
