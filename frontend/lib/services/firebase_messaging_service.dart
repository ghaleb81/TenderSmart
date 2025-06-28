import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:tendersmart/services/token_storage.dart';

class FirebaseMessagingService {
  static final ip = TokenStorage.getIp();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. طلب الصلاحيات (خاصة iOS وأندرويد 13+)
    await _firebaseMessaging.requestPermission();

    // 2. جلب توكن الدخول
    final authToken = await TokenStorage.getToken();
    if (authToken == null) {
      print("❗️لم يتم العثور على توكن المستخدم. لن يتم إرسال device token.");
      return;
    }

    // 3. إنشاء قناة الإشعارات لأندرويد
    const androidDetails = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'يُظهر الإشعارات الواردة أثناء عمل التطبيق',
      importance: Importance.high,
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidDetails);

    // 4. تهيئة الـ plugin للإشعارات المحلية
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // يمكنك معالجة الضغط على الإشعار هنا
      },
    );

    // 5. الاستماع للرسائل أثناء التشغيل
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // 6. الحصول على device token من Firebase
    final newToken = await _firebaseMessaging.getToken();
    print('🔐 FCM Token: $newToken');

    if (newToken != null) {
      final storedToken = await TokenStorage.getDeviceToken();

      if (newToken != storedToken) {
        print("📤 Sending device token to backend...");
        await _sendTokenToBackend(newToken, authToken);
        await TokenStorage.saveDeviceToken(newToken);
      } else {
        print("✅ Device token already up to date.");
      }
    }
  }

  // 📤 إرسال device token إلى Laravel backend
  Future<void> _sendTokenToBackend(String token, String authToken) async {
    final url = Uri.parse(
      "$ip/api/save-device-token",
      // "http://${ip}/api/save-device-token",
    );

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final body = jsonEncode({'device_token': token});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("✅ Token sent to backend successfully.");
      } else {
        print("❌ Error sending token: ${response.statusCode}");
        print("Body: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception sending token: $e");
    }
  }

  // ⬇️ عرض الإشعار محليًا عند استقبال الرسالة
  void _handleMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _local.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: message.data['tender_id'], // يمكن استخدامه عند الضغط
      );
    }
  }
}
