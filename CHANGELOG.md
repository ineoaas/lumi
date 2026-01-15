# Lumi App - Changelog & Code Summary

## Recent Updates

### 1. Home Screen Enhancements

#### Mood Streak Feature
Tracks consecutive days the user has journaled. The streak counter shows how many days in a row the user has made entries.

```dart
int _calculateStreak(List<Map<String, dynamic>> entries) {
  // Sort entries by date (newest first)
  entries.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));

  int streak = 0;
  DateTime checkDate = DateTime.now();

  // If no entry today, start checking from yesterday
  final today = DateTime.now().toIso8601String().split('T')[0];
  final hasToday = entries.any((e) => e['date'] == today);
  if (!hasToday) {
    checkDate = checkDate.subtract(const Duration(days: 1));
  }

  // Count consecutive days with entries
  for (var entry in entries) {
    final entryDate = entry['date'] as String;
    final checkDateStr = checkDate.toIso8601String().split('T')[0];

    if (entryDate == checkDateStr) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else if (entryDate.compareTo(checkDateStr) < 0) {
      break; // Streak broken
    }
  }
  return streak;
}
```

#### Mini Calendar Preview
Shows the last 7 days with mood colors displayed as colored circles.

```dart
Widget _buildMiniCalendar() {
  final now = DateTime.now();
  final daysToShow = 7;

  // Map entries by date for quick lookup
  final entriesByDate = <String, Map<String, dynamic>>{};
  for (var entry in _recentEntries) {
    entriesByDate[entry['date']] = entry;
  }

  // Generate 7 day cells
  return Row(
    children: List.generate(daysToShow, (index) {
      final date = now.subtract(Duration(days: daysToShow - 1 - index));
      final dateStr = date.toIso8601String().split('T')[0];
      final entry = entriesByDate[dateStr];
      return _buildDayCell(date, entry, isToday: index == daysToShow - 1);
    }),
  );
}
```

---

### 2. Color Hex Conversion Fix

Previously, mood colors were incorrectly stored in the database. The fix properly converts HSL hue values to RGB hex colors.

**Before (incorrect):**
```python
hue = result.get('hue', 0)
color_hex = f"#{hue:03d}000"  # Wrong! Produced "#060000" for hue=60
```

**After (correct):**
```python
def hue_to_hex(hue):
    """Convert HSL hue (0-360) to RGB hex color"""
    import colorsys
    if hue is None:
        return "#808080"  # Grey for neutral moods

    # Convert HSL to RGB (saturation=0.85, lightness=0.65)
    r, g, b = colorsys.hls_to_rgb(hue / 360.0, 0.65, 0.85)
    return f"#{int(r*255):02x}{int(g*255):02x}{int(b*255):02x}"
```

**Color mapping:**
| Mood | Hue | Hex Color |
|------|-----|-----------|
| Joyful | 60 | #f5f54e (Yellow) |
| Calm | 120 | #4ef54e (Green) |
| Sad | 240 | #4e4ef5 (Blue) |
| Angry | 0 | #f54e4e (Red) |
| Neutral | None | #808080 (Grey) |

---

### 3. Android Native App Setup

#### ADB Reverse Port Forwarding
Allows the phone to access the backend server through USB connection:

```bash
# Run this command to tunnel port 8000 through USB
adb reverse tcp:8000 tcp:8000
```

This makes `localhost:8000` on the phone point to the computer's backend server.

#### Build Configuration
Updated `android/app/build.gradle.kts` for Android SDK 36:

```kotlin
android {
    compileSdk = 36
    buildToolsVersion = "36.1.0"

    defaultConfig {
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
    }
}
```

---

### 4. Start Scripts

#### Chrome/Web (`start.bat`)
Starts backend and opens Flutter web app in Chrome.

#### Android (`start-android.bat`)
```batch
@echo off
:: Start backend server in new window
start "Lumi Backend" cmd /k "python -m uvicorn backend.main:app --host 0.0.0.0 --port 8000"

:: Wait for backend to start
timeout /t 3 /nobreak > nul

:: Set up USB tunnel
adb reverse tcp:8000 tcp:8000

:: Run Flutter app on phone
flutter run -d R5CW91DQ0HJ
```

---

### 5. Service URL Configuration

The `lumi_service.dart` file contains the backend URL:

```dart
class LumiService {
  // For USB-connected phone (via ADB reverse):
  final String baseUrl = 'http://localhost:8000';

  // For Chrome/Web on same computer:
  // final String baseUrl = 'http://192.168.0.85:8000';
}
```

**When to use each:**
- `localhost:8000` - Phone connected via USB with ADB reverse
- `192.168.0.85:8000` - Chrome browser or phone on same WiFi network

---

## File Structure

```
lumi-demo/
├── backend/
│   └── main.py           # FastAPI server with /predict, /summarize endpoints
├── flutter_app/
│   └── lib/
│       ├── screens/
│       │   ├── home_screen.dart      # Streak + mini calendar
│       │   ├── journal_screen.dart   # Daily journal entry
│       │   ├── calendar_screen.dart  # Full calendar view
│       │   └── chart_of_day_screen.dart
│       └── services/
│           ├── lumi_service.dart     # Backend API calls
│           ├── database_service.dart # Supabase queries
│           └── auth_service.dart     # Authentication
├── start.bat             # Start for Chrome
└── start-android.bat     # Start for Android phone
```

---

## Database Schema (Supabase)

**daily_colors table:**
| Column | Type | Description |
|--------|------|-------------|
| id | uuid | Primary key |
| user_id | uuid | Foreign key to auth.users |
| date | date | Entry date (YYYY-MM-DD) |
| color_hex | text | Mood color (#RRGGBB) |
| mood | text | Emotion name (Joyful, Calm, etc.) |
| mood_score | int | Confidence percentage (0-100) |
| description | text | Journal entry summary |
| created_at | timestamp | Auto-generated |
