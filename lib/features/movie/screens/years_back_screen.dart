import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_findr/core/router/routes.dart';
import 'package:movie_findr/core/utils/constants.dart';
import 'package:movie_findr/core/widgets/primary_button.dart';
import 'package:movie_findr/features/movie/movie_controller.dart';

class YearsBackScreen extends ConsumerWidget {
  const YearsBackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieFlowControllerProvider);
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
              "How many years back should we check for?",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${state.yearsBack.ceil()}',
                    style: textTheme.displayMedium),
                Text(
                  'Years back',
                  style: textTheme.headlineMedium?.copyWith(
                    color:
                        textTheme.headlineMedium?.color?.withValues(alpha: .62),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Slider(
              onChanged: (value) {
                notifier.updateYearsBack(value.toInt());
              },
              value: state.yearsBack.toDouble(),
              min: 0,
              max: 70,
              divisions: 70,
              label: '${state.yearsBack.ceil()}',
            ),
            const Spacer(),
            PrimaryButton(
              onPressed: () {
                notifier.getRecommendedMovie();
                context.pushNamed(resultScreen);
              },
              text: 'Amazing',
            ),
            const SizedBox(height: kMediumSpacing)
          ],
        ),
      ),
    );
  }
}
