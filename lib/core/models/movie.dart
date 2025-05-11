import 'package:flutter/foundation.dart';
import 'package:movie_flow/core/entities/movie_entity.dart';
import 'package:movie_flow/core/models/genre.dart';

@immutable
class Movie {
  final String title;
  final String overview;
  final num voteAverage;
  final List<Genre> genres;
  final String releaseDate;
  final String? backdropPath;
  final String? posterPath;

  const Movie({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.genres,
    required this.releaseDate,
    this.backdropPath,
    this.posterPath,
  });

  factory Movie.fromEntity(MovieEntity entity, List<Genre> genres) {
    return Movie(
      title: entity.title,
      overview: entity.overview,
      voteAverage: entity.voteAverage,
      genres: genres
          .where((genre) => entity.genreIds.contains(genre.id))
          .toList(growable: false),
      releaseDate: entity.releaseDate,
      backdropPath:
          'https://image.tmdb.org/t/p/original/${entity.backdropPath}',
      posterPath: 'https://image.tmdb.org/t/p/original/${entity.posterPath}',
    );
  }

  Movie.initial()
      : title = '',
        overview = '',
        voteAverage = 0,
        genres = [],
        releaseDate = '',
        backdropPath = '',
        posterPath = '';

  String get genresCommaSeparated =>
      genres.map((e) => e.name).toList().join(', ');

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'overview': overview,
      'voteAverage': voteAverage,
      'genres': genres.map((e) => e.toMap()).toList(),
      'releaseDate': releaseDate,
      'backdropPath': backdropPath,
      'posterPath': posterPath,
    };
  }

  @override
  String toString() => '${toMap()}';
}
