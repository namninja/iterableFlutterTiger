import 'package:flutter/material.dart';
import 'package:iterable_flutter_sdk/iterable_flutter_sdk.dart';
import '../components/custom_button.dart';
import '../utils/constants.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<IterableInAppMessage> _messages = [];
  bool _isLoading = false;
  int _messageCount = 0;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);

    try {
      final messages = await IterableFlutterSdk.getInAppMessages();
      setState(() {
        _messages = messages;
        _messageCount = messages.length;
      });
    } catch (e) {
      debugPrint('Error loading messages: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading messages: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showMessage(String messageId) async {
    try {
      await IterableFlutterSdk.showMessage(messageId: messageId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Message shown'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
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

  Future<void> _removeMessage(String messageId) async {
    try {
      await IterableFlutterSdk.removeInAppMessage(messageId: messageId);
      await _loadMessages();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Message removed'),
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

  void _showMessageDetails(IterableInAppMessage message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              const Text(
                'Message Details',
                style: AppConstants.headingStyle,
              ),
              const Divider(),
              const SizedBox(height: AppConstants.paddingMedium),
              _DetailRow('Message ID', message.messageId),
              _DetailRow('Campaign ID', message.campaignId?.toString() ?? 'N/A'),
              _DetailRow('Created At', _formatDate(message.createdAt != null ? DateTime.fromMillisecondsSinceEpoch((message.createdAt! * 1000).toInt()) : null)),
              _DetailRow('Expires At', _formatDate(message.expiresAt != null ? DateTime.fromMillisecondsSinceEpoch((message.expiresAt! * 1000).toInt()) : null)),
              _DetailRow('Read', message.read ? 'Yes' : 'No'),
              _DetailRow('Priority', message.priorityLevel?.toString() ?? 'N/A'),
              const SizedBox(height: AppConstants.paddingLarge),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Show Message',
                      onPressed: () {
                        Navigator.pop(context);
                        _showMessage(message.messageId);
                      },
                      icon: Icons.visibility,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: CustomButton(
                      text: 'Remove',
                      onPressed: () {
                        Navigator.pop(context);
                        _removeMessage(message.messageId);
                      },
                      icon: Icons.delete,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In-App Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMessages,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadMessages,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Stats Card
                    Card(
                      color: AppConstants.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.paddingLarge),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Messages',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _messageCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.message,
                              size: 64,
                              color: Colors.white38,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Messages List
                    if (_messages.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.paddingLarge * 2),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              Text(
                                'No messages available',
                                style: AppConstants.subheadingStyle.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: AppConstants.paddingSmall),
                              const Text(
                                'In-app messages will appear here when sent from Iterable',
                                style: AppConstants.captionStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Messages',
                            style: AppConstants.headingStyle.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          ..._messages.map((message) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: message.read
                                      ? Colors.grey[400]
                                      : AppConstants.primaryColor,
                                  child: Icon(
                                    message.read ? Icons.drafts : Icons.mail,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  'Message ID: ${message.messageId.substring(0, 16)}...',
                                  style: AppConstants.bodyStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      'Campaign: ${message.campaignId ?? 'N/A'}',
                                      style: AppConstants.captionStyle,
                                    ),
                                    Text(
                                      'Created: ${_formatDate(message.createdAt != null ? DateTime.fromMillisecondsSinceEpoch((message.createdAt! * 1000).toInt()) : null)}',
                                      style: AppConstants.captionStyle,
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () => _showMessage(message.messageId),
                                      tooltip: 'Show',
                                      color: AppConstants.primaryColor,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _removeMessage(message.messageId),
                                      tooltip: 'Remove',
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                                onTap: () => _showMessageDetails(message),
                              ),
                            );
                          }),
                        ],
                      ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Actions
                    CustomButton(
                      text: 'Refresh Messages',
                      onPressed: _loadMessages,
                      isLoading: _isLoading,
                      icon: Icons.refresh,
                      isOutlined: true,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppConstants.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppConstants.bodyStyle,
            ),
          ),
        ],
      ),
    );
  }
}
