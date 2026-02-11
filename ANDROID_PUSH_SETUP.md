# Android Push Notifications Setup

## ✅ Gradle Configuration Complete

The following has been configured in your Android project:

### 1. Root-level `build.gradle.kts` ✅
```kotlin
plugins {
  id("com.google.gms.google-services") version "4.4.4" apply false
}
```

### 2. App-level `build.gradle.kts` ✅
```kotlin
plugins {
  id("com.google.gms.google-services")
}

dependencies {
  implementation(platform("com.google.firebase:firebase-bom:34.9.0"))
  implementation("com.google.firebase:firebase-messaging")
  implementation("com.google.firebase:firebase-analytics")
}
```

### 3. Package Name ✅
```
com.reiterableCoffee.iterableFlutterTiger
```
**Matches iOS Bundle ID!**

---

## 🔧 What You Need To Do Next

### Step 1: Get Your `google-services.json` File

1. **Go to Firebase Console**: https://console.firebase.google.com/

2. **Create or Select Your Project**:
   - If new: Click "Add project" → Follow setup wizard
   - If exists: Select your existing project

3. **Add Android App**:
   - Click the Android icon (or "Add app")
   - Enter package name: `com.reiterableCoffee.iterableFlutterTiger`
   - App nickname: "Iterable Flutter Tiger" (optional)
   - Click "Register app"

4. **Download google-services.json**:
   - Firebase will generate the file
   - Click "Download google-services.json"

5. **Place the File**:
   ```bash
   # Copy it to:
   android/app/google-services.json
   ```

### Step 2: Configure Firebase Cloud Messaging in Iterable

1. **Get Server Key from Firebase**:
   - Firebase Console → Project Settings → Cloud Messaging
   - Copy the "Server Key" or use "Cloud Messaging API (V1)"

2. **Add to Iterable Dashboard**:
   - Iterable Dashboard → Settings → Mobile Apps
   - Select/Create your Android app
   - Enter package name: `com.reiterableCoffee.iterableFlutterTiger`
   - Paste Firebase Server Key
   - Save

### Step 3: Test Android Push

1. **Build and run on Android device**:
   ```bash
   flutter run --release
   ```

2. **Grant notification permissions** when prompted

3. **Tap "Quick Setup"** or **"Login User"** button

4. **Check Iterable Dashboard**:
   - Go to Users → Your email
   - Check "Devices" tab
   - Should see Android device token registered

5. **Send a test push** from Iterable Dashboard

---

## 📝 Reference: google-services.json Template

I've created an example file at:
```
android/app/google-services.json.example
```

**⚠️ DO NOT commit the real `google-services.json` to git!**

Add to `.gitignore`:
```
android/app/google-services.json
```

---

## Current Status

### ✅ Completed:
- Gradle plugins configured
- Firebase dependencies added
- Package name matches iOS: `com.reiterableCoffee.iterableFlutterTiger`
- Build configuration ready

### ⏳ Pending:
- [ ] Download `google-services.json` from Firebase Console
- [ ] Place file in `android/app/google-services.json`
- [ ] Configure FCM in Iterable Dashboard
- [ ] Test on Android device

---

## Troubleshooting

### Build Error: "File google-services.json is missing"
**Solution**: Download the file from Firebase Console and place it in `android/app/`

### Build Error: "Plugin with id 'com.google.gms.google-services' not found"
**Solution**: 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

### Push Not Working on Android
**Checklist**:
- [ ] `google-services.json` in correct location
- [ ] Firebase Server Key added to Iterable Dashboard
- [ ] Package name matches in Firebase, Gradle, and Iterable
- [ ] Notification permissions granted on device
- [ ] User logged in (`setEmail()` called)

---

## Quick Commands

```bash
# Clean and rebuild Android
flutter clean
flutter pub get
flutter build apk

# Run on Android device
flutter run --release

# Check Android logs
adb logcat | grep -i firebase
adb logcat | grep -i iterable
```

---

**Next Step**: Download `google-services.json` from Firebase Console and place it in `android/app/` directory! 🔥📱
