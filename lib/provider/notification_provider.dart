import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notificationProvider = Provider((ref) => NotificationService());


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);
   requestNotificationPermissions();

}

 Future<void> requestNotificationPermissions() async {
     final FirebaseMessaging messaging;
       messaging = FirebaseMessaging.instance;

    // Get the FCM token and print it (send to your backend or share with sender)
    messaging.getToken().then((token) {
      print('🔑 FCM Token: $token');
      // TODO: Save/send token to backend or relevant user logic
    });

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔔 User granted permission: ${settings.authorizationStatus}');
  }
