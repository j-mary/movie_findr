const String landingScreen = 'landing_screen';
const String genreScreen = 'genre_screen';
const String ratingScreen = 'rating_screen';
const String yearsBackScreen = 'years_back_screen';
const String resultScreen = 'result_screen';

extension RoutePaths on String {
  String get path => "/$this";
}
