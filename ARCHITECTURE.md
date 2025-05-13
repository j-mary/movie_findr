# MovieFindr Architecture

This document outlines the architecture and folder structure of the MovieFindr application to help new developers understand the project organization.

## Architecture Overview

MovieFindr uses the **Riverpod** state management solution with a feature-first folder structure. The application follows a clean architecture approach with clear separation of concerns:

- **Presentation Layer**: Flutter widgets that display UI (screens, components)
- **Domain Layer**: Business logic and state management (controllers, models)
- **Data Layer**: Data access and repository implementations

## Folder Structure

```
lib/
├── core/                  # Core functionality and shared resources
│   ├── assets/            # Asset references and constants
│   ├── entities/          # Data transfer objects for API communication
│   ├── models/            # Domain models used throughout the app
│   ├── utils/             # Utility functions, constants, and providers
│   └── widgets/           # Shared UI components
│
├── features/              # Feature-based modules
│   └── movie/             # Main feature module
│       ├── screens/       # UI screens for the movie flow
│       │   ├── landing_screen.dart    # Welcome screen with animations
│       │   ├── genre_screen.dart      # Genre selection screen
│       │   ├── rating_screen.dart     # Rating selection screen
│       │   ├── years_back_screen.dart # Time period selection screen
│       │   ├── result_screen.dart     # Movie recommendation screen
│       │   └── movie_flow.dart        # Main flow container widget
│       ├── widgets/                   # Feature-specific widgets
│       ├── movie_controller.dart      # Main controller for the flow
│       ├── movie_repository.dart      # Repository interface
│       ├── movie_service.dart         # API service implementation
│       └── movie_state.dart           # State definitions
│
├── theme/                 # Theme configuration
│   ├── custom_theme.dart  # Dark theme setup
│   └── palette.dart       # Color definitions
│
└── main.dart              # Application entry point

assets/
└── images/                # Image assets
```

## State Management

The application uses Riverpod for state management:

- **StateNotifierProvider**: Used for complex state management with the `MovieFlowController`
- **FutureProvider**: Used for asynchronous data loading operations
- **Provider**: Used for simple dependencies and values
- **StateProvider**: Used for simple state that can be modified from multiple places

## Data Flow

1. **Repository Pattern**: The `MovieRepository` interface defines data operations
2. **Service Layer**: The `MovieService` implements the repository interface
3. **Controller**: The `MovieFlowController` manages state and business logic
4. **UI**: Screens consume the state and dispatch actions to the controller

## Navigation Flow

The application uses a `PageView` controlled by the `MovieFlowController` to navigate between screens:

1. Landing Screen (`LandingScreen`) - Animated introduction
2. Genre Selection (`GenreScreen`) - Select movie genres
3. Rating Selection (`RatingScreen`) - Set minimum rating
4. Years Back Selection (`YearsBackScreen`) - Set time period
5. Result Screen (`ResultScreen`) - View recommended movie with animations

## UI Components and Animations

- **Shared Components**:

  - `PrimaryButton`: Standard button used for navigation
  - `ListCard`: Used for selectable items in lists
  - `NetworkFadingImage`: Image component with loading handling
  - `FailureScreen`: Error display with retry functionality

- **Animations**:
  - Landing screen features sequenced fade and slide animations
  - Result screen uses staggered animations for content reveal
  - Animations are controlled to only play once or on demand

## Testing

The project includes both unit tests and integration tests:

- **Unit Tests**: Test individual components and logic
- **Integration Tests**: Test the complete user flow through the application
- **Test Utilities**: Mock repositories for testing without API dependencies

## Running Tests

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/movie_feature_test.dart
```

## Adding New Features

When adding new features:

1. Create appropriate models, entities, and repositories
2. Implement the business logic in controllers
3. Create UI components following the existing patterns
4. Add appropriate tests for new functionality
