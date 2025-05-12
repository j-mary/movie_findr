import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flow/core/index.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TMDBMovieRepository(dio);
});

abstract class MovieRepository {
  Future<List<GenreEntity>> getGenres();
  Future<List<MovieEntity>> getRecommendedMovies(
      double rating, String date, String genreIds);
}

class TMDBMovieRepository implements MovieRepository {
  TMDBMovieRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<GenreEntity>> getGenres() async {
    return dioInterceptor(() async {
      final res = await _dio.get('genre/movie/list',
          queryParameters: {'api_key': config.tmdbApiKey, 'language': 'en-US'});
      final List<dynamic> genres = res.data['genres'];
      return genres.map((e) => GenreEntity.fromMap(e)).toList();
    });
  }

  @override
  Future<List<MovieEntity>> getRecommendedMovies(
      double rating, String date, String genreIds) async {
    return dioInterceptor(() async {
      final res = await _dio.get(
        'discover/movie',
        queryParameters: {
          'api_key': config.tmdbApiKey,
          'language': 'en-US',
          'sort_by': 'popularity.desc',
          'include_adult': false,
          'vote_average.gte': rating,
          'release_date.gte': date,
          'with_genres': genreIds,
          'page': 1,
        },
      );
      final List<dynamic> movies = res.data['results'];
      return movies.map((e) => MovieEntity.fromMap(e)).toList();
    });
  }
}
