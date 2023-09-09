import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:handover_tacking_task/core/constants.dart';

class NotificationService extends GetxService {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void onInit() async {
    super.onInit();
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
      iOS: DarwinInitializationSettings(),
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        Constants.notificationChannelId,
        Constants.notificationChannelName,
        importance: Importance.max,
        showWhen: false,
        color: Color.fromARGB(255, 251, 175, 3),
      ),
      iOS: DarwinNotificationDetails(

      ),
    );
    await _flutterLocalNotificationsPlugin.show(
      1,
      title,
      body,
      notificationDetails,
    );
  }
}
