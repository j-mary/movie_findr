import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_flow/core/index.dart';
import 'package:movie_flow/features/movie/movie_controller.dart';
import 'package:movie_flow/features/movie/movie_service.dart';
import 'package:movie_flow/features/movie/movie_state.dart';
import 'package:multiple_result/multiple_result.dart';

class MockMovieService extends Mock implements MovieService {}

// Create a provider override for the movieServiceProvider
final mockMovieServiceProvider =
    Provider<MovieService>((ref) => MockMovieService());

// Create a test-specific controller provider that doesn't auto-load genres
final genreTestMovieFlowControllerProvider =
    NotifierProvider.autoDispose<GenreTestMovieFlowController, MovieState>(() {
  return GenreTestMovieFlowController();
});

// Test version of the controller that doesn't auto-load genres
class GenreTestMovieFlowController extends MovieFlowController {
  @override
  MovieState build() {
    ref.onDispose(() {
      state.pageController.dispose();
    });

    movieService = ref.read(movieServiceProvider);

    // Don't auto-load genres in tests
    // Future(() async {
    //   await loadGenres();
    // });

    return MovieState.initial();
  }
}

void main() {
  late ProviderContainer container;
  late MovieService mockedMovieService;
  late Genre genre;

  setUp(() {
    mockedMovieService = MockMovieService();

    // Create a container with overrides
    container = ProviderContainer(
      overrides: [
        movieServiceProvider.overrideWithValue(mockedMovieService),
      ],
    );

    genre = Genre.initial();

    // Add a listener to the provider to initialize it
    // or mock the getGenres method from the controller

    // The Listener
    // container.listen(
    //   movieFlowControllerProvider,
    //   (previous, next) {},
    //   fireImmediately: true,
    // );

    // The mock of the auto loaded getGenres method
    when(() => mockedMovieService.getGenres())
        .thenAnswer((_) async => Success([genre]));

    addTearDown(() => container.dispose());
  });

  group('MovieControllerTests', () {
    test('Should load genres on init', () async {
      // Arrange
      when(() => mockedMovieService.getGenres())
          .thenAnswer((_) async => Success([
                const Genre.initial(),
              ]));

      // Act
      final controller = container.read(movieFlowControllerProvider.notifier);
      await controller.loadGenres();

      // Assert
      verify(() => mockedMovieService.getGenres()).called(1);

      final state = container.read(movieFlowControllerProvider);
      expect(state.genres, isA<AsyncData<List<Genre>>>());
      expect(state.genres.value, isNotEmpty);
      expect(state.genres.value!.length, 1);
      expect(state.genres.value!.first.name, Genre.initial().name);
    });

    test('Should toggle is selected on a genre when toggled', () async {
      // Arrange
      // First, ensure genres are loaded
      final controller = container.read(movieFlowControllerProvider.notifier);
      await controller.loadGenres();

      // Get the initial state to find the genre
      final initialState = container.read(movieFlowControllerProvider);
      final genreToToggle = initialState.genres.value!.first;

      // Act
      controller.toggleSelected(genreToToggle);

      // Assert
      final updatedState = container.read(movieFlowControllerProvider);
      final updatedGenre = updatedState.genres.value!.first;

      expect(updatedGenre.isSelected, true);
    });

    test('Should return a Failure when getting genres fails', () async {
      //Arrange
      // Create a test-specific MovieService mock
      final genreTestMovieService = MockMovieService();
      // Setup the mock to return an error
      when(() => genreTestMovieService.getGenres()).thenAnswer((_) async =>
          Error(ConnectionException(message: 'No internet connection')));

      // Create a test container with our custom provider that doesn't auto-load genres
      final genreTestContainer = ProviderContainer(
        overrides: [
          movieServiceProvider.overrideWithValue(genreTestMovieService),
          // Use our test-specific provider that doesn't auto-load genres
          movieFlowControllerProvider
              .overrideWith(() => GenreTestMovieFlowController()),
        ],
      );

      // Get the controller
      final controller =
          genreTestContainer.read(movieFlowControllerProvider.notifier);

      // Act
      await controller.loadGenres();

      // Assert
      verify(() => genreTestMovieService.getGenres()).called(1);

      final state = genreTestContainer.read(movieFlowControllerProvider);
      expect(state.genres, isA<AsyncError<List<Genre>>>());
      expect(state.genres.error, isA<Failure>());
      expect((state.genres.error as Failure).message, 'No internet connection');

      // Clean up
      genreTestContainer.dispose();
    });

    test('Should get recommended movie', () async {
      // Arrange
      when(() => mockedMovieService.getRecommendedMovies(any(), any(), any()))
          .thenAnswer((_) async => Success(Movie.initial()));

      // Act
      final controller = container.read(movieFlowControllerProvider.notifier);
      await controller.getRecommendedMovie();

      // Assert
      verify(() => mockedMovieService.getRecommendedMovies(any(), any(), any()))
          .called(1);

      final state = container.read(movieFlowControllerProvider);
      expect(state.movie, isA<AsyncData<Movie>>());
      expect(state.movie.value, isA<Movie>());
      expect(state.movie.value!.title, Movie.initial().title);
    });

    test('Should return a Failure when getting recommended movie fails',
        () async {
      // Arrange
      when(() => mockedMovieService.getRecommendedMovies(any(), any(), any()))
          .thenAnswer((_) async => Error(FormatException(message: 'Bad data')));

      // Act
      final controller = container.read(movieFlowControllerProvider.notifier);
      await controller.getRecommendedMovie();

      // Assert
      verify(() => mockedMovieService.getRecommendedMovies(any(), any(), any()))
          .called(1);

      final state = container.read(movieFlowControllerProvider);
      expect(state.movie, isA<AsyncError<Movie>>());
      expect(state.movie.error, isA<Failure>());
      expect((state.movie.error as Failure).message, 'Bad data');
    });

    for (final rating in [2, 5, -2]) {
      test('Should update rating to ${rating < 0 ? 0 : rating} when updated',
          () async {
        // Arrange
        final controller = container.read(movieFlowControllerProvider.notifier);

        // Act
        controller.updateRating(rating);

        // Assert
        final state = container.read(movieFlowControllerProvider);
        expect(state.rating, rating < 0 ? 0 : rating);
      });
    }

    for (final yearsBack in [2, 5, -2]) {
      test(
          'Should update yearsBack to ${yearsBack < 0 ? 0 : yearsBack} when updated',
          () async {
        // Arrange
        final controller = container.read(movieFlowControllerProvider.notifier);

        // Act
        controller.updateYearsBack(yearsBack);

        // Assert
        final state = container.read(movieFlowControllerProvider);
        expect(state.yearsBack, yearsBack < 0 ? 0 : yearsBack);
      });
    }
  });
}
