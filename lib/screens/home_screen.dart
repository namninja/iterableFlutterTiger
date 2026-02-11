import 'package:flutter/material.dart';
import 'package:iterable_flutter_sdk/iterable_flutter_sdk.dart';
import '../components/info_card.dart';
import '../components/custom_button.dart';
import '../utils/constants.dart';
import '../utils/iterable_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _email;
  String? _userId;
  String? _deviceToken;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final email = await IterableFlutterSdk.getEmail();
      final userId = await IterableFlutterSdk.getUserId();
      final token = await IterableFlutterSdk.getToken();

      setState(() {
        _email = email;
        _userId = userId;
        _deviceToken = token;
      });
    } catch (e) {
      debugPrint('Error loading user info: $e');
    }
  }

  Future<void> _quickSetup() async {
    setState(() => _isLoading = true);

    try {
      // Set user email (with autoPushRegistration: true, this automatically registers the device token)
      await IterableFlutterSdk.setEmail(IterableAppConfig.userEmail);
      
      // Track app opened event
      await IterableFlutterSdk.track(
        eventName: 'App Opened',
        dataFields: {
          'platform': 'Flutter',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      await _loadUserInfo();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Quick setup completed!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iterable Flutter Tiger'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserInfo,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              Card(
                color: AppConstants.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.flutter_dash,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      const Text(
                        'Welcome to Iterable Flutter Tiger',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      const Text(
                        'Test and explore Iterable SDK features',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Quick Setup
              CustomButton(
                text: 'Quick Setup',
                onPressed: _quickSetup,
                isLoading: _isLoading,
                icon: Icons.rocket_launch,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // User Status
              Text(
                'Current Status',
                style: AppConstants.headingStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              InfoCard(
                title: 'User Email',
                subtitle: _email ?? 'Not set',
                icon: Icons.email,
              ),

              const SizedBox(height: AppConstants.paddingSmall),

              InfoCard(
                title: 'User ID',
                subtitle: _userId ?? 'Not set',
                icon: Icons.person,
              ),

              const SizedBox(height: AppConstants.paddingSmall),

              InfoCard(
                title: 'Device Token',
                subtitle: _deviceToken != null
                    ? '${_deviceToken!.substring(0, 20)}...'
                    : 'Not registered',
                icon: Icons.phonelink,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Quick Actions
              Text(
                'Quick Actions',
                style: AppConstants.headingStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppConstants.paddingSmall,
                crossAxisSpacing: AppConstants.paddingSmall,
                childAspectRatio: 1.5,
                children: [
                  _QuickActionCard(
                    icon: Icons.login,
                    label: 'Login User',
                    onTap: () async {
                      // Set email - this automatically registers device token with autoPushRegistration: true
                      await IterableFlutterSdk.setEmail(IterableAppConfig.userEmail);
                      _loadUserInfo();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ User logged in - device token auto-registered'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.message,
                    label: 'View Messages',
                    onTap: () {
                      // Navigate to messages screen
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.event,
                    label: 'Track Event',
                    onTap: () {
                      // Navigate to events screen
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.person,
                    label: 'Update Profile',
                    onTap: () {
                      // Navigate to user screen
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // SDK Info
              Card(
                color: AppConstants.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Text(
                            'SDK Information',
                            style: AppConstants.bodyStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      _InfoRow('Platform:', 'Flutter'),
                      _InfoRow('SDK Version:', '0.1.0'),
                      _InfoRow('iOS SDK:', '6.6.3'),
                      _InfoRow('Android SDK:', '3.6.2'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppConstants.primaryColor,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              label,
              style: AppConstants.bodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppConstants.captionStyle),
          Text(
            value,
            style: AppConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
