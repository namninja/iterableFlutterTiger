# Device Token Registration - Fixed Flow

## Summary of Fixes

### 1. **SDK Bug Fixed - Empty Token Registration**
**File**: `iterable-flutter-sdk/ios/Classes/IterableFlutterSdkPlugin.swift`

**Before (BROKEN)**:
```swift
private func registerForPush(result: @escaping FlutterResult) {
  IterableAPI.register(token: Data()) // ❌ Registering EMPTY token!
  result(nil)
}
```

**After (FIXED)**:
```swift
private func registerForPush(result: @escaping FlutterResult) {
  // With autoPushRegistration: true, this happens automatically when setEmail/setUserId is called
  // The actual token registration is handled by the SDK when user identity is set
  result(nil)
}
```

### 2. **SDK Bug Fixed - setEmail/setUserId Not Triggering Auto-Registration**
**File**: `iterable-flutter-sdk/ios/Classes/IterableFlutterSdkPlugin.swift`

**Before (BROKEN)**:
```swift
private func setEmail(...) {
  IterableAPI.email = email  // ❌ Property setter doesn't trigger auto-registration
}

private func setUserId(...) {
  IterableAPI.userId = userId  // ❌ Property setter doesn't trigger auto-registration
}
```

**After (FIXED)**:
```swift
private func setEmail(...) {
  IterableAPI.setEmail(email, nil, nil, nil, nil)  // ✅ Method call triggers auto-registration
}

private func setUserId(...) {
  IterableAPI.setUserId(userId, nil, nil, nil, nil)  // ✅ Method call triggers auto-registration
}
```

### 3. **UI Buttons Fixed to Match Correct Flow**

#### Quick Setup Button
**Before**: Called `registerForPush()` + `setEmail()` + track event  
**After**: Only calls `setEmail()` → auto-registers token → track event

```dart
// Quick Setup now does:
await IterableFlutterSdk.setEmail(IterableAppConfig.userEmail);  // ✅ Auto-registers token
await IterableFlutterSdk.track(eventName: 'App Opened', ...);
```

#### "Login User" Button (was "Register Push")
**Before**: "Register Push" button called `registerForPush()`  
**After**: "Login User" button calls `setEmail()`

```dart
// Home Screen quick action:
_QuickActionCard(
  icon: Icons.login,
  label: 'Login User',
  onTap: () async {
    await IterableFlutterSdk.setEmail(IterableAppConfig.userEmail);  // ✅ Auto-registers
  },
)
```

## How It Works Now

### The Correct Flow (autoPushRegistration: true):

```
1. App Launch
   ├─> Flutter: main() → Initialize Iterable SDK
   └─> iOS: AppDelegate requests notification permissions
   
2. User Grants Permissions
   └─> iOS: registerForRemoteNotifications() called
   
3. APNs Returns Token
   └─> iOS: didRegisterForRemoteNotificationsWithDeviceToken called
       └─> Token stored by iOS SDK (waiting for user identity)
   
4. User Taps "Quick Setup" or "Login User"
   └─> Flutter: setEmail() called
       └─> iOS SDK: Receives email via setEmail() method
           ├─> Creates/updates user in Iterable
           ├─> Retrieves stored device token
           └─> Automatically registers token with Iterable ✅
```

### Key Points:

1. **Token is stored when received from APNs** - even if no user is set yet
2. **Token is registered when user identity is set** - via `setEmail()` or `setUserId()`
3. **No need to call `registerForPush()`** - it's automatic with `autoPushRegistration: true`
4. **All happens in one call** - `setEmail()` handles everything

## Testing on Physical Device

### What You Should See:

1. **App Launch**: Permission prompt appears
2. **Grant Permissions**: App registers for notifications
3. **Check Logs**: Should see:
   ```
   📱 Device Token: <64-character-hex-token>
   📱 Token Length: 32 bytes
   🟢 APNs Environment: SANDBOX (Development)
   ```
4. **Tap "Quick Setup" or "Login User"**: Calls `setEmail()`
5. **Check Iterable Dashboard**: 
   - User should appear
   - Device token should be registered
   - Device should show in user's devices

### If Token Still Not Appearing:

1. **Check app has notification permissions**:
   - iOS Settings → Your App → Notifications → Allow Notifications ON

2. **Verify in AppDelegate logs**:
   - Should see "📱 Device Token: ..." in console
   - If you see "❌ Failed to register..." → permission issue

3. **Check Iterable Dashboard**:
   - Go to Users → Search for your email
   - Click user → Check "Devices" tab
   - Token should appear after calling `setEmail()`

4. **Try logging out and back in**:
   ```dart
   await IterableFlutterSdk.logout();
   await IterableFlutterSdk.setEmail('your@email.com');
   ```

## Files Changed

1. ✅ `iterable-flutter-sdk/ios/Classes/IterableFlutterSdkPlugin.swift`
   - Fixed `setEmail()` to use method instead of property
   - Fixed `setUserId()` to use method instead of property
   - Fixed `logout()` to use method instead of property
   - Fixed `registerForPush()` to not register empty token

2. ✅ `lib/screens/home_screen.dart`
   - Quick Setup: Removed `registerForPush()` call
   - "Login User" button: Changed from `registerForPush()` to `setEmail()`

3. ✅ `lib/screens/settings_screen.dart`
   - Renamed `_registerForPush()` to `_loginUser()`
   - Changed implementation to call `setEmail()` instead of `registerForPush()`
   - Updated button text from "Enable Push" to "Login User"

## Configuration

**File**: `lib/main.dart`
```dart
await IterableFlutterSdk.initialize(
  apiKey: IterableAppConfig.apiKey,
  config: IterableConfig(
    autoPushRegistration: true,  // ✅ Enables automatic registration
    enableEmbeddedMessaging: true,
  ),
);
```

## Summary

**The magic happens in ONE line**:
```dart
await IterableFlutterSdk.setEmail('user@example.com');
```

This single call:
1. ✅ Sets the user email in Iterable
2. ✅ Automatically registers the device token
3. ✅ Associates the token with the user
4. ✅ Ready to receive push notifications

**No `registerForPush()` needed!** 🎉
