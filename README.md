# Iterable Flutter Tiger

A Flutter test application for the Iterable Flutter SDK, inspired by the IterableTiger React Native app.

## Features

- User authentication (email/userId)
- Push notification registration
- In-app messaging
- Event tracking
- User profile management
- Deep link handling
- Custom action handling

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- iOS development: Xcode 12+, iOS 13.4+
- Android development: Android Studio, SDK 21+

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd IterableFlutterTiger
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Iterable API:**
   
   Create a file `lib/utils/iterable_config.dart` and add your credentials:
   
   ```dart
   class IterableConfig {
     static const String apiKey = 'YOUR_API_KEY';
     static const String userEmail = 'YOUR_EMAIL';
     static const String userId = 'YOUR_USER_ID';
     static const String pushIntegrationName = 'YOUR_PUSH_INTEGRATION_NAME';
   }
   ```

4. **iOS Setup:**
   ```bash
   cd ios
   pod install
   cd ..
   ```

5. **Run the app:**
   
   For iOS:
   ```bash
   flutter run -d ios
   ```
   
   For Android:
   ```bash
   flutter run -d android
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # Screen widgets
│   ├── home_screen.dart
│   ├── user_screen.dart
│   ├── events_screen.dart
│   ├── messages_screen.dart
│   └── settings_screen.dart
├── components/               # Reusable UI components
│   ├── custom_button.dart
│   └── custom_text_field.dart
├── utils/                    # Utilities and helpers
│   ├── iterable_config.dart
│   └── navigation.dart
└── models/                   # Data models
    └── iterable_models.dart
```

## Features Overview

### User Management
- Set user email or user ID
- Update user profile fields
- Logout functionality

### Events
- Track custom events
- Track screen views
- Track purchase events

### In-App Messages
- View available messages
- Display messages
- Track message interactions

### Push Notifications
- Register for push notifications
- Handle push received events
- Manage notification preferences

### Settings
- Configure SDK settings
- Enable/disable features
- View SDK information

## Testing

Run tests with:
```bash
flutter test
```

## Version Mapping

| Flutter App | Iterable Flutter SDK | iOS SDK | Android SDK |
|------------|---------------------|---------|-------------|
| 1.0.0      | 0.1.0              | 6.6.3   | 3.6.2       |

## Documentation

- [Iterable Flutter SDK](https://github.com/namninja/iterable-flutter-sdk)
- [Iterable Developer Docs](https://support.iterable.com/hc/en-us/categories/360002296791)

## License

MIT License

## Support

For issues and questions, please open an issue on GitHub.
