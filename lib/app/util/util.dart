import 'dart:math';

class Util {
  static double roundToPrecision({required num value, int precision = 2}) {
    final multiplier = pow(10, precision);
    return (value * multiplier).round() / multiplier;
  }

  static String getFormattedDate(DateTime date) {
    return "${date.toLocal()}".split(' ')[0];
  }
}
