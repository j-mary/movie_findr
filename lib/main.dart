import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_findr/core/models/app_config.dart';
import 'package:movie_findr/core/router/index.dart';
import 'package:movie_findr/core/utils/values.dart';
import 'package:movie_findr/firebase_config/firebase_options_dev.dart' as dev;
import 'package:movie_findr/firebase_config/firebase_options_prod.dart' as prod;
import 'package:movie_findr/theme/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions? firebaseOptions = config.environment == ENVIRONMENT.dev
      ? dev.DefaultFirebaseOptions.currentPlatform
      : prod.DefaultFirebaseOptions.currentPlatform;
  await Firebase.initializeApp(name: firebaseAppName, options: firebaseOptions);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.read(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MovieFindr',
      darkTheme: CustomTheme.darkTheme(context),
      themeMode: ThemeMode.dark,
      routerConfig: appRouter.router,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
          // child: MediaQuery(
          //   data: MediaQuery.of(context)
          //       .copyWith(textScaler: TextScaler.linear(1.0)),
          //   child: child!,
          // ),
        );
      },
    );
  }
}
