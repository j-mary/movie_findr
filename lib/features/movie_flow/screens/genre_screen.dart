import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flow/core/constants.dart';
import 'package:movie_flow/core/widgets/primary_button.dart';
import 'package:movie_flow/features/movie_flow/movie_flow_controller.dart';

import '../widgets/list_card.dart';

class GenreScreen extends ConsumerWidget {
  const GenreScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieFlowControllerProvider);
    final notifier = ref.read(movieFlowControllerProvider.notifier);

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: notifier.previousPage,
        ),
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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: kListItemSpacing),
                itemBuilder: (context, index) {
                  final genre = state.genres[index];
                  return ListCard(
                    genre: genre,
                    onTap: () => notifier.toggleSelected(genre),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: kListItemSpacing,
                  );
                },
                itemCount: state.genres.length,
              ),
            ),
            PrimaryButton(onPressed: notifier.nextPage, text: 'Continue'),
            const SizedBox(height: kMediumSpacing)
          ],
        ),
      ),
    );
  }
}
