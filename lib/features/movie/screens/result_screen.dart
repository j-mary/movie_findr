import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flow/core/index.dart';
import 'package:movie_flow/features/movie/movie_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ResultScreen extends ConsumerWidget {
  static route({bool fullScreenDialog = true}) =>
      MaterialPageRoute(builder: (context) => const ResultScreen());

  const ResultScreen({super.key});

  final double movieHeight = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(movieFlowControllerProvider.notifier);

    return Scaffold(
      body: ref.watch(movieFlowControllerProvider).movie.when(
            data: (movie) => _buildResults(movie, context),
            error: (error, stackTrace) => FailureScreen(
                error: error, retry: () => notifier.getRecommendedMovie()),
            loading: () => Skeletonizer(
                enabled: true, child: _buildResults(Movie.initial(), context)),
          ),
    );
  }

  Widget _buildResults(Movie movie, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CoverImage(movie),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: -(movieHeight / 2),
                    child: MovieImageDetails(
                      movie: movie,
                      height: movieHeight,
                    ),
                  )
                ],
              ),
              SizedBox(height: movieHeight / 2),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  movie.overview,
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
    );
  }
}

class CoverImage extends StatelessWidget {
  const CoverImage(this.movie, {super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Skeleton.leaf(
      child: Container(
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
          child: Image.network(
            movie.backdropPath ?? '',
            fit: BoxFit.cover,
            errorBuilder: (_, e, s) {
              return const SizedBox();
            },
          ),
        ),
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
            child: Skeleton.replace(
              child: Image.network(
                movie.posterPath ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) {
                  return const SizedBox();
                },
              ),
            ),
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
