import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:greenbiller/features/auth/model/user_model.dart';

class PushNotificationService {
  final Logger logger = Logger();
  Isolate? _isolate;
  ReceivePort? _receivePort;
  bool _isRunning = false;
  bool _requireConsent = false; // Set to true for GDPR consent
  String? _externalUserId;
  String? _emailAddress;
  String? _smsNumber;
  String? _language;
  String? _liveActivityId;

  Future<void> init(String oneSignalAppId) async {
    if (_isRunning) {
      logger.i('Push notification service already running');
      return;
    }
    _isRunning = true;

    try {
      // Initialize OneSignal
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.Debug.setAlertLevel(OSLogLevel.none);
      OneSignal.consentRequired(_requireConsent);
      OneSignal.initialize(oneSignalAppId);

      // Setup Live Activities (iOS-specific)
      OneSignal.LiveActivities.setupDefault();

      // Clear existing notifications
      OneSignal.Notifications.clearAll();

      // Setup observers and listeners
      _setupObservers();

      // Start Isolate for background notification processing
      _receivePort = ReceivePort();
      _isolate = await Isolate.spawn(_notificationIsolate, {
        'sendPort': _receivePort!.sendPort,
        'appId': oneSignalAppId,
      });
      logger.i('Push notification Isolate started');

      // Listen for messages from the Isolate
      _receivePort!.listen((message) {
        if (message is Map<String, dynamic>) {
          logger.i('Received notification in main thread: $message');
          Get.snackbar(
            message['title'] ?? 'New Notification',
            message['body'] ?? 'Notification received',
            backgroundColor: Colors.blue,
            colorText: Colors.white,
          );
          // Navigate to notification details
          Get.toNamed('/notification_details', arguments: message);
        } else if (message is String) {
          logger.e('Push notification error: $message');
        }
      });

      // Initialize In-App Messaging triggers and outcomes
      _setupTriggersAndOutcomes();
    } catch (e, stackTrace) {
      _isRunning = false;
      logger.e('Failed to start push notification service: $e', e, stackTrace);
    }
  }

  void _setupObservers() {
    // Push Subscription Observer
    OneSignal.User.pushSubscription.addObserver((state) {
      logger.i('Push subscription changed: optedIn=${state.current.optedIn}, '
          'id=${state.current.id}, token=${state.current.token}');
    });

    // User State Observer
    OneSignal.User.addObserver((state) {
      logger.i('User state changed: ${state.jsonRepresentation()}');
    });

    // Notification Permission Observer
    OneSignal.Notifications.addPermissionObserver((state) {
      logger.i('Notification permission changed: $state');
    });

    // Notification Click Listener
    OneSignal.Notifications.addClickListener((event) {
      logger.i('Notification clicked: ${event.notification.jsonRepresentation()}');
      Get.toNamed('/notification_details', arguments: {
        'title': event.notification.title,
        'body': event.notification.body,
        'payload': event.notification.rawPayload,
      });
    });

    // Foreground Notification Listener
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      logger.i('Foreground notification: ${event.notification.jsonRepresentation()}');
      event.notification.display(); // Always display notification
      Get.snackbar(
        event.notification.title ?? 'Notification',
        event.notification.body ?? 'New notification received',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    });

    // In-App Message Listeners
    OneSignal.InAppMessages.addClickListener((event) {
      logger.i('In-app message clicked: ${event.result.jsonRepresentation()}');
      Get.snackbar(
        'In-App Message',
        'Clicked: ${event.result.actionId}',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    });
    OneSignal.InAppMessages.addWillDisplayListener((event) {
      logger.i('In-app message will display: ${event.message.messageId}');
    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      logger.i('In-app message displayed: ${event.message.messageId}');
    });
    OneSignal.InAppMessages.addWillDismissListener((event) {
      logger.i('In-app message will dismiss: ${event.message.messageId}');
    });
    OneSignal.InAppMessages.addDidDismissListener((event) {
      logger.i('In-app message dismissed: ${event.message.messageId}');
    });
  }

  void _setupTriggersAndOutcomes() {
    // In-App Messaging Triggers
    OneSignal.InAppMessages.addTrigger('trigger_1', 'one');
    OneSignal.InAppMessages.addTriggers({
      'trigger_2': 'two',
      'trigger_3': 'three',
    });
    OneSignal.InAppMessages.paused(true); // Pause by default, toggle as needed

    // Outcome Events
    OneSignal.Session.addOutcome('normal_1');
    OneSignal.Session.addUniqueOutcome('unique_1');
    OneSignal.Session.addOutcomeWithValue('value_1', 3.2);
  }

  Future<void> setUserData(UserModel user) async {
    try {
      if (user.email != null) {
        _emailAddress = user.email;
        OneSignal.User.addEmail(_emailAddress!);
        logger.i('Set email: $_emailAddress');
      }
      if (user.phone != null) {
        _smsNumber = user.phone;
        OneSignal.User.addSms(_smsNumber!);
        logger.i('Set SMS number: $_smsNumber');
      }
      if (user.username != null) {
        _externalUserId = user.username;
        OneSignal.login(_externalUserId!);
        OneSignal.User.addAlias('username', _externalUserId!);
        logger.i('Set external user ID: $_externalUserId');
      }
      _language = 'en'; // Default language, update as needed
      OneSignal.User.setLanguage(_language!);
      logger.i('Set language: $_language');
    } catch (e, stackTrace) {
      logger.e('Failed to set user data: $e', e, stackTrace);
    }
  }

  Future<void> removeUserData() async {
    try {
      if (_emailAddress != null) {
        OneSignal.User.removeEmail(_emailAddress!);
        logger.i('Removed email: $_emailAddress');
        _emailAddress = null;
      }
      if (_smsNumber != null) {
        OneSignal.User.removeSms(_smsNumber!);
        logger.i('Removed SMS number: $_smsNumber');
        _smsNumber = null;
      }
      if (_externalUserId != null) {
        OneSignal.User.removeAlias('username');
        OneSignal.logout();
        logger.i('Removed external user ID: $_externalUserId');
        _externalUserId = null;
      }
    } catch (e, stackTrace) {
      logger.e('Failed to remove user data: $e', e, stackTrace);
    }
  }

  Future<void> handleConsent(bool consent) async {
    OneSignal.consentGiven(consent);
    logger.i('Set consent to: $consent');
  }

  Future<void> setLocationShared(bool shared) async {
    OneSignal.Location.setShared(shared);
    logger.i('Set location shared to: $shared');
  }

  Future<void> promptForPushPermission() async {
    OneSignal.Notifications.requestPermission(true);
    logger.i('Prompted for push permission');
  }

  Future<void> optIn() async {
    OneSignal.User.pushSubscription.optIn();
    logger.i('Opted in to push notifications');
  }

  Future<void> optOut() async {
    OneSignal.User.pushSubscription.optOut();
    logger.i('Opted out of push notifications');
  }

  Future<void> handleLiveActivity({
    required String activityId,
    String? title,
    String? message,
    int? intValue,
    double? doubleValue,
    bool? boolValue,
  }) async {
    _liveActivityId = activityId;
    try {
      OneSignal.LiveActivities.startDefault(_liveActivityId!, {
        'title': title ?? 'Welcome!',
      }, {
        'message': {'en': message ?? 'Hello World!'},
        if (intValue != null) 'intValue': intValue,
        if (doubleValue != null) 'doubleValue': doubleValue,
        if (boolValue != null) 'boolValue': boolValue,
      });
      logger.i('Started live activity: $_liveActivityId');
    } catch (e, stackTrace) {
      logger.e('Failed to start live activity: $e', e, stackTrace);
    }
  }

  Future<void> enterLiveActivity(String activityId, String token) async {
    _liveActivityId = activityId;
    try {
      OneSignal.LiveActivities.enterLiveActivity(_liveActivityId!, token);
      logger.i('Entered live activity: $_liveActivityId');
    } catch (e, stackTrace) {
      logger.e('Failed to enter live activity: $e', e, stackTrace);
    }
  }

  Future<void> exitLiveActivity(String activityId) async {
    _liveActivityId = activityId;
    try {
      OneSignal.LiveActivities.exitLiveActivity(_liveActivityId!);
      logger.i('Exited live activity: $_liveActivityId');
    } catch (e, stackTrace) {
      logger.e('Failed to exit live activity: $e', e, stackTrace);
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

  static void _notificationIsolate(Map<String, dynamic> params) async {
    final SendPort sendPort = params['sendPort'];
    final String appId = params['appId'];
    final logger = Logger();

    try {
      // Re-initialize OneSignal in the Isolate (required for independent context)
      OneSignal.initialize(appId);
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        final notification = event.notification;
        sendPort.send({
          'title': notification.title,
          'body': notification.body,
          'payload': notification.rawPayload,
        });
        event.notification.display();
        logger.i('Foreground notification in Isolate: ${notification.jsonRepresentation()}');
      });
    } catch (e, stackTrace) {
      logger.e('Isolate error: $e', e, stackTrace);
      sendPort.send('Error: $e');
    }

    // Keep Isolate alive
    await Future.delayed(const Duration(days: 365));
  }
}