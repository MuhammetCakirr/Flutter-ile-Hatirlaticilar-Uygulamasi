/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotifyHelper{
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    final DarwinInitializationSettings  initializationSettingsIOS =
    DarwinInitializationSettings (
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings(
     "appicon"
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid
    );

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,

        );
  }
  //onSelectNotification: selectNotification

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  

 displayNotification({required String title, required String body}) async {
    print("doing test");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 
        importance: Importance.max, priority: Priority.high);
       /*var iOSPlatformChannelSpecifics =  IOSNotificationDetails(
        "DEfault"
       );*/
        var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'You change your theme',
      'You changed your theme back !',
      platformChannelSpecifics,
      payload: 'It could be anything you pass',
    );
  }
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
   /* showDialog(
      //context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ), context: null,
    );*/
    Get.dialog(Text("Hoşgeldin"));
  }
}*/

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:reminderapp/models/gorev.dart';
import 'package:reminderapp/ui/notified_page.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationHelper {
  

  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      
    );
    _configureLocalTimeZone();
  }

  static Future<void> sendNotification(int taskId, String taskName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      taskId,
      'Task Reminder',
      'Task: $taskName is now due!',
      platformChannelSpecifics,
    );
  }

  static Future<void> scheduleNotification(int hour, int minutes, Task task) async {
    
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,  
      task.title,
      task.note,
      _convertTime(hour,minutes),
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: "${task.title}|"+"${task.note}|"
    );
    
    
  }
  Future<void> selectNotification(String? payload) async {
  if (payload != null) {
    print('notification payload: $payload');
    List<String> parts = payload.split('|'); // Verileri ayrıştırın
    String title = parts[0];
    String note = parts[1];
    int taskId = int.parse(parts[2]);

    // İşlem yapmak için payload içindeki verileri kullanabilirsiniz
    // Örneğin, özel bir sayfaya gitmek için:
    Get.to(() => NotifiedPage(label: payload,));
  } else {
    print("Notification Done");
  }
}

 static Future<void> _configureLocalTimeZone()
  async {
    tzdata.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
  }

  static tz.TZDateTime _convertTime(int hour,int minutes)
  {
    final tz.TZDateTime now=tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate=
                tz.TZDateTime(tz.local,now.year,now.month,now.day,hour,minutes);

      if(scheduledDate.isBefore(now)){
        scheduledDate=scheduledDate.add(const Duration(days: 1));
      }
    return scheduledDate;            
  }
}

