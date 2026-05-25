import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initializeNotificationFramework() async {
    // Request permission from the mobile device OS layout layer
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Fetch the explicit background messaging token for testing target push drops
      String? token = await _fcm.getToken();
      print("======= FCM Device Security Token =======");
      print(token);
      print("========================================");

      // Handle message events while the user is actively inside the app interface
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Received an active foreground notification: ${message.notification?.title}");
      });
    }
  }
}