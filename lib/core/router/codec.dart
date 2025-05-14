import 'dart:convert';

import 'package:movie_findr/core/index.dart';

class AppRouterCodec extends Codec<Object?, Object?> {
  const AppRouterCodec();

  @override
  Converter<Object?, Object?> get decoder => const _AppRouterDecoder();

  @override
  Converter<Object?, Object?> get encoder => const _AppRouterEncoder();
}

class _AppRouterDecoder extends Converter<Object?, Object?> {
  const _AppRouterDecoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    final List<Object?> inputAsList = input as List<Object?>;
    if (inputAsList[0] == 'Movie') {
      return Movie.fromMap(inputAsList[1] as Map<String, dynamic>);
    }
    return input;
  }
}

class _AppRouterEncoder extends Converter<Object?, Object?> {
  const _AppRouterEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    switch (input) {
      case Movie movie:
        return <Object?>['Movie', movie.toMap()];
      default:
        return input;
    }
  }
}
