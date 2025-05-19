import 'package:movie_findr/core/models/app_config.dart';

String firebaseAppName =
    config.environment == ENVIRONMENT.dev ? 'CodeRevDev' : 'CodeRevProd';