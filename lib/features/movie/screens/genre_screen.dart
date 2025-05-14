import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_findr/core/index.dart';
import 'package:movie_findr/core/router/routes.dart';
import 'package:movie_findr/features/movie/movie_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/list_card.dart';

class GenreScreen extends ConsumerWidget {
  const GenreScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(movieFlowControllerProvider.notifier);

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Let's start with a genre",
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: ref.watch(movieFlowControllerProvider).genres.when(
                    data: (genres) {
                      return _buildGenreList(genres, ref);
                    },
                    error: (error, stackTrace) => FailureScreen(
                        error: error, retry: () => notifier.loadGenres()),
                    loading: () => Skeletonizer(
                        enabled: true,
                        child: _buildGenreList(
                            List.filled(2, Genre.initial()), ref)),
                  ),
            ),
            PrimaryButton(
              onPressed: () {
                if (!ref
                    .read(movieFlowControllerProvider)
                    .genres
                    .value!
                    .any((element) => element.isSelected == true)) {
                  return;
                }
                context.pushNamed(ratingScreen);
              },
              text: 'Continue',
            ),
            const SizedBox(height: kMediumSpacing)
          ],
        ),
      ),
    );
  }

  Widget _buildGenreList(List<Genre> genres, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: kListItemSpacing),
      itemBuilder: (context, index) {
        final genre = genres[index];
        return ListCard(
          genre: genre,
          onTap: () => ref
              .read(movieFlowControllerProvider.notifier)
              .toggleSelected(genre),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: kListItemSpacing,
        );
      },
      itemCount: genres.length,
    );
  }
}
