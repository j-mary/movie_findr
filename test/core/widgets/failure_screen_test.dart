import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_flow/core/utils/index.dart';
import 'package:movie_flow/core/widgets/failure_screen.dart';

void main() {
  testWidgets('Should display the given message on the failure screen',
      (tester) async {
    final message = 'Failure Message';

    await tester.pumpWidget(
      MaterialApp(
          home: FailureScreen(
        error: DefaultException(message: message),
        retry: () {},
      )),
    );

    expect(find.text(message), findsOneWidget);
  });
}
