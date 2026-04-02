# Scheme Sense - Production-Ready Flutter App

A modern fintech Flutter application built with clean architecture principles.

## Project Structure

```
lib/
├── main.dart                       # App entry point with MaterialApp setup
├── constants/
│   └── app_constants.dart         # App-wide constants and configuration
├── models/
│   └── transaction_model.dart     # Data models with JSON serialization
├── services/
│   └── http_service.dart          # HTTP client for API calls
├── screens/
│   └── home_screen.dart           # Main home screen (StatefulWidget)
└── widgets/
    ├── balance_card.dart          # Account balance display card
    └── transaction_tile.dart      # Transaction list item widget
```

## Features

✨ **Modern Design**
- Fintech-style UI with green primary color (#00BFA5)
- Smooth animations and transitions
- Clean, readable typography

🏗️ **Clean Architecture**
- Separated concerns: Models, Services, Screens, Widgets
- Stateful widgets for state management
- Reusable components

🔌 **HTTP Integration**
- RESTful API service layer
- JSON serialization/deserialization
- Error handling and timeouts

## Setup & Installation

### Prerequisites
- Flutter 3.0.0 or higher
- Dart 3.0.0 or higher

### Steps

1. **Clone the project**
   ```bash
   cd "Scheme sense"
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## File Descriptions

### `main.dart`
- Initializes the Flutter app with MaterialApp
- Defines the custom fintech theme
- Sets up routing to HomeScreen

### `models/transaction_model.dart`
- Data model for transactions
- JSON serialization methods (fromJson, toJson)
- Used throughout the app for type safety

### `services/http_service.dart`
- Static HTTP methods for API communication
- Handles GET, POST, PUT, DELETE requests
- Built-in timeout and error handling
- Uses only the `http` package (no dependencies)

### `screens/home_screen.dart`
- Main app screen (StatefulWidget)
- Displays account balance and recent transactions
- Pull-to-refresh functionality
- FAB for adding new transactions

### `widgets/balance_card.dart`
- Custom widget for account balance display
- Gradient background with shadow
- Displays card details

### `widgets/transaction_tile.dart`
- Reusable transaction list item
- Shows transaction details with icons
- Tap interaction support

### `constants/app_constants.dart`
- Centralized configuration
- Theme colors, spacing, font sizes
- Animation durations

## Customization

### Change Theme Colors
Edit `lib/main.dart` → `_buildFintechTheme()` method:
```dart
const greenPrimary = Color(0xFF00BFA5); // Change this
```

### Update API Base URL
Edit `lib/constants/app_constants.dart`:
```dart
static const String apiBaseUrl = 'https://your-api.com';
```

### Add New Models
Create new files in `lib/models/` following the pattern in `transaction_model.dart`

### Add New API Endpoints
Add methods to `lib/services/http_service.dart`

### Create New Screens
Create files in `lib/screens/` and update routing in `main.dart`

### Add Reusable Widgets
Create files in `lib/widgets/` and import as needed

## Production Best Practices

✅ **Implemented**
- Clean architecture with separation of concerns
- StatefulWidget for component state management
- Centralized constants and configuration
- Error handling in API services
- Proper code documentation
- Type-safe models with JSON serialization
- Reusable widget components

📌 **Recommended for Future Enhancement**
- Add Provider/GetX for state management
- Implement local database (SQLite/Hive)
- Add unit and widget tests
- Add CI/CD pipeline
- Implement authentication flow
- Add logging and crash reporting
- Add push notifications
- Implement offline-first architecture

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0              # HTTP client
  cupertino_icons: ^1.0.2   # iOS icons
```

## Standard Flutter Files (Auto-generated)

- `pubspec.yaml` - Project configuration and dependencies
- `pubspec.lock` - Locked dependency versions
- `.gitignore` - Git ignore rules
- `android/` - Android build configuration
- `ios/` - iOS build configuration
- `web/` - Web build configuration

## Testing

To run tests (when added):
```bash
flutter test
```

## Build APK

```bash
flutter build apk --release
```

## Build iOS

```bash
flutter build ios --release
```

## License

Copyright © 2026 Scheme Sense. All rights reserved.
