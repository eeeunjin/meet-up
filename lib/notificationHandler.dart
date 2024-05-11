import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  @pragma('vm:entry-point')
  static void backgroundHandler(NotificationResponse details) {
    // 액션 추가... 파라미터는 details.payload 방식으로 전달
    print("Response Type in Background : ${details.notificationResponseType}");
  }

  // Notification 초기화
  static void initializeNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
            'high_importance_channel', 'high_importance_notification',
            importance: Importance.max));

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (details) {
        // 액션 추가...
        print(
            "Response Type in ForeGround? : ${details.notificationResponseType}");
      },
      onDidReceiveBackgroundNotificationResponse: backgroundHandler,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        RemoteNotification? notification = message.notification;

        if (notification != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'high_importance_notification',
                importance: Importance.max,
              ),
              iOS: DarwinNotificationDetails(),
            ),
            payload: message.data['test_parameter1'],
          );

          print("수신자 측 메시지 수신");
        }
      },
    );

    // 여기 부터 확인해야 할 듯 함 (test 필요)
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      // 액션 부분 -> 파라미터는 message.data['test_parameter1'] 이런 방식으로...
      // 특정한 목표를 가지고 message를 전달한 경우 (예를 들어 chat 화면을 열어라 이런 느낌)
      print("message: ${message.data['test_parameter1']} ");
    }
  }

  static void getMyDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();

    print("내 디바이스 토큰: $token");
  }

  static Future<void> sendNotificationToDevice(
      {required String deviceToken,
      required String title,
      required String body,
      required Map<String, dynamic> data}) async {
    const serverkey =
        "AAAAWNiWcaw:APA91bHtnbogTuhGYzHpNkZ2ERB4YvHQ_IZT_PWM4O4CbnmIEs7dKUxNrjLiJq4FTZND1Gb_O4fpgWwXJm8xR6pUCnltFmk9i_hJwrM-di_w5FHCKlwPy9KsZ05d0owiSeS_3fpx5qO9";

    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final responseHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverkey',
    };

    final responseBody = {
      'notification': {
        'title': title,
        'body': body,
        'data': data,
      },
      'to': deviceToken,
    };

    final response = await http.post(
      url,
      headers: responseHeaders,
      body: json.encode(responseBody),
    );

    if (response.statusCode == 200) {
      // Notification sent successfully
      print("성공적으로 전송되었습니다.");
      print("$title $body");
    } else {
      // Failed to send notification
      print("전송에 실패하였습니다. (code = ${response.statusCode})");
    }
  }
}
