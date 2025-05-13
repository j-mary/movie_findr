import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_findr/core/index.dart';
import 'package:movie_findr/features/movie/movie_repository.dart';
import 'package:multiple_result/multiple_result.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final repository = ref.watch(movieRepositoryProvider);
  return TMDBMovieService(repository);
});

abstract class MovieService {
  Future<Result<List<Genre>, Failure>> getGenres();
  Future<Result<Movie, Failure>> getRecommendedMovies(
      int rating, int yearsBack, List<Genre> genres,
      [DateTime? yearsBackFromDate]);
}

class TMDBMovieService implements MovieService {
  TMDBMovieService(this._movieRepository);

  final MovieRepository _movieRepository;

  @override
  Future<Result<List<Genre>, Failure>> getGenres() async {
    try {
      final entities = await _movieRepository.getGenres();
      final genres = entities.map((e) => Genre.fromEntity(e)).toList();
      return Success(genres);
    } on Failure catch (e) {
      return Error(e);
    }
  }

  @override
  Future<Result<Movie, Failure>> getRecommendedMovies(
      int rating, int yearsBack, List<Genre> genres,
      [DateTime? yearsBackFromDate]) async {
    try {
      final date = yearsBackFromDate ?? DateTime.now();
      final year = date.year - yearsBack;
      final genreIds = genres.map((e) => e.id).toList().join(',');
      final entities = await _movieRepository.getRecommendedMovies(
          rating.toDouble(), '$year-01-01', genreIds);
      final movies = entities.map((e) => Movie.fromEntity(e, genres)).toList();
      final rnd = Random();
      final randomMovie = movies[rnd.nextInt(movies.length)];
      return Success(randomMovie);
    } on Failure catch (e) {
      return Error(e);
    }
  }
}
