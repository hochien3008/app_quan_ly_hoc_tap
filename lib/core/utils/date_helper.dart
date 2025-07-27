import 'package:intl/intl.dart';

class DateHelper {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE', 'vi_VN').format(date);
  }

  static String getShortDayOfWeek(DateTime date) {
    return DateFormat('E', 'vi_VN').format(date);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static DateTime endOfWeek(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

  static List<DateTime> getWeekDays(DateTime date) {
    final start = startOfWeek(date);
    final days = <DateTime>[];
    for (int i = 0; i < 7; i++) {
      days.add(start.add(Duration(days: i)));
    }
    return days;
  }
}
