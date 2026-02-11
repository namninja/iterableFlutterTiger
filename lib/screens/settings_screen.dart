import 'package:flutter/material.dart';
import 'package:iterable_flutter_sdk/iterable_flutter_sdk.dart';
import '../components/custom_button.dart';
import '../components/info_card.dart';
import '../utils/constants.dart';
import '../utils/iterable_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;
  String? _deviceToken;
  bool _isPushEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final token = await IterableFlutterSdk.getToken();
      setState(() {
        _deviceToken = token;
        _isPushEnabled = token != null;
      });
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _loginUser() async {
    setState(() => _isLoading = true);

    try {
      // Set email - automatically registers device token with autoPushRegistration: true
      await IterableFlutterSdk.setEmail(IterableAppConfig.userEmail);
      await _loadSettings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ User logged in - device token auto-registered'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _disablePush() async {
    setState(() => _isLoading = true);

    try {
      await IterableFlutterSdk.disablePush();
      await _loadSettings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Push notifications disabled'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateEmailSubscription(bool subscribed) async {
    try {
      await IterableFlutterSdk.updateSubscriptions(
        emailListIds: null,
        unsubscribedChannelIds: subscribed ? null : [0], // 0 = email channel
        unsubscribedMessageTypeIds: null,
        subscribedMessageTypeIds: null,
        campaignId: null,
        templateId: null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(subscribed ? '✅ Subscribed to email' : '✅ Unsubscribed from email'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Iterable Flutter Tiger',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Version 1.0.0'),
              SizedBox(height: 16),
              Text(
                'A test application for the Iterable Flutter SDK, inspired by IterableTiger React Native app.',
              ),
              SizedBox(height: 16),
              Text(
                'SDK Versions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Flutter SDK: 0.1.0'),
              Text('• iOS SDK: 6.6.3'),
              Text('• Android SDK: 3.6.2'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Push Notifications Section
            Text(
              'Push Notifications',
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            InfoCard(
              title: 'Push Status',
              subtitle: _isPushEnabled ? 'Enabled' : 'Disabled',
              icon: _isPushEnabled ? Icons.notifications_active : Icons.notifications_off,
              backgroundColor: _isPushEnabled
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            if (_deviceToken != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Device Token',
                        style: AppConstants.bodyStyle,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _deviceToken!,
                          style: AppConstants.captionStyle.copyWith(
                            fontFamily: 'monospace',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: AppConstants.paddingMedium),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Login User',
                    onPressed: _loginUser,
                    isLoading: _isLoading,
                    icon: Icons.login,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: CustomButton(
                    text: 'Disable Push',
                    onPressed: _disablePush,
                    isLoading: _isLoading,
                    icon: Icons.notifications_off,
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingLarge),
            const Divider(),
            const SizedBox(height: AppConstants.paddingMedium),

            // Subscription Preferences
            Text(
              'Subscription Preferences',
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Email Notifications'),
                    subtitle: const Text('Receive marketing emails'),
                    value: true,
                    onChanged: _updateEmailSubscription,
                    secondary: const Icon(Icons.email),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('SMS Notifications'),
                    subtitle: const Text('Receive SMS messages'),
                    value: true,
                    onChanged: (value) {
                      // Implement SMS subscription
                    },
                    secondary: const Icon(Icons.sms),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingLarge),
            const Divider(),
            const SizedBox(height: AppConstants.paddingMedium),

            // App Information
            Text(
              'App Information',
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            InfoCard(
              title: 'SDK Version',
              subtitle: '0.1.0',
              icon: Icons.info,
              onTap: _showAboutDialog,
              trailing: const Icon(Icons.chevron_right),
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            InfoCard(
              title: 'Platform',
              subtitle: 'Flutter',
              icon: Icons.flutter_dash,
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            InfoCard(
              title: 'iOS SDK',
              subtitle: '6.6.3',
              icon: Icons.phone_iphone,
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            InfoCard(
              title: 'Android SDK',
              subtitle: '3.6.2',
              icon: Icons.android,
            ),

            const SizedBox(height: AppConstants.paddingLarge),
            const Divider(),
            const SizedBox(height: AppConstants.paddingMedium),

            // Developer Options
            Text(
              'Developer Options',
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            CustomButton(
              text: 'View Logs',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Check console for SDK logs'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: Icons.terminal,
              isOutlined: true,
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            CustomButton(
              text: 'Clear Cache',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: Icons.delete_sweep,
              isOutlined: true,
            ),

            const SizedBox(height: AppConstants.paddingLarge),
            const Divider(),
            const SizedBox(height: AppConstants.paddingMedium),

            // About
            Center(
              child: TextButton.icon(
                onPressed: _showAboutDialog,
                icon: const Icon(Icons.info_outline),
                label: const Text('About Iterable Flutter Tiger'),
              ),
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            Center(
              child: Text(
                'Version 1.0.0',
                style: AppConstants.captionStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
