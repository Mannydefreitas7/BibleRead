import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    NotificationAppLaunchDetails notificationAppLaunchDetails;

class Notifications {

    initializeNotifications() async {
        var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
          notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
          var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        // didReceiveLocalNotificationSubject.add(ReceivedNotification(
        //     id: id, title: title, body: body, payload: payload));
      });
      var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

    }

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



    Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

    Future<void> showDailyAtTime(DateTime dateTime) async {
   // String _time = await SharedPrefs().getReminderTime();
    int badgeNumber = await SharedPrefs().getBadgeNumber();
    await SharedPrefs().setBadgeNumber(badgeNumber + 1);
    // int minutes = _time.split(':')[1].startsWith('0') ? int.parse(_time.split(':')[1].split('')[1]) : int.parse(_time.split(':')[1]);
    // int hour = int.parse(_time.split(':')[0]);
    Time time = Time(dateTime.hour, dateTime.minute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        badgeNumber: badgeNumber + 1,
        presentSound: true,
    );


    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        'Daily notification shown: $time',
        time,
        platformChannelSpecifics);
  }

}



class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
