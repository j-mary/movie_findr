import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_flow/core/index.dart';
import 'package:movie_flow/features/movie/movie_repository.dart';
import 'package:movie_flow/features/movie/movie_service.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MovieRepository mockedMovieRepository;

  setUp(() {
    mockedMovieRepository = MockMovieRepository();
  });

  group('MovieServiceTests', () {
    test('Should map to a list of correct genres when getting GenreEntities',
        () async {
      // Arrange
      final genreEntity = GenreEntity.fromGenre(Genre.initial());

      when(() => mockedMovieRepository.getGenres())
          .thenAnswer((_) async => [genreEntity]);

      // Act
      final movieService = TMDBMovieService(mockedMovieRepository);
      final result = await movieService.getGenres();

      // Assert
      verify(() => mockedMovieRepository.getGenres()).called(1);

      result.when(
        (genres) {
          expect(genres, isA<List<Genre>>());
          expect(genres, isNotEmpty);
          expect(genres.first, isA<Genre>());
          expect(genres.first.name, genreEntity.name);
        },
        (failure) {
          fail('Should not reach here');
        },
      );
    });

    test('Should return a Failure when getting GenreEntities fails', () async {
      // Arrange
      when(() => mockedMovieRepository.getGenres())
          .thenThrow(ConnectionException(message: 'No internet connection'));

      // Act
      final movieService = TMDBMovieService(mockedMovieRepository);
      final result = await movieService.getGenres();

      // Assert
      verify(() => mockedMovieRepository.getGenres()).called(1);

      result.when(
        (genres) {
          fail('Should not reach here');
        },
        (failure) {
          expect(failure, isA<Failure>());
          expect(failure.message, 'No internet connection');
        },
      );
    });

    test('Should map to a correct movie when getting MovieEntity', () async {
      // Arrange
      final movieEntity = MovieEntity.fromMovie(Movie.initial());
      final genreList = [Genre.initial()];

      when(() =>
              mockedMovieRepository.getRecommendedMovies(any(), any(), any()))
          .thenAnswer((_) async => [movieEntity]);

      // Act
      final movieService = TMDBMovieService(mockedMovieRepository);
      final result = await movieService.getRecommendedMovies(
          5, 10, genreList, DateTime(2025));

      // Assert
      verify(() =>
              mockedMovieRepository.getRecommendedMovies(any(), any(), any()))
          .called(1);

      result.when(
        (movie) {
          expect(movie, isA<Movie>());
          expect(movie.title, movieEntity.title);
          expect(movie.voteAverage, movieEntity.voteAverage);
          expect(movie.genres, isNotEmpty);
          expect(movie.releaseDate, movieEntity.releaseDate);
        },
        (failure) {
          fail('Should not reach here');
        },
      );
    });

    test('Should return a Failure when getting MovieEntity fails', () async {
      // Arrange
      when(() =>
              mockedMovieRepository.getRecommendedMovies(any(), any(), any()))
          .thenThrow(FormatException(message: 'Unable to process the data'));

      // Act
      final movieService = TMDBMovieService(mockedMovieRepository);
      final result =
          await movieService.getRecommendedMovies(5, 10, [Genre.initial()]);

      // Assert
      verify(() =>
              mockedMovieRepository.getRecommendedMovies(any(), any(), any()))
          .called(1);

      result.when(
        (movie) {
          fail('Should not reach here');
        },
        (failure) {
          expect(failure, isA<Failure>());
          expect(failure.message, 'Unable to process the data');
        },
      );
    });
  });
}
