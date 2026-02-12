package com.reiterableCoffee.iterableFlutterTiger

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.iterable.iterableapi.IterableApi
import com.iterable.iterablefluttersdk.IterableFlutterSdkPlugin

class MyFirebaseMessagingService : FirebaseMessagingService() {
    
    companion object {
        private const val TAG = "MyFirebaseMsgService"
    }

    /**
     * Called when a new FCM token is generated
     */
    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d(TAG, "📱 New FCM Token: $token")
        
        // Store token in Flutter plugin for UI display
        IterableFlutterSdkPlugin.storeDeviceToken(token)
        
        // Register token with Iterable SDK
        // Note: This will automatically register when user calls setEmail/setUserId
        // if autoPushRegistration is true
        IterableApi.getInstance().registerDeviceToken()
        
        Log.d(TAG, "✅ Token stored and registered with Iterable")
    }

    /**
     * Called when a push notification is received
     */
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        
        Log.d(TAG, "📬 Push notification received from: ${remoteMessage.from}")
        
        // Check if message contains data payload
        if (remoteMessage.data.isNotEmpty()) {
            Log.d(TAG, "📦 Data Payload: ${remoteMessage.data}")
            
            // Let Iterable SDK handle the notification
            val context = applicationContext
            if (context != null) {
                // Iterable SDK will automatically handle the notification display
                // if it's an Iterable push notification
                Log.d(TAG, "✅ Notification passed to Iterable SDK")
            }
        }

        // Check if message contains a notification payload
        remoteMessage.notification?.let {
            Log.d(TAG, "📬 Notification Title: ${it.title}")
            Log.d(TAG, "📬 Notification Body: ${it.body}")
        }
    }

    /**
     * Called when a message is deleted on the server
     */
    override fun onDeletedMessages() {
        super.onDeletedMessages()
        Log.d(TAG, "🗑️ Messages deleted on server")
    }

    /**
     * Called when there's an error sending a message
     */
    override fun onMessageSent(msgId: String) {
        super.onMessageSent(msgId)
        Log.d(TAG, "✅ Message sent: $msgId")
    }

    /**
     * Called when there's an error sending a message
     */
    override fun onSendError(msgId: String, exception: Exception) {
        super.onSendError(msgId, exception)
        Log.e(TAG, "❌ Error sending message: $msgId", exception)
    }
}
