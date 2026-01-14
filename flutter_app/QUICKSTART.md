# 🚀 Flutter App Quick Start Checklist

## Prerequisites

- [ ] Flutter SDK installed (`flutter --version`)
- [ ] Android Studio or Xcode installed
- [ ] Python backend dependencies installed
- [ ] Backend can run successfully

## Setup Steps

### 1️⃣ Install Flutter Dependencies

```bash
cd c:/Users/sergc/Desktop/lumi-demo/flutter_app
flutter pub get
```

**Expected output**: "Got dependencies!"

---

### 2️⃣ Choose Your Backend URL

**Option A: Android Emulator**
```dart
// In lib/services/lumi_service.dart
final String baseUrl = 'http://10.0.2.2:8000';
```

**Option B: iOS Simulator**
```dart
// In lib/services/lumi_service.dart
final String baseUrl = 'http://127.0.0.1:8000';
```

**Option C: Physical Device (find your IP first)**
```bash
# Windows
ipconfig

# Look for "IPv4 Address" (e.g., 192.168.1.100)
```

```dart
// In lib/services/lumi_service.dart
final String baseUrl = 'http://192.168.1.100:8000';  // Use your IP
```

---

### 3️⃣ Start the Backend

**Open a new terminal** and run:

```bash
cd c:/Users/sergc/Desktop/lumi-demo
cd backend
python -m uvicorn main:app --host 0.0.0.0 --port 8000
```

**Wait for**: `Uvicorn running on http://0.0.0.0:8000`

**Test it**:
```bash
curl http://127.0.0.1:8000
```

Should return: `{"detail":"Not Found"}` (this is good!)

---

### 4️⃣ Run the Flutter App

```bash
cd c:/Users/sergc/Desktop/lumi-demo/flutter_app
flutter run
```

**Select your device** when prompted:
- `1` for Android emulator
- `2` for iOS simulator
- `3` for Chrome (web)
- etc.

---

## Testing the App

### Sample Input

Try entering these in the 5 fields:

1. **Morning**: "Woke up feeling refreshed"
2. **Key moment**: "Got promoted at work"
3. **Interaction**: "Had lunch with a friend"
4. **Challenge**: "Dealt with a difficult client"
5. **Evening**: "Relaxed with a book"

**Expected result**:
- Emotion: "Joyful" or "Optimistic"
- Color: Yellow/Green orb
- Summary: One sentence recap

---

## Troubleshooting

### ❌ "Network error: Failed to connect"

**Check:**
1. Is backend running? Look for "Uvicorn running" message
2. Is the `baseUrl` correct in `lumi_service.dart`?
3. For Android emulator, did you use `10.0.2.2` not `127.0.0.1`?
4. Firewall blocking port 8000?

**Fix:**
```bash
# Test backend manually
curl http://127.0.0.1:8000/calibrate_sample
```

---

### ❌ "Please enter at least one description"

**Fix**: Fill in at least one text field before clicking "Reveal My Color"

---

### ❌ Backend is slow (30+ seconds)

**This is normal!** First run downloads AI models (~500MB).

**Wait for**: Backend terminal shows "Application startup complete"

After first run, it will be fast!

---

### ❌ Flutter device not found

**Check:**
```bash
flutter devices
```

**No devices?**

**Android:**
```bash
# Start emulator
flutter emulators
flutter emulators --launch <emulator_id>
```

**iOS (macOS only):**
```bash
open -a Simulator
```

**Or use Chrome:**
```bash
flutter run -d chrome
```

---

## File Locations

| What | Where |
|------|-------|
| Backend URL config | `lib/services/lumi_service.dart` (line 11) |
| Main screen code | `lib/screens/lumi_home_screen.dart` |
| App theme | `lib/main.dart` |
| Color orb widget | `lib/widgets/color_orb.dart` |

---

## Quick Commands

```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter run -d chrome
flutter run -d emulator-5554

# Build APK
flutter build apk --release

# Clean build
flutter clean && flutter pub get
```

---

## Success Checklist

- [ ] Backend running (see "Uvicorn running" message)
- [ ] Flutter app launched on device/emulator
- [ ] Entered text in at least one field
- [ ] Clicked "Reveal My Color"
- [ ] Saw loading spinner
- [ ] Received emotion result with color orb
- [ ] Read the summary sentence
- [ ] Saw candidate emotions

---

## What's Next?

### Customize It
1. Change colors in `lib/main.dart`
2. Adjust orb size in `lib/screens/lumi_home_screen.dart`
3. Modify placeholders in `_placeholders` list

### Deploy It
1. Build release APK: `flutter build apk --release`
2. Install on phone: `adb install build/app/outputs/flutter-apk/app-release.apk`
3. Share with friends!

### Extend It
- Add history screen to save past analyses
- Implement dark mode
- Add social sharing
- Create emotion trends chart

---

## Support

If you're stuck:

1. Check the [README.md](README.md) for detailed docs
2. Review [ARCHITECTURE.md](ARCHITECTURE.md) to understand structure
3. Read [FLUTTER_APP_SUMMARY.md](../FLUTTER_APP_SUMMARY.md) for overview

**Common issues solved**: See the main README troubleshooting section

---

**Ready? Let's go!** 🎨✨

```bash
flutter run
```