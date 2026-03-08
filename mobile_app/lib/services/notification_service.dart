import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future init() async {

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(settings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'phishing_alerts',
      'Phishing Alerts',
      description: 'Alerts for phishing messages',
      importance: Importance.max,
    );

    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future showAlert(String message) async {

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'phishing_alerts',
      'Phishing Alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await notifications.show(
      0,
      "⚠ Phishing SMS Detected",
      message,
      details,
    );
  }
}