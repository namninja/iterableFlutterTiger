import 'package:flutter/material.dart';
import 'package:iterable_flutter_sdk/iterable_flutter_sdk.dart';
import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../utils/constants.dart';
import '../utils/iterable_config.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _userIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isLoading = false;
  String? _currentEmail;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _userIdController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    try {
      final email = await IterableFlutterSdk.getEmail();
      final userId = await IterableFlutterSdk.getUserId();

      setState(() {
        _currentEmail = email;
        _currentUserId = userId;
        _emailController.text = email ?? '';
        _userIdController.text = userId ?? '';
      });
    } catch (e) {
      debugPrint('Error loading user info: $e');
    }
  }

  Future<void> _setEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await IterableFlutterSdk.setEmail(_emailController.text.trim());
      await _loadUserInfo();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Email set successfully'),
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

  Future<void> _setUserId() async {
    if (_userIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a user ID'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await IterableFlutterSdk.setUserId(_userIdController.text.trim());
      await _loadUserInfo();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ User ID set successfully'),
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

  Future<void> _updateUser() async {
    setState(() => _isLoading = true);

    try {
      final dataFields = <String, dynamic>{};
      
      if (_firstNameController.text.isNotEmpty) {
        dataFields['firstName'] = _firstNameController.text.trim();
      }
      if (_lastNameController.text.isNotEmpty) {
        dataFields['lastName'] = _lastNameController.text.trim();
      }
      if (_phoneController.text.isNotEmpty) {
        dataFields['phoneNumber'] = _phoneController.text.trim();
      }

      if (dataFields.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in at least one field'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      await IterableFlutterSdk.updateUser(
        dataFields: dataFields,
        mergeNestedObjects: true,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ User profile updated'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _firstNameController.clear();
        _lastNameController.clear();
        _phoneController.clear();
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

  Future<void> _logout() async {
    setState(() => _isLoading = true);

    try {
      // Logout by clearing user identity
      await IterableFlutterSdk.logout();
      await _loadUserInfo();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Logged out successfully'),
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
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Current User Info
              Card(
                color: AppConstants.primaryColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current User',
                        style: AppConstants.subheadingStyle,
                      ),
                      const Divider(),
                      _InfoRow('Email:', _currentEmail ?? 'Not set'),
                      _InfoRow('User ID:', _currentUserId ?? 'Not set'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Set Email Section
              Text(
                'Set User Identity',
                style: AppConstants.headingStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              CustomTextField(
                label: 'Email',
                hint: 'user@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              CustomButton(
                text: 'Set Email',
                onPressed: _setEmail,
                isLoading: _isLoading,
                icon: Icons.check,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              const Divider(),

              const SizedBox(height: AppConstants.paddingMedium),

              CustomTextField(
                label: 'User ID',
                hint: 'user123',
                controller: _userIdController,
                prefixIcon: Icons.person,
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              CustomButton(
                text: 'Set User ID',
                onPressed: _setUserId,
                isLoading: _isLoading,
                icon: Icons.check,
                isOutlined: true,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Update Profile Section
              Text(
                'Update Profile',
                style: AppConstants.headingStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              CustomTextField(
                label: 'First Name',
                hint: 'John',
                controller: _firstNameController,
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              CustomTextField(
                label: 'Last Name',
                hint: 'Doe',
                controller: _lastNameController,
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              CustomTextField(
                label: 'Phone Number',
                hint: '+1234567890',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              CustomButton(
                text: 'Update Profile',
                onPressed: _updateUser,
                isLoading: _isLoading,
                icon: Icons.update,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Quick Actions
              CustomButton(
                text: 'Use Test Email',
                onPressed: () {
                  _emailController.text = IterableAppConfig.userEmail;
                },
                isOutlined: true,
                icon: Icons.flash_on,
              ),
            ],
          ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: AppConstants.captionStyle),
          ),
          Expanded(
            child: Text(
              value,
              style: AppConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
