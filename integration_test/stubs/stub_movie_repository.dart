import 'package:movie_findr/core/index.dart';
import 'package:movie_findr/features/movie/movie_repository.dart';

class StubMovieRepository implements MovieRepository {
  @override
  Future<List<GenreEntity>> getGenres() async {
    return [GenreEntity.fromGenre(Genre.initial())];
  }

  @override
  Future<List<MovieEntity>> getRecommendedMovies(
      double rating, String date, String genreIds) async {
    return [MovieEntity.fromMovie(Movie.initial())];
  }
}
