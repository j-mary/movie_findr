import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_findr/core/router/index.dart';
import 'package:movie_findr/theme/custom_theme.dart';

void main() async {
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
