import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_ecommerce_app/firebase/database/firebase_database.dart';
import 'package:nineteenfive_ecommerce_app/models/chat_data.dart';
import 'package:nineteenfive_ecommerce_app/models/order.dart';
import 'package:nineteenfive_ecommerce_app/screens/cart/cart_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/contact/chat/chat_screen.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/order_details.dart';
import 'package:nineteenfive_ecommerce_app/screens/order/track_order.dart';
import 'package:nineteenfive_ecommerce_app/utils/data/static_data.dart';
import 'package:url_launcher/url_launcher.dart';

import 'local_notification_service.dart';

class NotificationService {
  static startService(BuildContext context) {
    LocalNotificationService.initialize(context);
    //gives you the message on which user taps and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        onNotificationClick(json.encode(message.data), context);
      }
    });

    //Foreground work
    FirebaseMessaging.onMessage.listen((message) {
      print('got notification bro');
      LocalNotificationService.display(message);
    });

    //When user tap on notification when app is in background but app not terminated

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onNotificationClick(json.encode(message.data), context);
    });
  }

  static Future<void> onNotificationClick(
      String? dataFromNotification, BuildContext context) async {
    if (dataFromNotification != null) {
      Map data = json.decode(dataFromNotification);
      String screen = data['screen'];
      if (screen == "order_status_screen") {
        String orderId = data['order_id'];
        Order order = await FirebaseDatabase.fetchOrder(orderId);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderDetails(order)));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TrackOrder(order)));
      } else if (screen == 'chat_screen') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      }
    }
  }
}
