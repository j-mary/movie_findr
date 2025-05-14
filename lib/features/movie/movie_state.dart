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
  final AsyncValue<Movie> movie;

  const MovieState({
    this.rating = 5,
    this.yearsBack = 10,
    required this.genres,
    required this.movie,
  });

  factory MovieState.initial() {
    return MovieState(
      genres: AsyncData([]),
      movie: AsyncData(Movie.initial()),
    );
  }

  MovieState copyWith({
    int? rating,
    int? yearsBack,
    AsyncValue<List<Genre>>? genres,
    AsyncValue<Movie>? movie,
  }) {
    return MovieState(
      rating: rating ?? this.rating,
      yearsBack: yearsBack ?? this.yearsBack,
      genres: genres ?? this.genres,
      movie: movie ?? this.movie,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'yearsBack': yearsBack,
      'genres': genres.value?.map((e) => e.toMap()).toList(),
      'movie': movie.value?.toMap(),
    };
  }

  @override
  String toString() => '${toMap()}';

  @override
  List<Object?> get props => [
        rating,
        yearsBack,
        genres,
        movie,
      ];
}

/// Provider to track if the landing_screen animation has played.
///
/// Using a regular StateProvider (not autoDispose) to persist the state.
final landingScreenAnimationPlayedProvider =
    StateProvider<bool>((ref) => false);
