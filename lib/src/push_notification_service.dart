import 'dart:async';

import 'package:flutter/foundation.dart';

/// Service that will manage push notifications via Firebase Cloud Messaging.
///
/// Currently stubbed — Firebase is not yet configured for this project.
/// Once Firebase is ready, replace the no-op implementations with real
/// `firebase_messaging` calls.
class PushNotificationService {
  String? _token;

  final StreamController<String> _tokenController =
      StreamController<String>.broadcast();

  final StreamController<NotificationPayload> _foregroundController =
      StreamController<NotificationPayload>.broadcast();

  final StreamController<NotificationPayload> _tapController =
      StreamController<NotificationPayload>.broadcast();

  // ─── Public getters ──────────────────────────────────────────────────

  /// The current device token (null until Firebase is configured).
  String? get token => _token;

  /// Emits whenever the FCM token is refreshed.
  Stream<String> get onTokenRefresh => _tokenController.stream;

  /// Emits when a notification arrives while the app is in the foreground.
  Stream<NotificationPayload> get onForegroundMessage =>
      _foregroundController.stream;

  /// Emits when the user taps a notification (app was in background/terminated).
  Stream<NotificationPayload> get onNotificationTap => _tapController.stream;

  // ─── Lifecycle ───────────────────────────────────────────────────────

  /// Initialise the notification service.
  ///
  /// TODO: Replace with real Firebase init when the project is configured:
  /// ```dart
  /// await Firebase.initializeApp();
  /// final messaging = FirebaseMessaging.instance;
  /// ```
  Future<void> initialize() async {
    debugPrint('[PushNotificationService] initialize() — Firebase not configured yet.');
  }

  /// Request notification permissions from the OS.
  ///
  /// TODO: Replace with:
  /// ```dart
  /// final settings = await FirebaseMessaging.instance.requestPermission();
  /// return settings.authorizationStatus == AuthorizationStatus.authorized;
  /// ```
  Future<bool> requestPermission() async {
    debugPrint('[PushNotificationService] requestPermission() — Firebase not configured yet.');
    return false;
  }

  /// Retrieve the current FCM token.
  ///
  /// TODO: Replace with:
  /// ```dart
  /// _token = await FirebaseMessaging.instance.getToken();
  /// ```
  Future<String?> getToken() async {
    debugPrint('[PushNotificationService] getToken() — Firebase not configured yet.');
    return _token;
  }

  /// Register a callback that is invoked when the user taps a notification
  /// that caused the app to open from a terminated state.
  ///
  /// TODO: Replace with real Firebase `getInitialMessage()` call.
  Future<void> handleInitialMessage() async {
    debugPrint('[PushNotificationService] handleInitialMessage() — Firebase not configured yet.');
  }

  /// Subscribe to a topic (e.g. "company_{id}").
  ///
  /// TODO: Replace with:
  /// ```dart
  /// await FirebaseMessaging.instance.subscribeToTopic(topic);
  /// ```
  Future<void> subscribeToTopic(String topic) async {
    debugPrint('[PushNotificationService] subscribeToTopic($topic) — Firebase not configured yet.');
  }

  /// Unsubscribe from a topic.
  ///
  /// TODO: Replace with:
  /// ```dart
  /// await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  /// ```
  Future<void> unsubscribeFromTopic(String topic) async {
    debugPrint('[PushNotificationService] unsubscribeFromTopic($topic) — Firebase not configured yet.');
  }

  /// Clean up resources.
  void dispose() {
    _tokenController.close();
    _foregroundController.close();
    _tapController.close();
  }
}

// ─── Payload model ──────────────────────────────────────────────────────

/// Lightweight model representing a push notification payload.
///
/// When Firebase is connected, build this from `RemoteMessage`:
/// ```dart
/// NotificationPayload.fromRemoteMessage(RemoteMessage message) => ...
/// ```
class NotificationPayload {
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  const NotificationPayload({
    this.title,
    this.body,
    this.data = const {},
  });

  @override
  String toString() =>
      'NotificationPayload(title: $title, body: $body, data: $data)';
}
