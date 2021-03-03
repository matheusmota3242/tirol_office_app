import 'package:intl/intl.dart';

class DateTimeHelper {
  String formatTime(DateTime dateTime) {
    DateFormat formatter = DateFormat("Hm");
    return formatter.format(dateTime);
  }
}
