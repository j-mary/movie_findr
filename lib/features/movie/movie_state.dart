import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flow/core/models/genre.dart';
import 'package:movie_flow/core/models/movie.dart';

@immutable
class MovieState extends Equatable {
  final PageController pageController;
  final int rating;
  final int yearsBack;
  final AsyncValue<List<Genre>> genres;
  final AsyncValue<Movie> movie;

  const MovieState({
    required this.pageController,
    this.rating = 5,
    this.yearsBack = 10,
    required this.genres,
    required this.movie,
  });

  factory MovieState.initial() {
    return MovieState(
      pageController: PageController(),
      genres: AsyncData([]),
      movie: AsyncData(Movie.initial()),
    );
  }

  MovieState copyWith({
    PageController? pageController,
    int? rating,
    int? yearsBack,
    AsyncValue<List<Genre>>? genres,
    AsyncValue<Movie>? movie,
  }) {
    return MovieState(
      pageController: pageController ?? this.pageController,
      rating: rating ?? this.rating,
      yearsBack: yearsBack ?? this.yearsBack,
      genres: genres ?? this.genres,
      movie: movie ?? this.movie,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pageController': pageController,
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
        pageController,
        rating,
        yearsBack,
        genres,
        movie,
      ];
}

const movieMock = Movie(
  title: 'Pulp Fiction',
  overview:
      "Pulp Fiction is a nonlinear narrative that intertwines several interconnected stories involving mobsters, a pair of hitmen, a boxer, a gangster's wife, and a mysterious briefcase. This Quentin Tarantino-directed film is known for its dark humor, pop culture references, and iconic dialogues",
  voteAverage: 4.8,
  genres: [
    Genre(name: 'Crime'),
    Genre(name: 'Neo-Noir'),
    Genre(name: 'Black Comedy'),
    Genre(name: 'Drama'),
    Genre(name: 'Thriller'),
    Genre(name: 'Independent Cinema')
  ],
  releaseDate: 'October 14, 1994',
  backdropPath: '',
  posterPath: '',
);

const List<Genre> genresMock = [
  Genre(name: 'Action'),
  Genre(name: 'Comedy'),
  Genre(name: 'Horror'),
  Genre(name: 'Anime'),
  Genre(name: 'Drama'),
  Genre(name: 'Family'),
  Genre(name: 'Romance'),
];
