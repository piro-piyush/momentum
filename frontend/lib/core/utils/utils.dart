import 'package:flutter/material.dart';

export "snack_bar_utils.dart";
export "validator_utils.dart";

// Color strengthenColor(Color color, double factor) {
//   final r = (color.r * 255.0 * factor).round().clamp(0, 255);
//   final g = (color.g * 255.0 * factor).round().clamp(0, 255);
//   final b = (color.b * 255.0 * factor).round().clamp(0, 255);
//
//   return Color.fromARGB(color.a.round(), r, g, b);
// }
Color strengthenColor(Color color, double factor) {
  final r = (color.r * 255.0 * factor).round().clamp(0, 255);
  final g = (color.g * 255.0 * factor).round().clamp(0, 255);
  final b = (color.b * 255.0 * factor).round().clamp(0, 255);

  return Color.fromARGB((color.a * 255.0).round(), r, g, b);
}

List<DateTime> generateWeekDates(int weekOffset) {
  final today = DateTime.now();
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  startOfWeek = startOfWeek.add(Duration(days: weekOffset * 7));

  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

List<DateTime> generateMonthDates(int monthOffset) {
  final today = DateTime.now();

  final startOfMonth = DateTime(today.year, today.month + monthOffset, 1);

  final daysInMonth = DateTime(
    startOfMonth.year,
    startOfMonth.month + 1,
    0,
  ).day;

  return List.generate(
    daysInMonth,
    (index) => DateTime(startOfMonth.year, startOfMonth.month, index + 1),
  );
}

String rgbToHex(Color color) {
  final r = (color.r * 255.0).round().clamp(0, 255);
  final g = (color.g * 255.0).round().clamp(0, 255);
  final b = (color.b * 255.0).round().clamp(0, 255);

  return [
    r.toRadixString(16).padLeft(2, '0'),
    g.toRadixString(16).padLeft(2, '0'),
    b.toRadixString(16).padLeft(2, '0'),
  ].join();
}

Color hexToRgb(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
