
import 'package:BibleRead/classes/database/LocalDataBase.dart';
import 'package:BibleRead/classes/date/DateTimeHelpers.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_device_locale/flutter_device_locale.dart';

import 'package:better_uuid/uuid.dart';


class FirstLaunch {
  FirstLaunch();

  final date = DateTimeHelpers();
  

  Future<String> getDeviceLocale() async {
    Locale locale = await DeviceLocale.getCurrentLocale();
    return locale.languageCode;
  }

 Future<bool> isNotFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final bool _isFirstUse = prefs.getBool('firstUse');
  return _isFirstUse;
  }

  Future<bool> isVersion520() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('520');
  }

  void setVersion520() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('520', true);
  }

  Future<bool> hasRated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasRated');
      }

    void setRated() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasRated', true);
    }  

    Future<int> launches() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('launches');
    }

    void addLaunch(int number) async {
      final prefs = await SharedPreferences.getInstance();
      int current = await launches();
      if (current != null) {
        prefs.setInt('launches', current + number);
      } else {
         prefs.setInt('launches', 0 + number);
      }
    }

  Future<String> userCurrentID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('UUID');
  }

 Future<String> getBibleLocale() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   String bibleLocale = prefs.getString('bibleLocale');
   return bibleLocale;
 }

 Future<void> setBibleLocale(String locale) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('bibleLocale', locale);
 }

  Future<void> setDefaults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceLocale = await getDeviceLocale();
    final Uuid id = Uuid.v4();

    prefs.setBool('firstUse', true);

    prefs.setString('bibleLocale', deviceLocale);

    prefs.setInt('selectedPlan', 0);

    prefs.setString('bibleTranslation', 'nwt');

    prefs.setBool('showExpectedProgress', false);

    prefs.setString('readingStartDate', DateTime.now().toString());

    prefs.setBool('hasBookmark', false);

    prefs.setString('bookmark', '');

     prefs.setInt('badgeNnumber', 0);

    prefs.setBool('isReminderOn', false);

    prefs.setString('reminderTime', '${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}');

    prefs.setBool('isAuthenticated', false);

    prefs.setString('UUID', id.toString());

  }

  Future<void> firstUse() async {
      print('first use, setting default prefs');
       await DatabaseHelper().setupDatabase();
      await setDefaults();
      await DatabaseHelper().setLanguagesName();
  }
}
