import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_findr/core/models/genre.dart';
import 'package:movie_findr/core/models/movie.dart';

@immutable
class MovieState extends Equatable {
  final int rating;
  final int yearsBack;
  final AsyncValue<List<Genre>> genres;
  final AsyncValue<Movie> recommendedMovie;
  final AsyncValue<List<Movie>> relatedMovies;

  const MovieState({
    this.rating = 5,
    this.yearsBack = 3,
    required this.genres,
    required this.recommendedMovie,
    required this.relatedMovies,
  });

  factory MovieState.initial() {
    return MovieState(
      genres: AsyncData([]),
      recommendedMovie: AsyncData(Movie.initial()),
      relatedMovies: AsyncData([]),
    );
  }

  MovieState copyWith({
    int? rating,
    int? yearsBack,
    AsyncValue<List<Genre>>? genres,
    AsyncValue<Movie>? recommendedMovie,
    AsyncValue<List<Movie>>? relatedMovies,
  }) {
    return MovieState(
      rating: rating ?? this.rating,
      yearsBack: yearsBack ?? this.yearsBack,
      genres: genres ?? this.genres,
      recommendedMovie: recommendedMovie ?? this.recommendedMovie,
      relatedMovies: relatedMovies ?? this.relatedMovies,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'yearsBack': yearsBack,
      'genres': genres.value?.map((e) => e.toMap()).toList(),
      'recommendedMovie': recommendedMovie.value?.toMap(),
      'relatedMovies': relatedMovies.value?.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() => '${toMap()}';

  @override
  List<Object?> get props => [
        rating,
        yearsBack,
        genres,
        recommendedMovie,
        relatedMovies,
      ];
}

/// Provider to track if the landing_screen animation has played.
///
/// Using a regular StateProvider (not autoDispose) to persist the state.
final landingScreenAnimationPlayedProvider =
    StateProvider<bool>((ref) => false);
