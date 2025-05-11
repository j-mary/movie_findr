import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class MovieEntity extends Equatable {
  final String title;
  final String overview;
  final num voteAverage;
  final List<int> genreIds;
  final String releaseDate;
  final String? backdropPath;
  final String? posterPath;

  const MovieEntity({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.genreIds,
    required this.releaseDate,
    this.backdropPath,
    this.posterPath,
  });

  MovieEntity copyWith({
    String? title,
    String? overview,
    num? voteAverage,
    List<int>? genreIds,
    String? releaseDate,
    String? backdropPath,
    String? posterPath,
  }) {
    return MovieEntity(
      title: title ?? this.title,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      genreIds: genreIds ?? this.genreIds,
      releaseDate: releaseDate ?? this.releaseDate,
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
    );
  }

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      title: map['title'] ?? '',
      overview: map['overview'] ?? '',
      voteAverage: map['voteAverage']?.toDouble() ?? 0,
      genreIds: (map['genreIds'] as List<dynamic>?)?.cast<int>() ?? [],
      releaseDate: map['releaseDate'] ?? '',
      backdropPath: map['backdropPath'],
      posterPath: map['posterPath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'overview': overview,
      'voteAverage': voteAverage,
      'genreIds': genreIds,
      'releaseDate': releaseDate,
      'backdropPath': backdropPath,
      'posterPath': posterPath,
    };
  }

  @override
  String toString() => '${toMap()}';

  @override
  List<Object?> get props => [
        title,
        overview,
        voteAverage,
        genreIds,
        releaseDate,
        backdropPath,
        posterPath,
      ];
}
