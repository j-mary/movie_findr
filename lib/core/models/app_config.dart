import 'package:movie_findr/.env.dart';

final config = AppConfig.fromEnv();

class AppConfig {
  final String tmdbApiKey;
  final ENVIRONMENT environment;

  const AppConfig({
    required this.tmdbApiKey,
    required this.environment,
  });

  AppConfig.fromEnv()
      : tmdbApiKey = env['TMDB_API_KEY'] ?? '',
        environment = ENVIRONMENT.parse(env['ENVIRONMENT']);

  // AppConfig.fromJson(Map<Object, dynamic> map)
  //     : tmdbApiKey = map['TMDB_API_KEY'],
  //       environment = ENVIRONMENT.parse(map['ENVIRONMENT']);
}

enum ENVIRONMENT {
  dev("dev"),
  prod("prod");

  final String name;
  const ENVIRONMENT(this.name);

  static final Map<String, ENVIRONMENT> _map = {
    dev.name: dev,
    prod.name: prod,
  };

  static ENVIRONMENT parse(String? flavor,
      {ENVIRONMENT defaultEnv = ENVIRONMENT.dev}) {
    return flavor != null ? _map[flavor] ?? defaultEnv : defaultEnv;
  }

  @override
  String toString() => name;
}
