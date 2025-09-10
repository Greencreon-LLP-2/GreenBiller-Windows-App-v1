import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final payload = Get.arguments as Map<String, dynamic>?;
    final title = payload?['title']?.toString() ?? 'Notification';
    final body = payload?['body']?.toString() ?? 'No details available';
    final date = payload?['date'] != null
        ? DateTime.parse(payload!['date'])
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(body, style: const TextStyle(fontSize: 16)),
                  if (date != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Received on: ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
