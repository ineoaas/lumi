# Flutter App Architecture

## Component Hierarchy

```
LumiApp (main.dart)
│
└── MaterialApp
    │
    └── LumiHomeScreen (screens/lumi_home_screen.dart)
        │
        ├── 5 × TextField (input fields)
        │
        ├── ElevatedButton ("Reveal My Color")
        │
        └── Results Section
            │
            ├── ColorOrb (widgets/color_orb.dart)
            │
            ├── Emotion Label
            │
            ├── Confidence Score
            │
            ├── Method Display
            │
            ├── Summary Container
            │
            └── Candidate Emotions (Wrap widget)
```

## Data Flow

```
User Input (5 text fields)
        ↓
User taps "Reveal My Color"
        ↓
LumiHomeScreen._analyzeDay()
        ↓
LumiService.predictLines(lines)
        ↓
HTTP POST to backend /predict
        ↓
Backend analyzes with ML models
        ↓
JSON response returned
        ↓
LumiService parses response
        ↓
LumiHomeScreen updates state
        ↓
UI rebuilds with results
        ↓
ColorOrb animates to new color
        ↓
User sees emotion + summary
```

## State Management

### LumiHomeScreen State Variables

```dart
_controllers: List<TextEditingController>  // 5 input field controllers
_prediction: Map<String, dynamic>?         // API response data
_isLoading: bool                          // Loading state
_errorMessage: String?                     // Error message
```

### State Transitions

```
Initial State
├── _prediction = null
├── _isLoading = false
└── _errorMessage = null

User Taps Button
├── _isLoading = true
└── _errorMessage = null

API Success
├── _prediction = result
├── _isLoading = false
└── _errorMessage = null

API Error
├── _prediction = null (unchanged)
├── _isLoading = false
└── _errorMessage = error text
```

## Network Layer

### LumiService Responsibilities

1. **Configuration**
   - Store backend URL
   - Manage HTTP headers

2. **API Calls**
   - `predictLines()`: Send 5 lines to /predict
   - `predictText()`: Send single text to /predict_text

3. **Color Conversion**
   - `hueToColor()`: Convert hue (0-360) to Color
   - `hueToLightColor()`: Create pastel version

### Request Format

```json
POST /predict
Content-Type: application/json

{
  "lines": [
    "Morning text",
    "Key moment text",
    "Interaction text",
    "Challenge text",
    "Evening text"
  ]
}
```

### Response Format

```json
{
  "emotion": "Calm",
  "hue": 120,
  "confidence": "85.3%",
  "method": "emotion-model",
  "summary": "Your day summary...",
  "candidates": [...]
}
```

## Widget Composition

### ColorOrb Widget

```
ColorOrb
│
├── AnimatedBuilder (scale animation)
│   │
│   └── Transform.scale
│       │
│       └── AnimatedContainer (color transition)
│           │
│           └── BoxDecoration
│               │
│               ├── shape: circle
│               ├── color: emotion color
│               └── boxShadow: 2 layers
```

**Animation Timeline**:
```
0ms ────────────────────────────────────→ 800ms
     Scale: 0.8 → 1.0 (cubic ease-out)
     Color: oldColor → newColor (cubic ease-in-out)
     Shadow: oldColor glow → newColor glow
```

### Input Field Structure

```
TextField
│
└── InputDecoration
    │
    ├── hintText: placeholder
    ├── filled: true
    ├── fillColor: white
    │
    └── borders:
        ├── default: grey outline
        ├── focused: deep purple (2px)
        └── borderRadius: 12px
```

### Results Section Layout

```
Column
│
├── SizedBox (spacing)
├── ColorOrb (150×150)
├── SizedBox (spacing)
├── Text (emotion label, size 32)
├── Text (confidence, grey)
├── Text (method, italic grey)
├── SizedBox (spacing)
│
├── Container (summary card)
│   ├── padding: 16px
│   ├── background: light color
│   ├── border: emotion color
│   │
│   └── Column
│       ├── Row (icon + "Your Day")
│       └── Text (summary sentence)
│
└── Wrap (candidate emotions)
    │
    └── 3 × Container (emotion chip)
        ├── background: light color
        ├── border: emotion color
        │
        └── Row
            ├── Circle (color dot)
            └── Text (label + score)
```

## Theme Configuration

### Global Theme (main.dart)

```dart
MaterialApp(
  theme: ThemeData(
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: #F5F7FA,

    appBarTheme: {
      backgroundColor: deepPurple,
      foregroundColor: white,
      elevation: 0
    },

    elevatedButtonTheme: {
      backgroundColor: deepPurple,
      foregroundColor: white,
      borderRadius: 12px
    },

    inputDecorationTheme: {
      filled: true,
      fillColor: white,
      borderRadius: 12px
    }
  )
)
```

## Error Handling

### Error Flow

```
try {
  API call
} catch (NetworkError) {
  → Show error message
  → Display SnackBar
  → Set _isLoading = false
  → Set _errorMessage
}

try {
  API call
} catch (APIError) {
  → Parse error response
  → Show specific error
  → Display SnackBar
}
```

### User Feedback

1. **Loading State**
   - Button shows CircularProgressIndicator
   - Button is disabled

2. **Error State**
   - Red error box above button
   - SnackBar at bottom
   - Error message persists until next attempt

3. **Success State**
   - Error cleared
   - Results displayed
   - Animations triggered

## Performance Considerations

### Optimizations

1. **Const Constructors**
   - Static widgets marked const
   - Reduces rebuilds

2. **Controller Disposal**
   - TextEditingControllers disposed in dispose()
   - Prevents memory leaks

3. **Animation Optimization**
   - Single AnimationController per ColorOrb
   - Hardware-accelerated transforms

4. **Lazy Building**
   - Results section only built when data exists
   - Conditional rendering with if statements

### Memory Management

```dart
@override
void dispose() {
  for (var controller in _controllers) {
    controller.dispose();  // Clean up controllers
  }
  _controller.dispose();    // Clean up animation controller
  super.dispose();
}
```

## Platform-Specific Considerations

### Android
- Use `http://10.0.2.2:8000` for localhost
- Request internet permission (auto-added by Flutter)

### iOS
- Use `http://127.0.0.1:8000` for localhost
- App Transport Security allows local HTTP

### Web
- Use `http://127.0.0.1:8000` for localhost
- CORS must be enabled on backend

## Future Enhancements

### Possible Features

1. **History Screen**
   - Save past analyses
   - View emotion trends

2. **Settings Screen**
   - Configure backend URL
   - Adjust animation speeds
   - Toggle dark mode

3. **Sharing**
   - Share results to social media
   - Export as image

4. **Offline Support**
   - Cache recent results
   - Queue requests when offline

5. **Advanced UI**
   - Gradient backgrounds
   - Particle effects
   - More animation options
