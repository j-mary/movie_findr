import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_findr/core/index.dart';
import 'package:movie_findr/features/movie/movie_service.dart';
import 'package:movie_findr/features/movie/movie_state.dart';

final movieFlowControllerProvider =
    NotifierProvider.autoDispose<MovieFlowController, MovieState>(() {
  return MovieFlowController();
});

class MovieFlowController extends AutoDisposeNotifier<MovieState> {
  late MovieService movieService;

  @override
  MovieState build() {
    movieService = ref.read(movieServiceProvider);

    Future(() async {
      await loadGenres();
    });

    return MovieState.initial();
  }

  Future<void> loadGenres() async {
    if (state.genres.value != null && state.genres.value!.isNotEmpty) {
      return;
    }

    state = state.copyWith(
      genres: const AsyncLoading(),
    );
    final result = await movieService.getGenres();
    result.map(
        successMapper: (genres) =>
            state = state.copyWith(genres: AsyncValue.data(genres)),
        errorMapper: (error) => state = state.copyWith(
            genres: AsyncValue.error(error, StackTrace.current)));
  }

  Future<void> getRecommendedMovie() async {
    state = state.copyWith(
      recommendedMovie: const AsyncLoading(),
    );
    final selectedGenres = state.genres.value!
        .where((genre) => genre.isSelected == true)
        .toList(growable: false);
    final result = await movieService.getRecommendedMovies(
        state.rating, state.yearsBack, selectedGenres);
    result.map(
        successMapper: (movies) {
          final rnd = Random();
          final randomMovie = movies[rnd.nextInt(movies.length)];
          movies.remove(randomMovie);
          state = state.copyWith(
              recommendedMovie: AsyncValue.data(randomMovie),
              relatedMovies: AsyncValue.data(movies));
        },
        errorMapper: (error) => state = state.copyWith(
            recommendedMovie: AsyncValue.error(error, StackTrace.current)));
  }

  void toggleSelected(Genre genre) {
    state = state.copyWith(
        genres: AsyncValue.data(
      [
        for (final oldGenre in state.genres.value!)
          if (oldGenre == genre) oldGenre.toggleSelected() else oldGenre,
      ],
    ));
  }

  void updateRating(int updatedRating) {
    state = state.copyWith(rating: updatedRating < 0 ? 0 : updatedRating);
  }

  void updateYearsBack(int updatedYearsBack) {
    state =
        state.copyWith(yearsBack: updatedYearsBack < 0 ? 0 : updatedYearsBack);
  }

  Future<void> reset({bool? resetGenres}) async {
    if (resetGenres == true) {
      state = MovieState.initial().copyWith(genres: AsyncData([]));
    } else {
      state = MovieState.initial();
    }

    return;
  }

  void setRecommendedMovie(Movie movie) {
    // Create a new list of related movies without the selected movie
    final currentRelatedMovies = state.relatedMovies.value ?? [];
    final updatedRelatedMovies = [...currentRelatedMovies];

    // Add the current recommended movie to related movies if it exists
    if (state.recommendedMovie.value != null) {
      updatedRelatedMovies.add(state.recommendedMovie.value!);
    }

    // Remove the selected movie from related movies
    updatedRelatedMovies.removeWhere((m) => m.title == movie.title);

    // Update the state
    state = state.copyWith(
      recommendedMovie: AsyncValue.data(movie),
      relatedMovies: AsyncValue.data(updatedRelatedMovies),
    );
  }
}
