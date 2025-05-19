# MovieFindr

A Flutter application that helps users discover movie recommendations based on their preferences with beautiful animations and a smooth user experience.

![MovieFindr App](assets/images/undraw_movie.png)

## Overview

MovieFindr guides users through an engaging, animated flow to collect preferences like genre, minimum rating, and time period, then recommends movies that match these criteria using The Movie Database (TMDb) API.

## Features

- **Animated User Interface**: Smooth transitions and animations throughout the app
- **Genre Selection**: Choose your preferred movie genres
- **Rating Preferences**: Set minimum rating threshold for recommendations
- **Time Period Selection**: Specify how recent you want the movies to be
- **Personalized Recommendations**: Get movie suggestions based on your preferences
- **Elegant Dark Theme**: Comfortable viewing experience with a dark color scheme
- **Offline Error Handling**: Graceful error handling with retry options
- **Responsive Design**: Works on various screen sizes
- **Multiple Flavors**: Development and Production environments with separate configurations
- **Firebase Integration**: Ready for Firebase services with environment-specific configurations
- **App Signing**: Configured for release builds with proper app signing

## Screenshots

(Screenshots would be placed here)

## Getting Started

### Prerequisites

- Flutter SDK (>=3.4.4)
- Dart SDK (>=3.4.4)
- A TMDb API key (for movie data)
- Firebase project (for dev and prod environments)
- Android keystore for app signing (for release builds)

### Installation

1. Clone the repository

```bash
git clone https://github.com/j-mary/movie_findr.git
```

2. Navigate to the project directory

```bash
cd movie_findr
```

3. Set up environment configuration:

   Create a `lib/env.dart` file based on the example file:

   ```dart
   final devEnv = {
     'TMDB_API_KEY': 'your_tmdb_api_key_here',
     'ENVIRONMENT': 'dev',
   };

   final prodEnv = {
     'TMDB_API_KEY': 'your_tmdb_api_key_here',
     'ENVIRONMENT': 'prod',
   };

   final env = () {
     final envName = const String.fromEnvironment('ENVIRONMENT');
     if (envName == 'prod') return prodEnv;
     return devEnv;
   }();
   ```

4. Set up Firebase configuration:

   Copy the `flutterfire-config.sh.example` file to `flutterfire-config.sh` and update it with your Firebase project IDs.
   Then run:

   ```bash
   chmod +x flutterfire-config.sh
   ./flutterfire-config.sh dev
   ./flutterfire-config.sh prod
   ```

5. Set up app signing (for release builds):

   Create a `key.properties` file in the `android` directory:

   ```
   storePassword=your_keystore_password
   keyPassword=your_key_password
   keyAlias=your_key_alias
   storeFile=path/to/your/keystore.jks
   ```

6. Install dependencies

```bash
flutter pub get
```

7. Run the app with the desired flavor

```bash
# Run with dev flavor
flutter run --flavor dev -t lib/main.dart

# Run with prod flavor
flutter run --flavor prod -t lib/main.dart
```

## Architecture

MovieFindr follows a clean architecture approach with Riverpod for state management. The codebase is organized using a feature-first structure for better maintainability and scalability.

For detailed information about the project architecture and folder structure, please refer to the [ARCHITECTURE.md](ARCHITECTURE.md) file.

## Dependencies

- **State Management**:

  - flutter_riverpod: ^2.6.1
  - riverpod: ^2.6.1

- **Networking**:

  - dio: ^5.8.0+1
  - pretty_dio_logger: ^1.4.0

- **UI/Animations**:

  - skeletonizer: ^1.4.3
  - go_router: ^15.1.2

- **Firebase**:

  - firebase_core: ^3.13.0

- **Utilities**:
  - equatable: ^2.0.7
  - multiple_result: ^5.2.0

## Testing

The project includes both unit tests and integration tests:

```bash
# Run unit tests
flutter test

# Run integration tests (with dev flavor)
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/movie_feature_test.dart --flavor dev
```

## Scripts

MovieFindr includes several useful scripts that can be run using the `rps` package:

```bash
# Run integration tests
dart run rps integration

# Run unit tests
dart run rps test

# Watch tests during development
dart run rps test:watch

# Build for Android (dev flavor)
flutter build apk --flavor dev

# Build for Android (prod flavor)
flutter build apk --flavor prod

# Build for iOS (dev flavor)
flutter build ios --flavor dev

# Build for iOS (prod flavor)
flutter build ios --flavor prod

# Clean the project
flutter clean

# Run linting
dart run rps lint

# Generate app icons
flutter pub run flutter_launcher_icons
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [The Movie Database (TMDb)](https://www.themoviedb.org/) for providing the movie data API
- [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/) teams for the amazing framework
- All the package authors whose work made this project possible
