import 'package:flutter/material.dart';
import 'package:iterable_flutter_sdk/iterable_flutter_sdk.dart';
import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../utils/constants.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _eventNameController = TextEditingController();
  final _eventKeyController = TextEditingController();
  final _eventValueController = TextEditingController();
  final _purchaseIdController = TextEditingController();
  final _purchaseAmountController = TextEditingController();
  
  bool _isLoading = false;
  final List<Map<String, dynamic>> _eventDataFields = [];
  final List<Map<String, String>> _recentEvents = [];

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventKeyController.dispose();
    _eventValueController.dispose();
    _purchaseIdController.dispose();
    _purchaseAmountController.dispose();
    super.dispose();
  }

  void _addDataField() {
    if (_eventKeyController.text.isEmpty || _eventValueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both key and value'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _eventDataFields.add({
        _eventKeyController.text: _eventValueController.text,
      });
      _eventKeyController.clear();
      _eventValueController.clear();
    });
  }

  void _removeDataField(int index) {
    setState(() {
      _eventDataFields.removeAt(index);
    });
  }

  Future<void> _trackEvent() async {
    if (_eventNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an event name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dataFields = <String, dynamic>{};
      for (var field in _eventDataFields) {
        dataFields.addAll(field);
      }

      await IterableFlutterSdk.track(
        eventName: _eventNameController.text,
        dataFields: dataFields.isNotEmpty ? dataFields : null,
      );

      setState(() {
        _recentEvents.insert(0, {
          'name': _eventNameController.text,
          'time': DateTime.now().toString().substring(11, 19),
          'fields': dataFields.toString(),
        });
        if (_recentEvents.length > 10) {
          _recentEvents.removeLast();
        }
      });

      _eventNameController.clear();
      _eventDataFields.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Event tracked successfully'),
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

  Future<void> _trackPurchase() async {
    if (_purchaseIdController.text.isEmpty || _purchaseAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter purchase ID and amount'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.tryParse(_purchaseAmountController.text) ?? 0.0;
      
      await IterableFlutterSdk.trackPurchase(
        total: amount,
        items: [
          CommerceItem(
            id: _purchaseIdController.text,
            name: 'Test Product',
            price: amount,
            quantity: 1,
          ),
        ],
        dataFields: {
          'currency': 'USD',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      setState(() {
        _recentEvents.insert(0, {
          'name': 'Purchase',
          'time': DateTime.now().toString().substring(11, 19),
          'fields': 'ID: ${_purchaseIdController.text}, Amount: \$${amount.toStringAsFixed(2)}',
        });
        if (_recentEvents.length > 10) {
          _recentEvents.removeLast();
        }
      });

      _purchaseIdController.clear();
      _purchaseAmountController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Purchase tracked successfully'),
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

  Future<void> _trackQuickEvent(String eventName, Map<String, dynamic>? dataFields) async {
    try {
      await IterableFlutterSdk.track(
        eventName: eventName,
        dataFields: dataFields,
      );

      setState(() {
        _recentEvents.insert(0, {
          'name': eventName,
          'time': DateTime.now().toString().substring(11, 19),
          'fields': dataFields?.toString() ?? 'No data',
        });
        if (_recentEvents.length > 10) {
          _recentEvents.removeLast();
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ $eventName tracked'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Tracking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quick Events
            Text(
              'Quick Events',
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            Wrap(
              spacing: AppConstants.paddingSmall,
              runSpacing: AppConstants.paddingSmall,
              children: [
                _QuickEventChip(
                  label: 'App Opened',
                  icon: Icons.launch,
                  onTap: () => _trackQuickEvent('App Opened', {
                    'platform': 'Flutter',
                    'timestamp': DateTime.now().toIso8601String(),
                  }),
                ),
                _QuickEventChip(
                  label: 'Button Clicked',
                  icon: Icons.touch_app,
                  onTap: () => _trackQuickEvent('Button Clicked', {
                    'button_name': 'Quick Event',
                  }),
                ),
                _QuickEventChip(
                  label: 'Screen View',
                  icon: Icons.visibility,
                  onTap: () => _trackQuickEvent('Screen View', {
                    'screen_name': 'Events Screen',
                  }),
                ),
                _QuickEventChip(
                  label: 'Item Added',
                  icon: Icons.add_shopping_cart,
                  onTap: () => _trackQuickEvent('Item Added to Cart', {
                    'item_id': 'test_item_123',
                    'item_name': 'Test Product',
                  }),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingLarge),
            const Divider(),
            const SizedBox(height: AppConstants.paddingMedium),

            // Custom Event
            Text(
              'Track Custom Event',
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            CustomTextField(
              label: 'Event Name',
              hint: 'e.g., Product Viewed',
              controller: _eventNameController,
              prefixIcon: Icons.event,
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Data Fields
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Field Key',
                    hint: 'e.g., productId',
                    controller: _eventKeyController,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: CustomTextField(
                    label: 'Field Value',
                    hint: 'e.g., 12345',
                    controller: _eventValueController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: _addDataField,
                    color: AppConstants.primaryColor,
                    iconSize: 32,
                  ),
                ),
              ],
            ),

            if (_eventDataFields.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Event Data Fields:',
                        style: AppConstants.bodyStyle,
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      ..._eventDataFields.asMap().entries.map((entry) {
                        final index = entry.key;
                        final field = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${field.keys.first}: ${field.values.first}',
                                  style: AppConstants.captionStyle,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () => _removeDataField(index),
                                color: Colors.red,
                                iconSize: 20,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppConstants.paddingLarge),

            CustomButton(
              text: 'Track Event',
              onPressed: _trackEvent,
              isLoading: _isLoading,
              icon: Icons.send,
            ),

            const SizedBox(height: AppConstants.paddingLarge),
            const Divider(),
            const SizedBox(height: AppConstants.paddingMedium),

            // Track Purchase
            Text(
              'Track Purchase',
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            CustomTextField(
              label: 'Product ID',
              hint: 'e.g., prod_12345',
              controller: _purchaseIdController,
              prefixIcon: Icons.shopping_bag,
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            CustomTextField(
              label: 'Amount',
              hint: 'e.g., 99.99',
              controller: _purchaseAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.attach_money,
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            CustomButton(
              text: 'Track Purchase',
              onPressed: _trackPurchase,
              isLoading: _isLoading,
              icon: Icons.shopping_cart,
              backgroundColor: AppConstants.secondaryColor,
            ),

            const SizedBox(height: AppConstants.paddingLarge),
            const Divider(),
            const SizedBox(height: AppConstants.paddingMedium),

            // Recent Events
            Text(
              'Recent Events',
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            if (_recentEvents.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.paddingLarge),
                  child: Center(
                    child: Text(
                      'No events tracked yet',
                      style: AppConstants.captionStyle,
                    ),
                  ),
                ),
              )
            else
              ..._recentEvents.map((event) {
                return Card(
                  margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppConstants.primaryColor,
                      child: Icon(Icons.event, color: Colors.white, size: 20),
                    ),
                    title: Text(
                      event['name']!,
                      style: AppConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time: ${event['time']}',
                          style: AppConstants.captionStyle,
                        ),
                        if (event['fields'] != 'No data' && event['fields'] != '{}')
                          Text(
                            event['fields']!,
                            style: AppConstants.captionStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}

class _QuickEventChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickEventChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      avatar: Icon(icon, size: 18),
      onPressed: onTap,
      backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
      labelStyle: const TextStyle(color: AppConstants.primaryColor),
    );
  }
}
