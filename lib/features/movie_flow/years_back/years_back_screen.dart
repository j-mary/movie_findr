import 'package:flutter/material.dart';
import 'package:movie_flow/core/constants.dart';
import 'package:movie_flow/core/widgets/primary_button.dart';
import 'package:movie_flow/features/movie_flow/result/result_screen.dart';

class YearsBackScreen extends StatefulWidget {
  const YearsBackScreen(
      {Key? key, required this.nextPage, required this.previousPage})
      : super(key: key);

  final VoidCallback nextPage;
  final VoidCallback previousPage;

  @override
  State<YearsBackScreen> createState() => _YearsBackScreenState();
}

class _YearsBackScreenState extends State<YearsBackScreen> {
  double yearsBack = 10;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: widget.previousPage,
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
                Text('${yearsBack.ceil()}', style: textTheme.displayMedium),
                Text(
                  'Years back',
                  style: textTheme.headlineMedium?.copyWith(
                    color: textTheme.headlineMedium?.color?.withOpacity(0.62),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Slider(
              onChanged: (value) {
                setState(() {
                  yearsBack = value;
                });
              },
              value: yearsBack,
              min: 0,
              max: 70,
              divisions: 70,
              label: '${yearsBack.ceil()}',
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
