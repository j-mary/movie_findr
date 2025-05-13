import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_findr/core/index.dart';
import 'package:movie_findr/features/movie/movie_repository.dart';
import 'package:movie_findr/main.dart';

import 'stubs/stub_movie_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Should test basic flow and see the fake generated movie in the end',
      (tester) async {
    final testProviderScope = ProviderScope(
      overrides: [
        movieRepositoryProvider.overrideWithValue(StubMovieRepository())
      ],
      child: const MyApp(),
    );

    await tester.pumpWidget(testProviderScope);
    await tester.pumpAndSettle();

    // Verify we're on the landing page
    expect(find.byKey(ValueKey('titleText')), findsOneWidget);
    expect(find.byType(PrimaryButton), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // Verify we're on the genres page
    expect(find.text(Genre.initial().name), findsOneWidget);

    // Tap the genre name to select it
    await tester.tap(find.text(Genre.initial().name));
    await tester.pumpAndSettle();

    // Tap the "Continue" button on the genre page
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // Skip the ratings slider, use the default state value

    // Tap the "Yes please" button on the ratings page to continue
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // Skip the years back slider, use the default state value

    // Tap the "Amazing" button on the years back page to continue
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // Verify we're on the result page which displays the movie title
    expect(find.text(Movie.initial().title), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets(
      'Should test basic flow and make sure we do not pass the genre screen without selecting a genre',
      (tester) async {
    final testProviderScope = ProviderScope(
      overrides: [
        movieRepositoryProvider.overrideWithValue(StubMovieRepository())
      ],
      child: const MyApp(),
    );

    await tester.pumpWidget(testProviderScope);
    await tester.pumpAndSettle();

    // Verify we're on the landing page
    expect(find.byKey(ValueKey('titleText')), findsOneWidget);
    expect(find.byType(PrimaryButton), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // Verify we're on the genres page
    expect(find.text(Genre.initial().name), findsOneWidget);

    // Tap the "Continue" button on the genre page WITHOUT selecting a genre
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // Verify we're still on the genres page (we shouldn't advance without selecting a genre)
    expect(find.text(Genre.initial().name), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
