import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_findr/core/index.dart';

void main() {
  testWidgets('Should find a loading indicator when isLoading is true',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PrimaryButton(
        onPressed: () {},
        text: 'Submit',
        isLoading: true,
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should find the given text when isLoading is false',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PrimaryButton(
        onPressed: () {},
        text: 'Submit',
        isLoading: false,
      ),
    ));

    expect(find.text('Submit'), findsOneWidget);
  });
}
