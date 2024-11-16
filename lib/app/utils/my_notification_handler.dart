import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

class MyNotificationHandler {
  Future<void> requestNotificationPermissions() async {
    if (Platform.isIOS) {
      // Request notification permissions for iOS
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission on iOS');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional permission on iOS');
      } else {
        print('User declined or has not accepted permission on iOS');
      }
      return null;

    } else if (Platform.isAndroid && Platform.version.compareTo('13') >= 0) {
      try{
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          print('User granted permission');
        } else {
          print('User declined or has not accepted permission');
        }
      }catch(err){
        print("ERROR while fetching Permissions : $err");
      }
      return null;
    }
  }



  void showNotification(RemoteMessage message) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,


    );
    // var id = Random().nextInt(1000);
    var id = 1001;
    var title = message.data["title"];
    var body = message.data["body"];

    // var title = message.notification?.title;
    // var body = message.notification?.body;
    var channelKey = message.data["channelKey"];
    print('NOTIFICATION : ${title}');
    if(title != null && title.toString().isNotEmpty){
      try {
        flutterLocalNotificationsPlugin.show(
          id,
          title,
          body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: AppColors.green,
              channelDescription: channel.description,
              icon: '@drawable/ic_notification',
            ),
          ),
        );
      } catch (e) {
        print('NOTIFICATION ERROR: $e');
      }
    }
  }
}
