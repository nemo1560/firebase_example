import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_example/core/route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';


class NotificationService{
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  static NotificationAppLaunchDetails? launchDetail;
  static String channelIdFCM = 'high_importance_channel';
  static String channelNameFCM = "fcm_notification";
  static late AndroidNotificationChannel channel;

  NotificationService();

  static Future<void> registerFCM() async {
    await Firebase.initializeApp();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    launchDetail = await flutterLocalNotificationsPlugin!.getNotificationAppLaunchDetails(); // get to screen from fcm payload
    channel = AndroidNotificationChannel(channelIdFCM, channelNameFCM,
        description: 'This channel is used for important notifications.',
        importance: Importance.high);
    backgroundFCM();
    getFCMToken();
    receiverFCM();
    await initNotification();
  }

  static void backgroundFCM(){
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    displayNotification(message.notification, message.data);
  }

  static Future<void> getFCMToken() async {
    FirebaseMessaging.instance.getToken().then((token){
      if (kDebugMode) {
        print("token is $token");
        var store = GetStorage();
        store.write('FCM Token', token);
        //Reference.setString("FCMToken", token);
      }
    });
  }

  static String? getInitRoute() {
    return launchDetail?.didNotificationLaunchApp == false ? RouteName.root : launchDetail?.notificationResponse!.payload;
  }

  static void receiverFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      displayNotification(message.notification, message.data);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onSelectNotification(message.data['screen']);
      return;
    });
  }

  static initNotification() async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('ic_download');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isAndroid){
      flutterLocalNotificationsPlugin!.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    }
    if(Platform.isIOS){
      if (Platform.isIOS) {
        await flutterLocalNotificationsPlugin!
            .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }
    flutterLocalNotificationsPlugin!.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse){
          onSelectNotification(notificationResponse.payload);
        });
  }

  Future showNotificationWithDefaultSound({required String content,required String payload}) async {
    cancelAllNotifications();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channel.id,channel.name,icon: 'ic_download',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android:
    androidPlatformChannelSpecifics,iOS:  iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin!.show(
      0,
      'FCM Example',
      content,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  //foreground notifi
  static Future displayNotification(
      RemoteNotification? message, Map<String, dynamic> data) async {
    String screen = data['screen'].toString();
    String body = jsonDecode(data['body'])['en'];
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    channel = AndroidNotificationChannel(channelIdFCM, channelNameFCM,
        description: 'This channel is used for important notifications.',
        importance: Importance.high);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channel.id, channel.name, channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    try {
      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin!.show(
            0, 'FCM Example', body, platformChannelSpecifics,
            payload: screen);
      } else {
        await flutterLocalNotificationsPlugin!.show(
            0, 'FCM Example', body, platformChannelSpecifics,
            payload: screen);
      }
    } catch (e) {
      await flutterLocalNotificationsPlugin!.show(
          0, "FCM Example", e.toString(), platformChannelSpecifics);
    }
  }

  static Future<void> onSelectNotification(String? payload) async {
    if (payload!.isNotEmpty) {
      MotionToast.success(
        title: const Text(
          'FCM Example',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        description: Text(
          payload,
          style: const TextStyle(fontSize: 12),
        ),
        layoutOrientation: ToastOrientation.rtl,
        animationType: AnimationType.fromRight,
        dismissable: true,
      ).show(Get.context!);
      // HomeController controller = Get.find();
      // await controller.getMasterData().then((value) {
      //   if (value != null && value.length != 0) {
      //     for (MasterInfo work in controller.lstWork) {
      //       if (work.code == payload) {
      //         controller.toScreen(work);
      //         break;
      //       }
      //     }
      //   }
      // });
    } else {
      cancelAllNotifications();
    }
  }

  static void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin!.cancelAll();
  }
}