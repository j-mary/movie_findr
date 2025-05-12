import 'package:flutter/material.dart';
import 'package:movie_flow/core/index.dart';

class FailureScreen extends StatelessWidget {
  const FailureScreen({
    super.key,
    required this.error,
    required this.retry,
    this.fullScreen = true,
    this.heightFactor = 0.77,
  });

  final dynamic error;
  final VoidCallback retry;
  final bool? fullScreen;
  final double? heightFactor;

  Widget child() {
    if (error is Failure) {
      return _FailureBody(
        message: (error as Failure).message,
        retry: retry,
      );
    }

    if (error is DefaultException) {
      return _FailureBody(
        message: (error as DefaultException).message,
        retry: retry,
      );
    }

    return _FailureBody(
      message: 'Something went wrong',
      retry: retry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return fullScreen!
        ? SizedBox(
            height: MediaQuery.sizeOf(context).height * heightFactor!,
            child: child(),
          )
        : child();
  }
}

class _FailureBody extends StatelessWidget {
  const _FailureBody({required this.message, required this.retry});

  final String message;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            OutlinedButton(
              onPressed: retry,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'retry',
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
