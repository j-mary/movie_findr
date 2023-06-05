import 'package:flutter/material.dart';
import 'package:movie_flow/core/constants.dart';
import 'package:movie_flow/core/widgets/primary_button.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen(
      {Key? key, required this.nextPage, required this.previousPage})
      : super(key: key);

  final VoidCallback nextPage;
  final VoidCallback previousPage;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 5;

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
              "Select a minimum rating\nranging from 1-10",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${rating.ceil()}', style: textTheme.displayMedium),
                const Icon(Icons.star_rounded, color: Colors.amber, size: 62)
              ],
            ),
            const Spacer(),
            Slider(
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
              value: rating,
              min: 1,
              max: 10,
              divisions: 10,
              label: '${rating.ceil()}',
            ),
            const Spacer(),
            PrimaryButton(
              onPressed: widget.nextPage,
              text: 'Yes please',
            ),
            const SizedBox(height: kMediumSpacing)
          ],
        ),
      ),
    );
  }
}
