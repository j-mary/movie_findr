import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_findr/core/utils/constants.dart';
import 'package:movie_findr/core/widgets/primary_button.dart';
import 'package:movie_findr/features/movie/movie_controller.dart';

class RatingScreen extends ConsumerWidget {
  const RatingScreen({super.key});

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
              "Select a minimum rating\nranging from 1-10",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${state.rating.ceil()}', style: textTheme.displayMedium),
                const Icon(Icons.star_rounded, color: Colors.amber, size: 62)
              ],
            ),
            const Spacer(),
            Slider(
              onChanged: (value) {
                notifier.updateRating(value.toInt());
              },
              value: state.rating.toDouble(),
              min: 1,
              max: 10,
              divisions: 10,
              label: '${state.rating.ceil()}',
            ),
            const Spacer(),
            PrimaryButton(
              onPressed: notifier.nextPage,
              text: 'Yes please',
            ),
            const SizedBox(height: kMediumSpacing)
          ],
        ),
      ),
    );
  }
}
