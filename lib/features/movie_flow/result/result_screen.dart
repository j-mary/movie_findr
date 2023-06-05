import 'package:flutter/material.dart';
import 'package:movie_flow/core/constants.dart';
import 'package:movie_flow/core/widgets/primary_button.dart';
import 'package:movie_flow/features/movie_flow/genre/genre.dart';

import 'movie.dart';

class ResultScreen extends StatelessWidget {
  static route({bool fullScreenDialog = true}) =>
      MaterialPageRoute(builder: (context) => const ResultScreen());

  const ResultScreen({Key? key}) : super(key: key);

  final double movieHeight = 150;

  final movie = const Movie(
    title: 'Pulp Fiction',
    overview:
        "Pulp Fiction is a nonlinear narrative that intertwines several interconnected stories involving mobsters, a pair of hitmen, a boxer, a gangster's wife, and a mysterious briefcase. This Quentin Tarantino-directed film is known for its dark humor, pop culture references, and iconic dialogues",
    voteAverage: 4.8,
    genres: [
      Genre(name: 'Crime'),
      Genre(name: 'Neo-Noir'),
      Genre(name: 'Black Comedy'),
      Genre(name: 'Drama'),
      Genre(name: 'Thriller'),
      Genre(name: 'Independent Cinema')
    ],
    releaseDate: 'October 14, 1994',
    backdropPath: '',
    posterPath: '',
  );

  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }
}

class CoverImage extends StatelessWidget {
  const CoverImage({Key? key}) : super(key: key);

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
  const MovieImageDetails({Key? key, required this.movie, required this.height})
      : super(key: key);

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
                          color:
                              textTheme.bodyMedium?.color?.withOpacity(0.62)),
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
