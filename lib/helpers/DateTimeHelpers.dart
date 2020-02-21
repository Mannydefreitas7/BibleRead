import 'package:BibleRead/classes/datepicker/date_time_formatter.dart';
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
  final weekday = DateFormat('EEEE').format(date);
  print(weekday);
  return weekday;
}

String todayMonth() {
  final date = DateTime.now();
  final month = DateFormat('MMMM').format(date);
  return month;
}

String todayDate() {
  final date = DateTime.now().day.toString();
  return date;
}
}
