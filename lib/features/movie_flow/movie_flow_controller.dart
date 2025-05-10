import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flow/features/movie_flow/movie_flow_state.dart';

import 'genre/genre.dart';

final movieFlowControllerProvider =
    StateNotifierProvider.autoDispose<MovieFlowController, MovieFlowState>(
        (ref) {
  return MovieFlowController(
    MovieFlowState(
      pageController: PageController(),
    ),
  );
});

class MovieFlowController extends StateNotifier<MovieFlowState> {
  MovieFlowController(super.state);

  void toggleSelected(Genre genre) {
    state = state.copyWith(
      genres: [
        for (final oldGenre in state.genres)
          if (oldGenre == genre) oldGenre.toggleSelected() else oldGenre,
      ],
    );
  }

  void updateRating(int updatedRating) {
    state = state.copyWith(rating: updatedRating);
  }

  void updateYearsBack(int updatedYearsBack) {
    state = state.copyWith(yearsBack: updatedYearsBack);
  }

  void nextPage() {
    if (state.pageController.page! >= 1) {
      if (!state.genres.any((element) => element.isSelected == true)) {
        return;
      }
    }

    state.pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void previousPage() {
    state.pageController.previousPage(
      duration: const Duration(microseconds: 600),
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }
}
