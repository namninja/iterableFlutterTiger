# Android Push Notification Testing Guide

## ✅ What Was Fixed

1. **FCM Token Reception** - `MyFirebaseMessagingService` receives and stores FCM tokens
2. **Token UI Display** - Token now stored in `IterableFlutterSdkPlugin` for UI display
3. **Push Notification Handling** - Service receives and processes push notifications
4. **Permission Handling** - MainActivity requests notification permission (Android 13+)
5. **Auto Token Refresh** - Automatic token updates when FCM refreshes

---

## 🔧 Rebuild & Test

### Step 1: Rebuild the App

```bash
cd /Users/nam.ngo/Development/Development-flutter/IterableFlutterTiger

# Clean build
flutter clean
flutter pub get

# Build debug APK
flutter build apk --debug

# Or run directly on connected device
flutter run
```

### Step 2: Install on Device

```bash
# If you built APK
flutter install

# Or if running
flutter run
```

---

## 📱 Testing Checklist

### ✅ **Test 1: Token Display**

1. **Open the app**
2. **Go to Settings screen**
3. **Check "Device Token" section**
4. **Expected:** Should show a long token string (152 characters)
   ```
   Example: dABC123...(long string)
   ```

**If token is NOT showing:**
- Check Android Studio Logcat for:
  ```
  📱 New FCM Token: ...
  ✅ Token stored in Flutter plugin
  ```

---

### ✅ **Test 2: User Login (Required for Push)**

1. **Tap "Login User"** button (or "Quick Setup")
2. **Expected:** 
   - UI shows: "Email: nam.ngo+flutter@iterable.com"
   - Logcat shows: 
     ```
     ✅ Token passed to Iterable SDK
     Device registered with Iterable
     ```

**Why:** Iterable requires a user email/ID before registering the device token.

---

### ✅ **Test 3: Send Test Push**

1. **Go to Iterable Dashboard**
2. **Navigate to:** Messaging → Push Notifications
3. **Create a test campaign**
   - **Audience:** Filter by email = `nam.ngo+flutter@iterable.com`
   - **Message:** Simple title + body
   - **Send:** Send test

4. **Expected on Device:**
   - 🔔 Notification appears in notification tray
   - Tap notification → App opens

---

## 🐛 Troubleshooting

### Issue: Token Not Displaying in UI

**Check Logcat:**
```bash
# Filter for relevant logs
adb logcat | grep -E "FCM Token|IterableFlutterSdk|MyFirebaseMsgService"
```

**Expected logs:**
```
📱 FCM Token: dABC123...
✅ Token stored in Flutter plugin
```

**If missing:**
1. Verify `google-services.json` is in `android/app/`
2. Check Firebase Console → Project Settings → Cloud Messaging → Server Key exists
3. Restart app completely (kill and relaunch)

---

### Issue: Push Not Received

**Checklist:**
1. ✅ User is logged in (`setEmail()` called)
2. ✅ Token registered (check Logcat for "Device registered")
3. ✅ Notification permission granted
4. ✅ App is in background when testing
5. ✅ Firebase Server Key configured in Iterable Dashboard

**Check Notification Permission:**
```kotlin
// Should see in Logcat:
✅ Notification permission granted
```

**If denied:**
- Settings → Apps → Iterable Flutter Tiger → Notifications → Enable

---

### Issue: Push Received but Not Displaying

**Check Logcat:**
```
📬 Push notification received from: ...
📦 Data Payload: {_itbl=...}
✅ Notification passed to Iterable SDK
```

**If you see "received" but no notification:**
1. **App in foreground** - Android may not show notification
2. **Send "Data" message** not "Notification" message from Iterable
3. **Check Iterable payload** - Must include `itbl_` fields

---

## 📊 Expected Log Flow

### On App Launch:
```
📱 Requesting notification permission...
✅ Notification permission granted
📱 FCM Token: dABC123...
✅ Token stored in Flutter plugin
```

### On Login (setEmail):
```
Setting user email: nam.ngo+flutter@iterable.com
📱 Device Token: dABC123...
✅ Token passed to Iterable SDK
✅ Device registered with Iterable
```

### On Push Received:
```
📬 Push notification received from: 123456789
📦 Data Payload: {_itbl_={"campaignId":12345,...}}
📬 Notification Title: Test Push
📬 Notification Body: This is a test
✅ Notification passed to Iterable SDK
```

---

## 🔍 Verify in Iterable Dashboard

1. **Go to:** Audience → Contact Lookup
2. **Search:** `nam.ngo+flutter@iterable.com`
3. **Check "Devices" tab:**
   - Should show Android device
   - With your FCM token
   - Platform: Android
   - Status: Active

---

## 🚀 Quick Test Script

Run this to verify everything:

```bash
# 1. Check if app is running
adb shell ps | grep iterableFlutterTiger

# 2. Check logs for token
adb logcat | grep "FCM Token"

# 3. Send test notification from Iterable Dashboard

# 4. Check if notification received
adb logcat | grep "Push notification received"

# 5. Check if displayed
adb shell dumpsys notification | grep "com.reiterableCoffee.iterableFlutterTiger"
```

---

## ✅ Success Criteria

You should see ALL of these:

1. ✅ **Token in UI** - Settings screen shows device token
2. ✅ **Token in Logcat** - `📱 FCM Token: ...`
3. ✅ **Device in Iterable** - Dashboard shows registered Android device
4. ✅ **Push received** - Notification appears in notification tray
5. ✅ **App opens** - Tapping notification opens app

---

## 📝 Notes

- **First launch:** May take 5-10 seconds to get FCM token
- **Token refresh:** FCM may refresh token periodically (handled automatically)
- **Background vs Foreground:** Push behavior differs (background = notification tray, foreground = in-app)
- **Data vs Notification:** Iterable sends "data" messages, not "notification" messages

---

## 🆘 Still Not Working?

Share these logs:

```bash
# Full relevant logs
adb logcat -d | grep -E "FCM|Iterable|MyFirebase|MainActivity" > android_logs.txt
```

And check:
1. `google-services.json` is valid
2. Firebase project has Android app configured
3. Package name matches: `com.reiterableCoffee.iterableFlutterTiger`
4. Iterable Dashboard has Firebase Server Key configured
