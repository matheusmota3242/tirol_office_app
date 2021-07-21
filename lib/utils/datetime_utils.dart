import 'package:intl/intl.dart';

class DateTimeUtils {
  static String toBRFormat(DateTime dateTime) {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }
}
