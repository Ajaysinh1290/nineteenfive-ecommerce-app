import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/firebase/notification/notification_service.dart';
import 'package:nineteenfive_ecommerce_app/main.dart';
import 'package:nineteenfive_ecommerce_app/models/chat_data.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/order_details.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/track_order.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? dataFromNotification) async {
      NotificationService.onNotificationClick(dataFromNotification, context);
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      ChatData? chatData;
      if (message.data["screen"] == "chat_screen") {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(StaticData.userData.userId)
            .collection("chat")
            .doc(message.data['chat_id'])
            .get()
            .then((value) {
          if (value.data() != null) {
            chatData = ChatData.fromJson(value.data()!);
          }
        });
      }
      print('in function of local notification service');
      if (chatData != null && !chatData!.isSeenByReceiver||chatData==null) {
        final notificationDetails = NotificationDetails(
            android: AndroidNotificationDetails(
                'high_importance_channel', "nineteenfive channel", "This is our channel",
                importance: Importance.high, priority: Priority.high));

        print('showing notification');
        await _notificationsPlugin.show(id, message.notification!.title,
            message.notification!.body, notificationDetails,
            payload: json.encode(message.data));
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
