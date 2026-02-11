# Iterable Flutter Tiger - Setup Guide

This guide will walk you through setting up and running the Iterable Flutter Tiger test app.

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

1. **Flutter SDK** (>=3.0.0)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **For iOS Development:**
   - macOS (required)
   - Xcode 12 or later
   - CocoaPods: `sudo gem install cocoapods`
   - iOS 13.4+ device or simulator

3. **For Android Development:**
   - Android Studio
   - Android SDK (API level 21 or higher)
   - Android device or emulator

4. **Code Editor:**
   - VS Code with Flutter extension, or
   - Android Studio with Flutter plugin

## Installation Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd IterableFlutterTiger
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Configure Iterable API

Create a configuration file with your Iterable credentials:

```bash
# The file lib/utils/iterable_config.dart should already exist
# Edit it and replace the placeholder values
```

Open `lib/utils/iterable_config.dart` and update:

```dart
class IterableConfig {
  static const String apiKey = 'YOUR_ITERABLE_API_KEY';
  static const String userEmail = 'YOUR_TEST_EMAIL@example.com';
  static const String userId = 'YOUR_TEST_USER_ID';
  static const String pushIntegrationName = 'YOUR_PUSH_INTEGRATION_NAME';
  static const String phoneNumber = 'YOUR_PHONE_NUMBER';
}
```

**Where to find these values:**

- **API Key**: Iterable Dashboard → Integrations → API Keys
- **Push Integration Name**: Iterable Dashboard → Integrations → Mobile Push
- **User Email/ID**: Use any test email/ID for development
- **Phone Number**: Your test phone number (optional)

### 4. iOS Setup

```bash
# Navigate to iOS directory
cd ios

# Install CocoaPods dependencies
pod install

# Return to root directory
cd ..
```

**Additional iOS Configuration:**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your development team in Signing & Capabilities
3. Enable Push Notifications capability:
   - Select Runner target
   - Go to "Signing & Capabilities"
   - Click "+ Capability"
   - Add "Push Notifications"
   - Add "Background Modes" and check "Remote notifications"

**Important for Xcode:**

If you encounter build errors related to "Require Only App-Extension-Safe API":

1. Open Pods project in Xcode
2. Select the following targets:
   - Iterable-React-Native-SDK (if present)
   - RNScreens
3. In Build Settings, search for "Require Only App-Extension-Safe API"
4. Set to "No"

### 5. Android Setup

The Android configuration should work out of the box. If you need Firebase Cloud Messaging:

1. Go to Firebase Console: https://console.firebase.google.com/
2. Create a new project or use an existing one
3. Add an Android app to your project
4. Download `google-services.json`
5. Place it in `android/app/`
6. Update `android/app/build.gradle` to include:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

## Running the App

### iOS Simulator

```bash
# List available iOS simulators
flutter emulators

# Run on iOS simulator
flutter run -d ios
```

Or use specific simulator:

```bash
flutter run -d "iPhone 14 Pro"
```

### iOS Device

```bash
# List connected devices
flutter devices

# Run on connected iOS device
flutter run -d <device-id>
```

### Android Emulator

```bash
# List available Android emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <emulator_id>

# Run the app
flutter run -d android
```

### Android Device

1. Enable Developer Mode on your Android device
2. Enable USB Debugging
3. Connect device via USB
4. Run:

```bash
flutter run -d <device-id>
```

## Troubleshooting

### Flutter Doctor Issues

Run `flutter doctor` and fix any issues it reports:

```bash
flutter doctor -v
```

### iOS Pod Installation Fails

```bash
cd ios
pod deintegrate
pod install
cd ..
```

### Android Build Fails

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Iterable SDK Not Found Error

If you get an error that `iterable_flutter_sdk` is not found:

1. Make sure you have the iterable-flutter-sdk repository cloned
2. Update the path in `pubspec.yaml`:
   ```yaml
   iterable_flutter_sdk:
     path: ../iterable-flutter-sdk
   ```
   Or use pub dependency once published:
   ```yaml
   iterable_flutter_sdk: ^0.1.0
   ```

### Hot Reload Not Working

```bash
# Restart the app
r

# Hot restart (full reload)
R

# Quit
q
```

### Clear Flutter Cache

```bash
flutter clean
flutter pub get
```

## Testing the App

### 1. User Authentication

1. Navigate to the "User" tab
2. Enter your email address
3. Tap "Set Email"
4. Verify in Iterable Dashboard that the user appears

### 2. Push Notifications

1. Navigate to "Home" tab
2. Tap "Register Push" or use "Quick Setup"
3. Check that device token appears
4. Send a test push from Iterable Dashboard

### 3. Event Tracking

1. Navigate to "Events" tab
2. Use quick events or create custom events
3. Verify events appear in Iterable Dashboard

### 4. In-App Messages

1. Create an in-app message in Iterable Dashboard
2. Navigate to "Messages" tab
3. Tap refresh to load messages
4. Tap on a message to view details
5. Tap "Show Message" to display it

### 5. Settings

1. Navigate to "Settings" tab
2. Enable/disable push notifications
3. View SDK information
4. Configure preferences

## Development Tips

### Using Flutter DevTools

```bash
# Launch DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### Viewing Logs

**iOS:**
```bash
# In Xcode, open Console.app or view in Debug Console
```

**Android:**
```bash
# View logcat
flutter logs

# Or use Android Studio's Logcat
```

### Code Formatting

```bash
# Format all Dart files
flutter format .
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

## Next Steps

1. **Customize the UI** - Modify screens and components to match your needs
2. **Add More Features** - Implement additional Iterable SDK features
3. **Test Push Notifications** - Set up push certificates/keys in Iterable
4. **Create Campaigns** - Test with real campaigns from Iterable Dashboard
5. **Monitor Events** - Check event tracking in Iterable Dashboard

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Iterable Developer Documentation](https://support.iterable.com/hc/en-us/categories/360002296791)
- [Iterable iOS SDK Documentation](https://github.com/Iterable/swift-sdk)
- [Iterable Android SDK Documentation](https://github.com/Iterable/iterable-android-sdk)
- [Iterable Flutter SDK Repository](https://github.com/namninja/iterable-flutter-sdk)

## Support

For issues specific to:
- **Flutter App**: Open an issue in this repository
- **Iterable SDK**: Check the iterable-flutter-sdk repository
- **Iterable Platform**: Contact your Iterable customer success manager

## License

MIT License - See LICENSE file for details
