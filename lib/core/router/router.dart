import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_findr/core/index.dart';
import 'package:movie_findr/core/router/codec.dart';
import 'package:movie_findr/core/router/index.dart';
import 'package:movie_findr/features/movie/screens/index.dart';

final routerProvider = Provider((ref) => AppRouter(ref));

class AppRouter {
  final Ref ref;

  AppRouter(this.ref);

  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirectLimit: 5,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: landingScreen,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            const MaterialPage(child: LandingScreen()),
      ),
      GoRoute(
        path: genreScreen.path,
        name: genreScreen,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            const MaterialPage(child: GenreScreen()),
      ),
      GoRoute(
        path: ratingScreen.path,
        name: ratingScreen,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            const MaterialPage(child: RatingScreen()),
      ),
      GoRoute(
        path: yearsBackScreen.path,
        name: yearsBackScreen,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            const MaterialPage(child: YearsBackScreen()),
      ),
      GoRoute(
        path: resultScreen.path,
        name: resultScreen,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            const MaterialPage(child: ResultScreenAnimator()),
      ),
    ],
    redirect: (context, state) {
      return null;
    },
    errorPageBuilder: (context, state) =>
        const MaterialPage(child: NotFoundScreen()),
    extraCodec: AppRouterCodec(),
  );
}
