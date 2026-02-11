# Android SDK API Compatibility Issues

## Summary
The `iterable-flutter-sdk` Android plugin has **31+ API compatibility issues** with Iterable Android SDK 3.6.2.

## Compilation Errors Found

### 1. LogLevel Removed from IterableLogger
**Lines 98-101**: `IterableLogger.LogLevel` is unresolved
- **Issue**: LogLevel enum structure changed or moved
- **Fix**: Need to check new logging API

### 2. Custom Action Handler Signature Changed
**Line 114**: URL handler expects `Function2` but got `Function3`
**Line 123**: Custom action handler expects `Function2` but got `Function3`
- **Issue**: Handler lambdas have wrong number of parameters
- **Fix**: Remove extra parameter or adjust to new API

### 3. Array Type Mismatches
**Lines 210, 245, 287-290**: List vs Array type mismatches
- **Issue**: Methods expect `Array` but receiving `List`
- **Fix**: Convert `List` to `Array` using `.toTypedArray()`

### 4. deviceId Access Changed
**Line 308**: `deviceId` is now private
- **Issue**: Cannot access `IterableApi.getInstance().deviceId` directly
- **Fix**: Use `getUserId()` or alternative public API

### 5. InAppMessage trigger Access Changed
**Line 321**: `trigger` field is now private, `name` is unresolved
- **Issue**: Cannot access `message.trigger` directly
- **Fix**: Use public getter methods

### 6. InAppCloseSource Removed/Renamed
**Lines 356, 432-434**: `IterableInAppCloseSource` is unresolved
- **Issue**: Class renamed or removed
- **Fix**: Check new close source enum name

### 7. trackInApp Method Signatures Changed
**Lines 392, 412**: None of the trackInApp overloads match
- **Issue**: Method signatures changed in Android SDK 3.6.2
- **Fix**: Update to match new signatures

### 8. setAttributionInfo Access Changed
**Line 457**: Method is now package-private
- **Issue**: Cannot call `setAttributionInfo` from external packages
- **Fix**: May need alternative approach or request SDK update

### 9. lastPushPayload Removed
**Line 479**: `lastPushPayload` property doesn't exist
- **Issue**: Property removed from API
- **Fix**: May need to cache manually or use alternative

### 10. Type Inference Issues
**Lines 430, 479**: Cannot infer generic types
- **Issue**: Kotlin needs explicit type parameters
- **Fix**: Extract to variables with explicit types

## Action Plan
1. Research Android SDK 3.6.2 API documentation
2. Apply similar fixes as done for iOS
3. Test on Android device
