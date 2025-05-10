import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flow/core/constants.dart';
import 'package:movie_flow/core/widgets/primary_button.dart';
import 'package:movie_flow/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_flow/features/movie_flow/result/result_screen.dart';

class YearsBackScreen extends ConsumerWidget {
  const YearsBackScreen({Key? key}) : super(key: key);

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
                    color: textTheme.headlineMedium?.color?.withValues(alpha: .62),
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
                Navigator.push(context, ResultScreen.route());
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
