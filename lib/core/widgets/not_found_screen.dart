import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const homePath = '/home';

class NotFoundScreen extends StatelessWidget {
  final String? message;

  const NotFoundScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.movie, size: 100, color: Colors.blue),
              const SizedBox(height: 30),
              Text("Oops! Page not found!", style: textTheme.titleLarge),
              const SizedBox(height: 20),
              Text(
                message ??
                    "We are very sorry for the inconvenience. It looks like you’re trying to access a page that has been deleted or never existed.",
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => context.goNamed('home'),
                child: const Text("Back to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
