import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/database/LocalDataBase.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    NotificationAppLaunchDetails notificationAppLaunchDetails;

class Notifications extends ChangeNotifier {

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
    await SharedPrefs().setReminderTime(dateTime);
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

   Future<void> setDailyAtTime(BuildContext context) async {
     initializeNotifications();
    final String reminderTime = await SharedPrefs().getReminderTime();
    final int hour = int.parse(reminderTime.split(":")[0]);
    final int minute = int.parse(reminderTime.split(":")[1]);
    final bool hasReminder = await SharedPrefs().getReminder();
    List<Plan> unreadChapters = [];
    Time time = Time(hour, minute, 0);
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
        presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

 // List<Plan> unreadChapters = await DatabaseHelper().unReadChapters();
  if (hasReminder) {
      print(hasReminder);
      print('has reminder');
      cancelAllNotifications();
      DatabaseHelper().unReadChapters().then((value) {
        unreadChapters = value;
        print(unreadChapters[1].chapters);
         flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        AppLocalizations.of(context).translate('read_today'),
        '${unreadChapters[1].longName} ${unreadChapters[1].chapters}',
        time,
        platformChannelSpecifics);
      });
    }
      notifyListeners();
  }

}

