import 'package:flutter/material.dart';

class NetworkFadingImage extends StatelessWidget {
  const NetworkFadingImage(this.path, {super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, e, s) {
        return const SizedBox();
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }
}
