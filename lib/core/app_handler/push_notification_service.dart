import 'dart:async';
import 'dart:isolate';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotificationService {
  final logger = Logger();
  Isolate? _isolate;
  ReceivePort? _receivePort;
  bool _isRunning = false;

  Future<void> init(String oneSignalAppId) async {
    if (_isRunning) {
      logger.i('Push notification service already running');
      return;
    }
    _isRunning = true;

    try {
      // Initialize OneSignal
      OneSignal.shared.setAppId(oneSignalAppId);
      OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
        logger.i('Notification opened: ${result.notification.jsonRepresentation()}');
        // Handle notification tap (e.g., navigate to specific screen)
        Get.toNamed('/notification_details', arguments: result.notification.payload);
      });

      // Start Isolate for background notification processing
      _receivePort = ReceivePort();
      _isolate = await Isolate.spawn(_notificationIsolate, _receivePort!.sendPort);
      logger.i('Push notification Isolate started');

      _receivePort!.listen((message) {
        if (message is Map<String, dynamic>) {
          logger.i('Received notification in main thread: $message');
          Get.snackbar('Notification', message['title'] ?? 'New Notification',
              backgroundColor: Colors.blue, colorText: Colors.white);
        }
      });
    } catch (e, stackTrace) {
      _isRunning = false;
      logger.e('Failed to start push notification service: $e', e, stackTrace);
    }
  }

  void stop() {
    if (_isRunning) {
      _isolate?.kill(priority: Isolate.immediate);
      _receivePort?.close();
      _isRunning = false;
      logger.i('Push notification Isolate stopped');
    }
  }

  static void _notificationIsolate(SendPort sendPort) async {
    // Simulate background notification processing
    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      final notification = event.notification;
      sendPort.send({
        'title': notification.title,
        'body': notification.body,
        'payload': notification.rawPayload,
      });
      event.complete(notification); // Show the notification
    });

    // Keep Isolate alive
    await Future.delayed(Duration(days: 365));
  }
}