# MovieFindr

A Flutter application that helps users discover movie recommendations based on their preferences with beautiful animations and a smooth user experience.

![MovieFindr App](assets/images/undraw_horror_movie.png)

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

## Screenshots

(Screenshots would be placed here)

## Getting Started

### Prerequisites

- Flutter SDK (>=3.4.4)
- Dart SDK (>=3.4.4)
- A TMDb API key (for movie data)

### Installation

1. Clone the repository

```bash
git clone https://github.com/j-mary/movie_findr.git
```

2. Navigate to the project directory

```bash
cd movie_findr
```

3. Create a `.env.dart` file in the `lib` directory with your TMDb API key:

```dart
const String tmdbApiKey = 'your_api_key_here';
```

4. Install dependencies

```bash
flutter pub get
```

5. Run the app

```bash
flutter run
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

- **Utilities**:
  - equatable: ^2.0.7
  - multiple_result: ^5.2.0

## Testing

The project includes both unit tests and integration tests:

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/movie_feature_test.dart
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

# Build for Android
dart run rps build:android

# Build for iOS
dart run rps build:ios

# Clean the project
dart run rps clean

# Run linting
dart run rps lint
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
