import 'package:BibleRead/helpers/DateTimeHelpers.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_device_locale/flutter_device_locale.dart';

import 'package:better_uuid/uuid.dart';

import 'LocalDataBase.dart';


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

    prefs.setBool('isReminderOn', false);

    prefs.setBool('isAuthenticated', false);

    prefs.setString('UUID', id.toString());

  }

  Future<void> firstUse() async {
      print('first use, setting default prefs');
       await DatabaseHelper().setupDatabase();
      await setDefaults();
  }
}
