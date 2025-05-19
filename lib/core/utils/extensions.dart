import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension Data on Map<String, TextEditingController> {
  Map<String, dynamic> data() {
    final res = <String, dynamic>{};
    for (MapEntry e in entries) {
      res.putIfAbsent(e.key, () => e.value?.text);
    }
    return res;
  }
}

extension DateTimeExtension on DateTime {
  String formattedDate() {
    final formattedDate =
        '${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year';
    return formattedDate;
  }

  String timeAgoOrFormattedDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (isAfter(today)) {
      final difference = now.difference(this);
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} mins ago';
      } else {
        return '${difference.inHours} hrs ago';
      }
    } else {
      return formattedDate();
    }
  }

  String toShortDate() {
    String format =
        '${DateFormat.ABBR_MONTH} ${DateFormat.DAY}, ${DateFormat.YEAR}';
    return DateFormat(format).format(this);
  }
}

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final item in this) {
      if (test(item)) {
        return item;
      }
    }
    return null;
  }
}

extension MapIndexed<T> on Iterable<T> {
  Iterable<T> mapIndexed(T Function(T item, int index) f) {
    int index = 0;
    return map((item) => f(item, index++));
  }
}
