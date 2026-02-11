import Flutter
import UIKit
import IterableSDK
import UserNotifications
import iterable_flutter_sdk

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Set up notification center delegate for Iterable
    UNUserNotificationCenter.current().delegate = self
    
    // Request notification permissions
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted {
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
    // Handle app launch from push notification
    if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
      IterableAppIntegration.application(application, didReceiveRemoteNotification: remoteNotification, fetchCompletionHandler: nil)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // MARK: - Push Notification Methods
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    print("📱 Device Token: \(token)")
    print("📱 Token Length: \(deviceToken.count) bytes")
    
    // Debug: Check if this is sandbox or production
    if deviceToken.count == 32 {
      print("🟢 APNs Environment: SANDBOX (Development)")
    } else {
      print("🔴 APNs Environment: PRODUCTION or Unknown")
    }
    
    // Store token in Flutter plugin so getToken() can return it
    IterableFlutterSdkPlugin.storeDeviceToken(deviceToken)
    
    // Pass token to Iterable SDK - it will cache it
    // When setEmail() is called later, SDK will use the cached token + email to call registerDevice
    IterableAPI.register(token: deviceToken)
    print("✅ Token passed to Iterable SDK (will register when user identity is set)")
  }
  
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
  }
  
  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    // Let Iterable handle the notification
    IterableAppIntegration.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
  }
}

// MARK: - UNUserNotificationCenterDelegate
// FlutterAppDelegate already conforms to UNUserNotificationCenterDelegate
extension AppDelegate {
  public override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Show notifications even when app is in foreground
    if #available(iOS 14.0, *) {
      completionHandler([.badge, .banner, .list, .sound])
    } else {
      completionHandler([.badge, .alert, .sound])
    }
  }
  
  public override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // Let Iterable handle the notification interaction
    IterableAppIntegration.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }
  
  public override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    openSettingsFor notification: UNNotification?
  ) {
    // Handle when user taps "Manage" or "Settings" in notification
  }
}
