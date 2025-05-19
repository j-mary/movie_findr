import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_findr/core/index.dart';
import 'package:movie_findr/core/router/index.dart';
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
      if (oldState?.recommendedMovie is AsyncLoading &&
          newState.recommendedMovie is AsyncData) {
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
              parent: animationController, curve: const Interval(0.4, 0.5)),
        ),
        dateOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.5, 0.6)),
        ),
        descriptionOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.6, 0.7)),
        ),
        relatedMoviesOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.7, 0.9)),
        ),
        buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
              parent: animationController, curve: const Interval(0.9, 1)),
        );

  final AnimationController animationController;

  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> ratingOpacity;
  final Animation<double> dateOpacity;
  final Animation<double> descriptionOpacity;
  final Animation<double> relatedMoviesOpacity;
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
          onPressed: () => context.pop(),
          icon: Icon(Icons.close),
        ),
      ),
      body: ref.watch(movieFlowControllerProvider).recommendedMovie.when(
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

  final ScrollController _scrollController = ScrollController();

  Widget _buildResults(Movie movie, BuildContext context, ValueKey key,
      {required bool applyAnimations}) {
    // Scroll to top when a new movie is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Column(
      key: key,
      children: [
        Expanded(
          child: ListView(
            controller: _scrollController,
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
                      dateOpacity: dateOpacity,
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
              _buildAnimatedWidget(
                applyAnimations: applyAnimations,
                animation: relatedMoviesOpacity,
                child: RelatedMoviesSection(),
              ),
            ],
          ),
        ),
        _buildAnimatedWidget(
          applyAnimations: applyAnimations,
          animation: buttonOpacity,
          child: PrimaryButton(
            onPressed: () => context.goNamed(landingScreen),
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
    required this.dateOpacity,
    required this.applyAnimations,
  });

  final Movie movie;
  final double height;
  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> ratingOpacity;
  final Animation<double> dateOpacity;
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

  String _formatReleaseDate(String date) {
    if (date.isEmpty) return 'Unknown';
    try {
      final parsedDate = DateTime.parse(date);
      return 'Released: ${parsedDate.toShortDate()}';
    } catch (e) {
      return 'Released: $date';
    }
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
                _buildAnimatedWidget(
                  applyAnimations: applyAnimations,
                  animation: dateOpacity,
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatReleaseDate(movie.releaseDate),
                        style: textTheme.bodyMedium?.copyWith(
                            color: textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.62)),
                      ),
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

class RelatedMoviesSection extends ConsumerWidget {
  const RelatedMoviesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final relatedMovies = ref.watch(movieFlowControllerProvider).relatedMovies;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Text(
                  'You might also like',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '(${relatedMovies.value?.length ?? 0})',
                  style: textTheme.bodyMedium?.copyWith(
                      // color: textTheme.bodyMedium?.color?.withValues(alpha: 0.62),
                      ),
                ),
              ],
            ),
          ),
          relatedMovies.when(
            data: (movies) {
              if (movies.isEmpty) {
                return const SizedBox.shrink();
              }
              return SizedBox(
                height: 255,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return SizedBox(
                      width: 140,
                      child: RelatedMovieCard(
                        movie: movie,
                        onTap: () {
                          ref
                              .read(movieFlowControllerProvider.notifier)
                              .setRecommendedMovie(movie);
                        },
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class RelatedMovieCard extends StatelessWidget {
  const RelatedMovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  final Movie movie;
  final VoidCallback onTap;

  String _formatReleaseYear(String date) {
    if (date.isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(date);
      return parsedDate.year.toString();
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(kBorderRadius),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 2 / 3,
                    child: NetworkFadingImage(movie.posterPath ?? ''),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                        splashColor: Colors.black26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_formatReleaseYear(movie.releaseDate)} ${movie.voteAverage}⭐',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
