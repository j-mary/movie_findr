# Movie Flow Architecture

This document outlines the architecture and folder structure of the Movie Flow application to help new developers understand the project organization.

## Architecture Overview

Movie Flow uses the **Riverpod** state management solution with a feature-first folder structure. The application follows a simplified version of the MVVM (Model-View-ViewModel) pattern:

- **Views**: Flutter widgets that display UI (screens, components)
- **Controllers**: Handle business logic and state management (using Riverpod)
- **Models**: Data structures representing the application's data

## Folder Structure

```
lib/
├── features/              # Feature-based modules
│   └── movie_flow/        # Main feature module
│       ├── genre/         # Genre selection screen
│       ├── landing/       # Landing/welcome screen
│       ├── rating/        # Rating selection screen
│       ├── years_back/    # Time period selection screen
│       ├── movie_flow.dart        # Main flow widget
│       └── movie_flow_controller.dart  # Main controller
├── theme/                 # Theme configuration
│   └── custom_theme.dart  # Dark theme setup
└── main.dart              # Application entry point

assets/
└── images/                # Image assets
    └── undraw_horror_movie.png  # Landing screen image
```

## State Management

The application uses Riverpod for state management:

- **Providers**: Defined in controller files to expose state and functionality
- **ConsumerWidget**: Used to access providers in UI components
- **StateNotifier**: Used for complex state management

## Navigation Flow

The application uses a `PageView` controlled by the `MovieFlowController` to navigate between screens:

1. Landing Screen (`LandingScreen`)
2. Genre Selection (`GenreScreen`)
3. Rating Selection (`RatingScreen`)
4. Years Back Selection (`YearsBackScreen`)

## UI Components

Common UI components are shared across screens:
- `PrimaryButton`: Standard button used for navigation
- `ListCard`: Used for selectable items in lists

## Adding New Features

When adding new features:

1. Create a new directory under `features/` for the feature
2. Follow the existing pattern of separating UI (screens) from logic (controllers)
3. Use Riverpod providers to expose state and functionality

## Testing

The project includes a basic test setup in the `test/` directory. Add unit tests for new functionality following the existing pattern.