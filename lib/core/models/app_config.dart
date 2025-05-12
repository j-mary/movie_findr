import 'package:movie_flow/.env.dart';

class AppConfig {
  final String tmdbApiKey;

  const AppConfig({
    required this.tmdbApiKey,
  });

  factory AppConfig.fromEnv() {
    return AppConfig(
      tmdbApiKey: env['TMDB_API_KEY'] ?? '',
    );
  }
}

final config = AppConfig.fromEnv();