import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final config = {
    'TMDB_API_KEY': Platform.environment['TMDB_API_KEY'],
  };

  const kFileName = 'lib/.env.dart';
  final file = await File(kFileName).create(recursive: true);
  if (file.existsSync()) {
    file.writeAsString("final appConfig = ${json.encode(config)};");
  }
}
