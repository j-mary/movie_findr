final devEnv = {
  'TMDB_API_KEY': '',
  'ENVIRONMENT': 'dev',
};

final prodEnv = {
  'TMDB_API_KEY': '',
  'ENVIRONMENT': 'prod',
};

final env = () {
  final envName = const String.fromEnvironment('ENVIRONMENT');
  if (envName == 'prod') return prodEnv;
  return devEnv;
}();