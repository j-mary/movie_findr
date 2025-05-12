import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'failure.dart';

Future<T> dioInterceptor<T>(Future<T> Function() func) async {
  try {
    final result = await func();
    return result;
  } on TypeError catch (e, s) {
    _log(e, s);
    throw FormatException();
  } on DioException catch (e, s) {
    return onDioError(e, s);
  } on FormatException {
    throw FormatException();
  } catch (e, s) {
    _log(e, s);
    throw DefaultException(message: '$e');
  }
}

onDioError<T>(
  DioException e,
  StackTrace s,
) {
  log('$e');
  if (e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionTimeout) {
    throw ConnectionException(message: 'Request timed out', exception: e);
  }

  if (e.error is SocketException ||
      e.type == DioExceptionType.connectionError ||
      e.error is HandshakeException) {
    throw ConnectionException(statusCode: e.response?.statusCode, exception: e);
  }

  if (e.response == null || e.response?.data == null) {
    throw DefaultException(
        message: 'Unexpected error occurred',
        statusCode: e.response?.statusCode,
        exception: e);
  }

  final response = e.response!;
  final statusCode = response.statusCode ?? -2;
  final res = response.data;

  String? error;
  String? code;

  // possible error models that the api can return
  final errorModels = [
    'message',
    'error',
    'error.message',
    'data.message',
    'error.data.message',
    'data.error',
    'body.data',
    'body.data.message'
  ];

  // possible error code that the api can return
  final codeModels = [
    'data.code',
  ];

  if (res is Map) {
    // Try to find the first message that matches the error model
    for (int i = 0; i < errorModels.length; i++) {
      error = _extractMessage(res, errorModels[i]);

      if (error != null) break; // Found our error message: Break loop
    }
  }

  if (res is Map) {
    // Try to find the first message that matches the error model
    for (int i = 0; i < codeModels.length; i++) {
      code = _extractMessage(res, codeModels[i]);

      if (code != null) {
        // replace error message with code for the view to handle
        error = code;
        break;
      } // Found our code Break loop
    }
  }

  if (error != null) {
    throw DefaultException(message: error, statusCode: statusCode);
  }

  throw DefaultException(
      message: 'Unexpected error occurred', statusCode: statusCode);
}

String? _extractMessage(Map data, String model) {
  final models = model.split('.');

  Map? extracted = data;
  try {
    for (int i = 0; i < models.length; i++) {
      final element = models[i];
      if (extracted![element] is String) return extracted[element];

      extracted = extracted[element];
    }
  } catch (e) {
    return null;
  }

  return null;
}

_log(dynamic e, StackTrace s) {
  if (kDebugMode) {
    log(':::Failure::: $e');
    log(':::StackTrace::: $s');
  }
}
