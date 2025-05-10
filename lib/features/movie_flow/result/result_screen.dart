import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flow/core/constants.dart';
import 'package:movie_flow/core/widgets/primary_button.dart';
import 'package:movie_flow/features/movie_flow/movie_flow_controller.dart';

import 'movie.dart';

class ResultScreen extends ConsumerWidget {
  static route({bool fullScreenDialog = true}) =>
      MaterialPageRoute(builder: (context) => const ResultScreen());

  const ResultScreen({super.key});

  final double movieHeight = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieFlowControllerProvider);

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   // leading: InkWell(
      //   //   onTap: () => Navigator.of(context).pop(),
      //   //   child: const Icon(Icons.close),
      //   // ),
      // ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CoverImage(),
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: -(movieHeight / 2),
                      child: MovieImageDetails(
                        movie: state.movie,
                        height: movieHeight,
                      ),
                    )
                  ],
                ),
                SizedBox(height: movieHeight / 2),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    state.movie.overview,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          PrimaryButton(
            onPressed: () => Navigator.of(context).pop(),
            text: 'Find another movie',
          ),
          const SizedBox(height: kMediumSpacing)
        ],
      ),
    );
  }
}

class CoverImage extends StatelessWidget {
  const CoverImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 298),
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromLTRB(0, 0, rect.width, rect.height),
          );
        },
        blendMode: BlendMode.dstIn,
        child: const Placeholder(),
      ),
    );
  }
}

class MovieImageDetails extends StatelessWidget {
  const MovieImageDetails(
      {super.key, required this.movie, required this.height});

  final Movie movie;
  final double height;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: height,
            child: const Placeholder(),
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.titleLarge,
                ),
                Text(
                  movie.genresCommaSeparated,
                  style: textTheme.bodyMedium,
                ),
                Row(
                  children: [
                    Text(
                      '${movie.voteAverage}',
                      style: textTheme.bodyMedium?.copyWith(
                          color: textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.62)),
                    ),
                    const Icon(
                      Icons.star_rounded,
                      size: 20,
                      color: Colors.amber,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
