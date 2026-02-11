# Quick Start Guide

Get up and running with Iterable Flutter Tiger in 5 minutes!

## Prerequisites

- Flutter SDK installed
- iOS: Xcode and CocoaPods installed
- Android: Android Studio installed
- Iterable account and API key

## Steps

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure Iterable

Edit `lib/utils/iterable_config.dart`:

```dart
class IterableConfig {
  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const String userEmail = 'test@example.com';
  // ... other configs
}
```

Get your API key from: Iterable Dashboard → Integrations → API Keys

### 3. iOS Setup (Mac only)

```bash
cd ios
pod install
cd ..
```

### 4. Run the App

**iOS:**
```bash
flutter run -d ios
```

**Android:**
```bash
flutter run -d android
```

### 5. Test Basic Features

1. **Open the app** - You should see the home screen
2. **Tap "Quick Setup"** - This will:
   - Set your test user email (automatically registers device token with `autoPushRegistration: true`)
   - Track an "App Opened" event
3. **Check Iterable Dashboard** - Verify the user and event appear

## That's it! 🎉

You're now ready to explore all features:

- **User Tab**: Manage user identity and profile
- **Events Tab**: Track custom events and purchases
- **Messages Tab**: View and display in-app messages
- **Settings Tab**: Configure push notifications and preferences

## Next Steps

- Read [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed configuration
- Check [README.md](README.md) for feature documentation
- Explore the code to understand the implementation

## Quick Troubleshooting

**App won't build?**
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

**Can't find Iterable SDK?**
- Check that `iterable_flutter_sdk` path in `pubspec.yaml` is correct

**Push notifications not working?**
- iOS: Enable Push Notifications capability in Xcode
- Android: Set up Firebase Cloud Messaging

## Support

Having issues? Check the [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed troubleshooting.
