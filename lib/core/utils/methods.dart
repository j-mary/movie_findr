import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'timestamp.dart';

DateTime? parseDate(date) {
  if (date is DateTime) {
    return date;
  } else if (date is num) {
    try {
      return DateTime.fromMillisecondsSinceEpoch(date.toInt());
    } catch (_) {
      return DateTime.fromMicrosecondsSinceEpoch(date.toInt());
    }
  } else if (date is String) {
    try {
      return DateTime.parse(date);
    } catch (error) {
      return null;
    }
  } else if (date is Timestamp) {
    return date.toDate();
  }

  try {
    return date.toDate();
  } catch (_) {
    return null;
  }
}

String toTitleCase(String? s) {
  if (s == null || s.isEmpty) return "";

  var result = s[0].toUpperCase();
  for (int i = 1; i < s.length; i++) {
    if (s[i - 1] == " ") {
      result = result + s[i].toUpperCase();
    } else {
      result = result + s[i];
    }
  }
  return result;
}

String capitalize(String? s) {
  if (s == null || s.isEmpty) return "";
  String lowercase = s.toLowerCase();
  if (lowercase.length == 1) lowercase.toUpperCase();
  return lowercase[0].toUpperCase() + lowercase.substring(1);
}

Map<String, dynamic>? asStringKeyedMap(Map<dynamic, dynamic>? map) {
  if (map == null) return null;
  if (map is Map<String, dynamic>) {
    return map;
  } else {
    return Map<String, dynamic>.from(map);
  }
}

String encodeMap(Map data) {
  return data.keys
      .map((key) =>
          "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key]?.toString() ?? '')}")
      .join("&");
}

Iterable<E> mapIndexed<E, T>(
    Iterable<T> items, E Function(int index, T item) f) sync* {
  var index = 0;

  for (final item in items) {
    yield f(index, item);
    index = index + 1;
  }
}

Dio createDioInstance({
  String? baseUrl,
  String? authToken,
  int? connectTimeout,
  int? sendTimeout,
  int? receiveTimeout,
}) {
  final options = BaseOptions();

  if (baseUrl != null) {
    options.baseUrl = baseUrl;
  }

  if (authToken != null) {
    options.headers['Authorization'] = 'Bearer $authToken';
  }

  final dio = Dio(options);

  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));
  }

  return dio;
}
