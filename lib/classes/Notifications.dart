import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/helpers/app_localizations.dart';
import 'package:BibleRead/models/Plan.dart';
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
    await SharedPrefs().setBadgeNumber(0);
  }

    Future<void> showDailyAtTime(DateTime dateTime, BuildContext context) async {
    int badgeNumber = await SharedPrefs().getBadgeNumber();
    await SharedPrefs().setBadgeNumber(badgeNumber + 1);

    Time time = Time(dateTime.hour, dateTime.minute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(

        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description',
        importance: Importance.High,
        category: 'CATEGORY_ALARM',
        color: Theme.of(context).accentColor,
        indeterminate: true,
        enableLights: true,

        enableVibration: true,
        channelShowBadge: true,
        visibility: NotificationVisibility.Public,
        );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true,
        badgeNumber: badgeNumber + 1,
        presentSound: true,
    );


    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  List<Plan> unreadChapters = await DatabaseHelper().unReadChapters();

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        AppLocalizations.of(context).translate('read_today'),
        '${unreadChapters[0].longName} ${unreadChapters[0].chapters}',
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
