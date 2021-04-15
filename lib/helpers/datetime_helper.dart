import 'package:intl/intl.dart';

class DateTimeHelper {
  String formatTime(DateTime dateTime) {
    DateFormat formatter = DateFormat("Hm");
    return formatter.format(dateTime);
  }

  String generateProcessDateForId(DateTime dateTime) {
    return dateTime.day.toString() +
        dateTime.month.toString() +
        dateTime.year.toString();
  }

  DateTime convertToInitialDate(DateTime start) {
    return DateTime(start.year, start.month, start.day, 0, 00);
  }

  DateTime convertToEndDate(DateTime end) {
    return DateTime(end.year, end.month, end.day, 23, 59);
  }
}
