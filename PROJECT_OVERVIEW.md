# Iterable Flutter Tiger - Project Overview

## Introduction

Iterable Flutter Tiger is a comprehensive test application for the Iterable Flutter SDK, inspired by the IterableTiger React Native app. It provides a complete implementation of Iterable SDK features in a modern, well-structured Flutter application.

## Architecture

### Project Structure

```
IterableFlutterTiger/
├── lib/
│   ├── main.dart                    # App entry point and navigation
│   ├── components/                  # Reusable UI components
│   │   ├── custom_button.dart       # Button widgets
│   │   ├── custom_text_field.dart   # Input field widgets
│   │   └── info_card.dart           # Card widgets
│   ├── screens/                     # Main app screens
│   │   ├── home_screen.dart         # Dashboard and quick setup
│   │   ├── user_screen.dart         # User management
│   │   ├── events_screen.dart       # Event tracking
│   │   ├── messages_screen.dart     # In-app messages
│   │   └── settings_screen.dart     # App settings
│   ├── utils/                       # Utilities and constants
│   │   ├── iterable_config.dart     # API configuration
│   │   └── constants.dart           # App-wide constants
│   └── models/                      # Data models (future use)
├── android/                         # Android-specific code
├── ios/                             # iOS-specific code
├── test/                            # Unit and widget tests
├── assets/                          # Images, fonts, etc.
├── pubspec.yaml                     # Flutter dependencies
├── README.md                        # Main documentation
├── SETUP_GUIDE.md                   # Detailed setup instructions
├── QUICK_START.md                   # Quick start guide
├── CHANGELOG.md                     # Version history
└── LICENSE                          # MIT License

```

## Design Patterns

### State Management

- **StatefulWidget**: Used for screens with dynamic data
- **setState()**: Simple state management for UI updates
- **Future/async-await**: Asynchronous operations for SDK calls

### Component Architecture

1. **Reusable Components**: Custom widgets for buttons, text fields, and cards
2. **Screen-based Navigation**: Bottom navigation bar with 5 main screens
3. **Separation of Concerns**: Business logic separated from UI code

### UI/UX Design

- **Material Design 3**: Modern, consistent UI following Google's guidelines
- **Card-based Layout**: Information organized in cards for clarity
- **Consistent Spacing**: Using AppConstants for uniform padding/margins
- **Color Scheme**: Primary and secondary colors defined centrally
- **Responsive**: Adapts to different screen sizes

## Features Breakdown

### 1. Home Screen (`home_screen.dart`)

**Purpose**: Dashboard and quick access to common features

**Features**:
- Welcome card with app branding
- Quick Setup button (one-tap configuration)
- Current status display (email, user ID, device token)
- Quick action cards for common tasks
- SDK information panel

**SDK Methods Used**:
- `IterableFlutterSdk.getEmail()`
- `IterableFlutterSdk.getUserId()`
- `IterableFlutterSdk.getToken()`
- `IterableFlutterSdk.setEmail()` (automatically registers device token when `autoPushRegistration: true`)
- `IterableFlutterSdk.track()`

### 2. User Screen (`user_screen.dart`)

**Purpose**: User identity and profile management

**Features**:
- Current user information display
- Set user email with validation
- Set user ID
- Update user profile fields (first name, last name, phone)
- Logout functionality
- Quick test data insertion

**SDK Methods Used**:
- `IterableFlutterSdk.setEmail()`
- `IterableFlutterSdk.setUserId()`
- `IterableFlutterSdk.updateUser()`
- `IterableFlutterSdk.getEmail()`
- `IterableFlutterSdk.getUserId()`

### 3. Events Screen (`events_screen.dart`)

**Purpose**: Event tracking and analytics

**Features**:
- Quick event chips for common events
- Custom event creation with data fields
- Dynamic data field addition/removal
- Purchase tracking with product details
- Recent events history
- Event validation

**SDK Methods Used**:
- `IterableFlutterSdk.track()`
- `IterableFlutterSdk.trackPurchase()`

**Event Types**:
- App Opened
- Button Clicked
- Screen View
- Item Added to Cart
- Custom events with data fields
- Purchase events with commerce items

### 4. Messages Screen (`messages_screen.dart`)

**Purpose**: In-app message management

**Features**:
- List all available in-app messages
- Message statistics (total count)
- Message details modal
- Show/display messages
- Remove messages
- Message status indicators (read/unread)
- Pull-to-refresh

**SDK Methods Used**:
- `IterableFlutterSdk.getInAppMessages()`
- `IterableFlutterSdk.showMessage()`
- `IterableFlutterSdk.removeInAppMessage()`

**Message Information Displayed**:
- Message ID
- Campaign ID
- Created date
- Expires date
- Read status
- Priority level

### 5. Settings Screen (`settings_screen.dart`)

**Purpose**: App configuration and preferences

**Features**:
- Push notification management (enable/disable)
- Device token display
- Subscription preferences (email, SMS)
- SDK version information
- Platform details
- Developer options
- About dialog

**SDK Methods Used**:
- `IterableFlutterSdk.disablePush()`
- `IterableFlutterSdk.getToken()`
- `IterableFlutterSdk.updateSubscriptions()`
- Note: Device token registration happens automatically via `setEmail()`/`setUserId()` when `autoPushRegistration: true`

## Components Library

### CustomButton (`custom_button.dart`)

**Variants**:
- Standard elevated button
- Outlined button
- Button with icon
- Loading state button

**Props**:
- `text`: Button label
- `onPressed`: Callback function
- `isLoading`: Show loading indicator
- `isOutlined`: Outline style
- `icon`: Optional icon
- `backgroundColor`: Custom background color
- `textColor`: Custom text color

### CustomTextField (`custom_text_field.dart`)

**Features**:
- Label with consistent styling
- Placeholder text
- Input validation
- Prefix/suffix icons
- Multiple input types (text, email, phone, number)
- Multi-line support
- Enabled/disabled states

**Props**:
- `label`: Field label
- `hint`: Placeholder text
- `controller`: TextEditingController
- `validator`: Validation function
- `keyboardType`: Input type
- `prefixIcon`: Left icon
- `suffixIcon`: Right widget

### InfoCard (`info_card.dart`)

**Variants**:
- Info card with title and subtitle
- Stat card with icon and value

**Features**:
- Consistent card styling
- Optional leading icon
- Optional trailing widget
- Tap callback support
- Custom background colors

## Constants and Configuration

### AppConstants (`constants.dart`)

**Categories**:

1. **Colors**: Primary, secondary, background, text colors
2. **Spacing**: Padding sizes (small, medium, large, xlarge)
3. **Border Radius**: Consistent corner radii
4. **Text Styles**: Heading, subheading, body, caption styles
5. **Event Names**: Standard event name constants
6. **Storage Keys**: Local storage keys

### IterableConfig (`iterable_config.dart`)

**Configuration Values**:
- API Key
- Test user email
- Test user ID
- Push integration name
- Phone number

**Security Note**: This file is gitignored to prevent committing sensitive data.

## SDK Integration

### Initialization

Location: `main.dart` → `_initializeIterable()`

```dart
await IterableFlutterSdk.initialize(
  apiKey: IterableConfig.apiKey,
  config: IterableConfig(
    pushIntegrationName: IterableConfig.pushIntegrationName,
    autoPushRegistration: true,
    enableEmbeddedMessaging: true,
    logLevel: IterableLogLevel.debug,
  ),
);
```

### URL Handler

Handles deep links from push notifications and in-app messages.

```dart
IterableFlutterSdk.setUrlHandler((url, context) {
  // Handle URL navigation
  return true;
});
```

### Custom Action Handler

Handles custom actions defined in Iterable campaigns.

```dart
IterableFlutterSdk.setCustomActionHandler((action, context) {
  // Handle custom action
  return true;
});
```

## Platform-Specific Configuration

### iOS Configuration

**Files**:
- `ios/Podfile`: CocoaPods dependencies
- `ios/Runner/Info.plist`: App configuration and permissions
- `ios/Runner/AppDelegate.swift`: Push notification setup

**Key Features**:
- Push notification capabilities
- Background modes for remote notifications
- Iterable iOS SDK 6.6.3 integration

**Required Capabilities**:
- Push Notifications
- Background Modes (Remote notifications)

### Android Configuration

**Files**:
- `android/build.gradle`: Project-level configuration
- `android/app/build.gradle`: App-level configuration
- `android/app/src/main/AndroidManifest.xml`: Permissions and components
- `android/app/src/main/kotlin/.../MainActivity.kt`: Main activity

**Key Features**:
- Push notification permissions
- Iterable Android SDK 3.6.2 integration
- MultiDex support for large apps

**Required Permissions**:
- INTERNET
- POST_NOTIFICATIONS (Android 13+)

## Error Handling

### Strategy

1. **Try-Catch Blocks**: All SDK calls wrapped in try-catch
2. **User Feedback**: SnackBar messages for success/error states
3. **Loading States**: Loading indicators during async operations
4. **Validation**: Input validation before SDK calls
5. **Graceful Degradation**: App continues working if SDK calls fail

### Error Messages

- ✅ Success: Green SnackBar with success message
- ❌ Error: Red SnackBar with error details
- ⚠️ Warning: Orange SnackBar for validation issues

## Testing Strategy

### Manual Testing

1. **User Flow Testing**: Test complete user journeys
2. **Feature Testing**: Test each feature independently
3. **Platform Testing**: Test on both iOS and Android
4. **Edge Cases**: Test with invalid inputs, no network, etc.

### Recommended Test Cases

1. **User Authentication**:
   - Set valid email
   - Set invalid email
   - Set user ID
   - Update profile fields

2. **Event Tracking**:
   - Track quick events
   - Track custom events with data
   - Track purchases
   - Verify events in Iterable Dashboard

3. **Push Notifications**:
   - Set user email/ID (automatically registers device token)
   - Receive push notification
   - Handle push tap
   - Disable push

4. **In-App Messages**:
   - List messages
   - Show message
   - Remove message
   - Handle message interactions

## Performance Considerations

### Optimizations

1. **Lazy Loading**: Screens load data only when visible
2. **Caching**: User info cached to reduce SDK calls
3. **Efficient Rebuilds**: Using const constructors where possible
4. **IndexedStack**: Preserves screen state in navigation

### Best Practices

1. **Async/Await**: Proper async handling for smooth UI
2. **Loading States**: Show loading indicators for better UX
3. **Error Handling**: Graceful error handling prevents crashes
4. **Memory Management**: Proper disposal of controllers

## Future Enhancements

### Planned Features

1. **Deep Link Testing Interface**: Test deep link handling
2. **Email Template Preview**: Preview email templates
3. **Advanced Analytics**: Visual analytics dashboard
4. **A/B Testing Visualization**: Show experiment variants
5. **Dark Mode Support**: Theme switching
6. **Localization**: Multi-language support
7. **Offline Support**: Queue events when offline
8. **User Preferences**: Persistent app settings

### Technical Improvements

1. **State Management**: Migrate to Provider or Riverpod
2. **Navigation**: Implement named routes
3. **Testing**: Add unit and widget tests
4. **CI/CD**: Automated build and deployment
5. **Code Generation**: Use freezed for immutable models
6. **API Abstraction**: Service layer for SDK calls

## Development Guidelines

### Code Style

- Follow official Dart style guide
- Use `flutter format` for consistent formatting
- Enable all linter rules in `analysis_options.yaml`
- Prefer `const` constructors
- Use meaningful variable names

### Git Workflow

1. Create feature branch from main
2. Make changes with clear commit messages
3. Test thoroughly on both platforms
4. Submit pull request with description
5. Address code review feedback

### Documentation

- Document all public APIs
- Add inline comments for complex logic
- Update README for new features
- Keep CHANGELOG up to date
- Write clear commit messages

## Comparison with React Native Version

### Similarities

- Same feature set and user flows
- Similar screen organization
- Equivalent functionality for all SDK methods
- Comparable UI/UX design

### Differences

- **Language**: Dart vs JavaScript/TypeScript
- **UI Framework**: Flutter widgets vs React Native components
- **Navigation**: Material NavigationBar vs React Navigation
- **State Management**: setState vs React hooks
- **Styling**: Flutter theme vs StyleSheet
- **Platform Code**: Swift/Kotlin vs Objective-C/Java bridges

### Advantages of Flutter Version

1. **Performance**: Compiled to native code
2. **Hot Reload**: Faster development iteration
3. **Consistent UI**: Same UI on iOS and Android
4. **Rich Widgets**: Extensive widget library
5. **Strong Typing**: Better code safety with Dart

## Resources

### Documentation

- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [Material Design 3](https://m3.material.io/)
- [Iterable Docs](https://support.iterable.com/hc/en-us/categories/360002296791)

### Repositories

- [Iterable Flutter SDK](https://github.com/namninja/iterable-flutter-sdk)
- [Iterable iOS SDK](https://github.com/Iterable/swift-sdk)
- [Iterable Android SDK](https://github.com/Iterable/iterable-android-sdk)
- [IterableTiger (React Native)](https://github.com/namninja/IterableTiger)

## Support

For questions or issues:
1. Check this documentation
2. Review SETUP_GUIDE.md
3. Open an issue on GitHub
4. Contact your Iterable customer success manager

## License

MIT License - See LICENSE file for details.
