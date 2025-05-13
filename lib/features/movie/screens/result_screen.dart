import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_findr/core/index.dart';
import 'package:movie_findr/features/movie/movie_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ResultScreenAnimator extends ConsumerStatefulWidget {
  const ResultScreenAnimator({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResultScreenAnimatorState();
}

class _ResultScreenAnimatorState extends ConsumerState<ResultScreenAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(movieFlowControllerProvider, (oldState, newState) {
      if (oldState?.movie is AsyncLoading && newState.movie is AsyncData) {
        _controller.reset();
        _controller.forward();
      }
    });

    return ResultScreen(
      animationController: _controller,
    );
  }
}

class ResultScreen extends ConsumerWidget {
  static route({bool fullScreenDialog = true}) =>
      MaterialPageRoute(builder: (context) => const ResultScreenAnimator());

  ResultScreen({
    super.key,
    required this.animationController,
  })  : titleOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0, 0.3)),
        ),
        genreOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.3, 0.4)),
        ),
        ratingOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.4, 0.6)),
        ),
        descriptionOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.6, 0.8)),
        ),
        buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.8, 1)),
        );

  final AnimationController animationController;

  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> ratingOpacity;
  final Animation<double> descriptionOpacity;
  final Animation<double> buttonOpacity;

  final double movieHeight = 150;

  Widget _buildAnimatedWidget({
    required bool applyAnimations,
    required Animation<double> animation,
    required Widget child,
  }) {
    return applyAnimations
        ? FadeTransition(opacity: animation, child: child)
        : child;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(movieFlowControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close)),
      ),
      body: ref.watch(movieFlowControllerProvider).movie.when(
            data: (movie) => _buildResults(movie, context, ValueKey('data'),
                applyAnimations: true),
            error: (error, stackTrace) => FailureScreen(
                error: error, retry: () => notifier.getRecommendedMovie()),
            loading: () => Skeletonizer(
                enabled: true,
                child: _buildResults(
                    Movie.initial(), context, ValueKey('loading'),
                    applyAnimations: false)),
          ),
    );
  }

  Widget _buildResults(Movie movie, BuildContext context, ValueKey key,
      {required bool applyAnimations}) {
    return Column(
      key: key,
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
                      titleOpacity: titleOpacity,
                      genreOpacity: genreOpacity,
                      ratingOpacity: ratingOpacity,
                      applyAnimations: applyAnimations,
                    ),
                  )
                ],
              ),
              SizedBox(height: movieHeight / 2),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildAnimatedWidget(
                  applyAnimations: applyAnimations,
                  animation: descriptionOpacity,
                  child: Text(
                    movie.overview,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildAnimatedWidget(
          applyAnimations: applyAnimations,
          animation: buttonOpacity,
          child: PrimaryButton(
            onPressed: () => Navigator.of(context).pop(),
            text: 'Find another movie',
          ),
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
          child: NetworkFadingImage(movie.backdropPath ?? ''),
        ),
      ),
    );
  }
}

class MovieImageDetails extends StatelessWidget {
  const MovieImageDetails({
    super.key,
    required this.movie,
    required this.height,
    required this.titleOpacity,
    required this.genreOpacity,
    required this.ratingOpacity,
    required this.applyAnimations,
  });

  final Movie movie;
  final double height;
  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> ratingOpacity;
  final bool applyAnimations;

  Widget _buildAnimatedWidget({
    required bool applyAnimations,
    required Animation<double> animation,
    required Widget child,
  }) {
    return applyAnimations
        ? FadeTransition(opacity: animation, child: child)
        : child;
  }

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
              child: NetworkFadingImage(movie.posterPath ?? ''),
            ),
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimatedWidget(
                  applyAnimations: applyAnimations,
                  animation: titleOpacity,
                  child: Text(
                    movie.title,
                    style: textTheme.titleLarge,
                  ),
                ),
                _buildAnimatedWidget(
                  applyAnimations: applyAnimations,
                  animation: genreOpacity,
                  child: Text(
                    movie.genresCommaSeparated,
                    style: textTheme.bodyMedium,
                  ),
                ),
                _buildAnimatedWidget(
                  applyAnimations: applyAnimations,
                  animation: ratingOpacity,
                  child: Row(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
