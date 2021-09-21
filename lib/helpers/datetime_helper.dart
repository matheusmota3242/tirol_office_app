import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatTime(DateTime dateTime) {
    DateFormat formatter = DateFormat("Hm");
    return formatter.format(dateTime);
  }

  static String generateProcessDateForId(DateTime dateTime) {
    return dateTime.day.toString() +
        dateTime.month.toString() +
        dateTime.year.toString();
  }

  static DateTime convertToInitialDate(DateTime start) {
    return DateTime(start.year, start.month, start.day, 0, 00);
  }

  static DateTime convertToEndDate(DateTime end) {
    return DateTime(end.year, end.month, end.day, 23, 59);
  }

  static String convertIntToStringWeekday(int weekday) {
    String str;
    switch (weekday) {
      case 1:
        str = 'Seg';
        break;
      case 2:
        str = 'Ter';
        break;
      case 3:
        return 'Qua';
        break;
      case 4:
        str = 'Qui';
        break;
      case 5:
        str = 'Sex';
        break;
      case 6:
        str = 'Sáb';
        break;
      case 7:
        str = 'Dom';
        break;
      default:
    }
    return str;
  }

  static String convertIntToStringMonth(int month) {
    String str;
    switch (month) {
      case 1:
        str = 'janeiro';
        break;
      case 2:
        str = 'fevereiro';
        break;
      case 3:
        str = 'março';
        break;
      case 4:
        str = 'abril';
        break;
      case 5:
        str = 'maio';
        break;
      case 6:
        str = 'junho';
        break;
      case 6:
        str = 'julho';
        break;
      case 8:
        str = 'agosto';
        break;
      case 9:
        str = 'setembro';
        break;
      case 10:
        return 'outubro';
        break;
      case 11:
        str = 'novembro';
        break;
      case 12:
        str = 'dezembro';
        break;
      default:
    }
    return str;
  }
}
