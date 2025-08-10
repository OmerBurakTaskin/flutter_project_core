# Flutter Project Core

This is the core project for Flutter applications. It provides a foundational structure and shared functionality that can be extended to build specific applications. Developers can use this project as a starting point and add their own features on top of it.

## Features

- Modular and scalable architecture.
- Shared utilities and services.
- Pre-configured project setup for faster development.

## Getting Started

To use this core project, follow these steps:

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd flutter_project_core
   ```

2. Ensure you have [FVM](https://fvm.app/) installed for managing Flutter SDK versions:
   ```bash
   dart pub global activate fvm
   ```

3. Install the required Flutter SDK version using FVM:
   ```bash
   fvm install
   fvm use
   ```

4. Run the project:
   ```bash
   fvm flutter run
   ```

## Project Structure

The project is organized as follows:

```
lib/
  ├── core/          # Core functionality
  ├── data/          # Data layer with API clients and repositories
  ├── di/            # Dependency injection setup (Get_it)
  ├── l10n/          # Localization files
  ├── presentation/  # UI components and screens
  ├── providers/     # Riverpod providers
  ├── utils/         # Utility functions and extensions
  └── main.dart      # Application entry point
```

This structure ensures a clean separation of concerns and makes the project easy to extend and maintain.

## Extending the Core Project

You can build your application on top of this core project by adding new modules, features, or UI components. The modular structure allows for easy integration and scalability.

