import 'package:intl/intl.dart';

class DateTimeUtils {
  static String toBRFormat(DateTime dateTime) {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  static DateTime skipTime(DateTime dateTime) {
    return new DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static DateTime firstHour(DateTime dateTime) {
    return new DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
  }

  static DateTime lastHour(DateTime dateTime) {
    return new DateTime(
        dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  }

  static String compressDate(DateTime dateTime) {
    return dateTime.day.toString() +
        dateTime.month.toString() +
        dateTime.year.toString();
  }
}
