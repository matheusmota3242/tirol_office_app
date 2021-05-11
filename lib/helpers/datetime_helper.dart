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

  String convertIntToStringWeekday(int weekday) {
    print('weekday: $weekday');
    switch (weekday) {
      case 1:
        return 'Seg';
        break;
      case 2:
        return 'Ter';
        break;
      case 3:
        return 'Qua';
        break;
      case 4:
        return 'Qui';
        break;
      case 5:
        return 'Sex';
        break;
      case 6:
        return 'Sáb';
        break;
      case 7:
        return 'Dom';
        break;
      default:
    }
  }

  String convertIntToStringMonth(int month) {
    switch (month) {
      case 0:
        return 'janeiro';
        break;
      case 1:
        return 'fevereiro';
        break;
      case 2:
        return 'março';
        break;
      case 3:
        return 'abril';
        break;
      case 4:
        return 'maio';
        break;
      case 5:
        return 'junho';
        break;
      case 6:
        return 'julho';
        break;
      case 7:
        return 'agosto';
        break;
      case 8:
        return 'setembro';
        break;
      case 9:
        return 'outubro';
        break;
      case 10:
        return 'novembro';
        break;
      case 11:
        return 'dezembro';
        break;

      default:
    }
  }
}
