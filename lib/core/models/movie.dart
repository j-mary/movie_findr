import 'package:flutter/foundation.dart';
import 'package:movie_findr/core/entities/movie_entity.dart';
import 'package:movie_findr/core/models/genre.dart';

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

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] ?? '',
      overview: map['overview'] ?? '',
      voteAverage: map['voteAverage']?.toDouble() ?? 0,
      genres: (map['genres'] as List<dynamic>?)?.cast<Genre>() ?? [],
      releaseDate: map['releaseDate'] ?? '',
      backdropPath: map['backdropPath'],
      posterPath: map['posterPath'],
    );
  }

  Movie.initial()
      : title = "The King's Man",
        overview =
            "As a collection of history's worst tyrants and criminal masterminds gather to plot a war to wipe out millions, one man must race against time to stop them.",
        voteAverage = 6.747,
        genres = List.filled(2, Genre.initial()),
        releaseDate = '2021-12-22',
        backdropPath =
            'https://image.tmdb.org/t/p/original/4OTYefcAlaShn6TGVK33UxLW9R7.jpg',
        posterPath =
            'https://image.tmdb.org/t/p/original/aq4Pwv5Xeuvj6HZKtxyd23e6bE9.jpg';

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
