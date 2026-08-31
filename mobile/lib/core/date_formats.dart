import 'package:intl/intl.dart';

class AppDateFormat {
  AppDateFormat._();

  static final display = DateFormat('dd/MM/yyyy');
  static final displayWithTime = DateFormat('dd/MM/yyyy HH:mm');
  static final api = DateFormat('yyyy-MM-dd');

  static String hm(String time) =>
      time.length >= 5 ? time.substring(0, 5) : time;
}
