package com.reiterableCoffee.iterableFlutterTiger

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import com.google.firebase.messaging.FirebaseMessaging
import com.iterable.iterablefluttersdk.IterableFlutterSdkPlugin

class MainActivity : FlutterActivity() {
    
    companion object {
        private const val TAG = "MainActivity"
        private const val PERMISSION_REQUEST_CODE = 1001
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Request notification permission for Android 13+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            requestNotificationPermission()
        }
        
        // Get FCM token
        getFCMToken()
    }

    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                Log.d(TAG, "📱 Requesting notification permission...")
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                    PERMISSION_REQUEST_CODE
                )
            } else {
                Log.d(TAG, "✅ Notification permission already granted")
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        
        when (requestCode) {
            PERMISSION_REQUEST_CODE -> {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Log.d(TAG, "✅ Notification permission granted")
                    getFCMToken()
                } else {
                    Log.w(TAG, "⚠️ Notification permission denied")
                }
            }
        }
    }

    private fun getFCMToken() {
        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
            if (!task.isSuccessful) {
                Log.w(TAG, "❌ Failed to get FCM token", task.exception)
                return@addOnCompleteListener
            }

            // Get the FCM token
            val token = task.result
            Log.d(TAG, "📱 FCM Token: $token")
            
            // Store token in plugin for UI display
            IterableFlutterSdkPlugin.storeDeviceToken(token)
            Log.d(TAG, "✅ Token stored in Flutter plugin")
        }
    }
}
