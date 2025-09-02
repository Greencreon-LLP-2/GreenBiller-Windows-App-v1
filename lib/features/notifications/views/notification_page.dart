import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';

//todo
/// get notfications from api  - not done
/// Displays a notification overlay with a list of notifications.- done
/// with the api assign each notification a type (urgent, late, warning, success, info) - not done
void showNotificationOverlay(BuildContext context) {
  final List<Map<String, String>> notifications = [
    {
      "title": "Order Shipped",
      "message": "Your order #1234 has been shipped.",
      "time": "10:45 AM",
      "type": "success",
    },
    {
      "title": "Late Payment",
      "message": "Payment for invoice #5678 is late.",
      "time": "Today",
      "type": "late",
    },
    {
      "title": "Urgent Alert",
      "message": "Unusual activity detected in your account.",
      "time": "1 hour ago",
      "type": "urgent",
    },
    {
      "title": "System Warning",
      "message": "Low disk space on your server.",
      "time": "Yesterday",
      "type": "warning",
    },
    {
      "title": "Feedback",
      "message": "We value your feedback. Please rate us!",
      "time": "1 week ago",
      "type": "info",
    },
    {
      "title": "New Feature",
      "message": "Check out our new feature in the app.",
      "time": "2 days ago",
      "type": "info",
    },
    {
      "title": "Maintenance Scheduled",
      "message": "Scheduled maintenance on 25th October.",
      "time": "3 days ago",
      "type": "info",
    },
    {
      "title": "Security Update",
      "message": "A new security update is available.",
      "time": "Last week",
      "type": "info",
    },
    {
      "title": "New Message",
      "message": "You have a new message from support.",
      "time": "2 hours ago",
      "type": "info",
    },
    {
      "title": "Account Verification",
      "message": "Please verify your account to continue.",
      "time": "Yesterday",
      "type": "urgent",
    },
  ];

  Color getTypeColor(String type) {
    switch (type) {
      case "urgent":
        return Colors.red;
      case "late":
        return Colors.deepOrange;
      case "warning":
        return Colors.amber.shade700;
      case "success":
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  IconData getTypeIcon(String type) {
    switch (type) {
      case "urgent":
        return Icons.warning_amber;
      case "late":
        return Icons.schedule;
      case "warning":
        return Icons.error_outline;
      case "success":
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) => Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Material(
            borderRadius: BorderRadius.circular(16),
            elevation: 10,
            child: Container(
              width: 600,
              height: 1000,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        final type = notif['type'] ?? 'info';
                        return _buildNotificationTile(
                            notif, type, getTypeColor(type), getTypeIcon(type));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildHeader(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        "Notifications",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}

Widget _buildNotificationTile(
    Map<String, String> notif, String type, Color color, IconData icon) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(
        notif['title'] ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          notif['message'] ?? '',
          style: const TextStyle(fontSize: 14, color: textPrimaryColor),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(notif['time'] ?? '',
              style: const TextStyle(fontSize: 12, color: textPrimaryColor)),
          const SizedBox(height: 8),
          _buildBadge(type, color, icon),
        ],
      ),
    ),
  );
}

Widget _buildBadge(String type, Color color, IconData icon) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          type.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
