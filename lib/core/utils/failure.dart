import 'dart:io';

abstract class Failure implements Exception {
  final String message;
  final int? statusCode;
  final Exception? exception;
  const Failure({
    required this.message,
    this.statusCode,
    this.exception,
  });

  @override
  String toString() =>
      'Failure(message: $message, statusCode: $statusCode, exception: $exception)';
}

class DefaultException extends Failure {
  const DefaultException({
    required super.message,
    super.statusCode,
    super.exception,
  });
}

class ConnectionException extends Failure {
  ConnectionException({
    String? message = 'No internet connection',
    super.statusCode,
    super.exception = const SocketException('No internet connection'),
  }) : super(
          message: message!,
        );
}

class FormatException extends Failure {
  FormatException({
    String? message = 'Unable to process the data',
    super.statusCode,
    super.exception,
  }) : super(
          message: message!,
        );
}
