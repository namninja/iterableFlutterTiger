# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-02-11

### Added
- Initial release of Iterable Flutter Tiger test app
- Home screen with quick setup and status overview
- User management screen with email/userId authentication
- Events tracking screen with custom events and purchases
- In-app messages screen for viewing and displaying messages
- Settings screen for push notification management
- Navigation bar with 5 main screens
- Comprehensive documentation (README, SETUP_GUIDE, QUICK_START)
- Android and iOS platform configurations
- Integration with iterable_flutter_sdk v0.1.0

### Features
- User Identity Management
  - Set user email
  - Set user ID
  - Update user profile fields
  - Logout functionality

- Event Tracking
  - Quick event buttons for common events
  - Custom event tracking with data fields
  - Purchase tracking with commerce items
  - Recent events history

- In-App Messages
  - List all available messages
  - View message details
  - Show messages
  - Remove messages
  - Message statistics

- Push Notifications
  - Register for push notifications
  - Disable push notifications
  - View device token
  - Push notification status

- Settings & Configuration
  - Enable/disable push notifications
  - Email subscription management
  - SDK version information
  - Developer options

### Technical
- Flutter 3.0+ support
- iOS 13.4+ support
- Android SDK 21+ support
- Material Design 3 UI
- Responsive layout
- Error handling and user feedback
- Pull-to-refresh functionality

### Documentation
- Comprehensive README with features overview
- Detailed SETUP_GUIDE with troubleshooting
- Quick start guide for rapid setup
- Inline code documentation
- Architecture overview

## [Unreleased]

### Planned Features
- Deep link testing interface
- Custom action handler testing
- Email template preview
- User profile viewer
- Advanced event tracking with validation
- Message scheduling interface
- A/B testing visualization
- Analytics dashboard
- Dark mode support
- Localization support

---

## Version Mapping

| Flutter App | Iterable Flutter SDK | iOS SDK | Android SDK |
|------------|---------------------|---------|-------------|
| 1.0.0      | 0.1.0              | 6.6.3   | 3.6.2       |
