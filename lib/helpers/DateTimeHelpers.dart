
import 'dart:ui';

import 'package:BibleRead/helpers/FirstLaunch.dart';
import 'package:intl/intl.dart';

class DateTimeHelpers {
  DateTimeHelpers();

String dateFormatted(String date) {
  final _formattedDate = date.split(' ')[0];
  final String day = _formattedDate.split('-')[2];
  final String month = _formattedDate.split('-')[1];
  final String year = _formattedDate.split('-')[0];
  return '$month/$day/$year';
  }


String todayWeekDay() {
final date = DateTime.now();
var weekday = DateFormat('EEEE').format(date);
return weekday;
}

Future<String> todayWeekDayFuture() async {
final date = DateTime.now();
String weekday;
String locale = await FirstLaunch().getDeviceLocale();
weekday = DateFormat('EEEE', locale).format(date);
return weekday;
}

String todayMonth() {
  final date = DateTime.now();
  final month = DateFormat('MMMM').format(date);
  return month;
}

Future<String> todayMonthFuture() async {
  final date = DateTime.now();
  String locale = await FirstLaunch().getDeviceLocale();
  final month = DateFormat('MMMM', locale).format(date);
  return month;
}

String todayDate() {
  final date = DateTime.now().day.toString();
  return date;
}
}
