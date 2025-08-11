# Flutter Project Core

This is the core project for Flutter applications. It provides a ready-to-use foundation with essential services, utilities, and architecture patterns. You can start building new apps instantly without repeating boilerplate setup for networking, state management, localization, and connectivity.

## 🚀 Features

- **Modular & Scalable Architecture** — Clear separation of concerns for maintainable code.
- **State Management with Riverpod** — Simple, testable, and reactive state management.
- **Dependency Injection (GetIt)** — Service locator for better decoupling.
- **Networking with Dio** — Pre-configured API service with request logging.
- **Automatic Connection Check** — Real-time network monitoring using `internet_connection_checker_plus`.
- **Localization Ready (intl)** — Built-in setup with l10n and ARB file support.
- **Pre-configured Project Setup** — Common utilities, error handling, and base response models.

## 📦 Getting Started

### Clone the repository
```bash
git clone https://github.com/OmerBurakTaskin/flutter_project_core.git
cd flutter_project_core
```

### Install FVM (Flutter Version Manager)
```bash
dart pub global activate fvm
```

### Install required Flutter SDK
```bash
fvm install
fvm use
```

### Run the project
```bash
fvm flutter run
```

## 📂 Project Structure

The project is organized as follows:

```
lib/
  ├── core/          # Core functionality (constants, theming, base classes)
  ├── data/          # Data layer (API services, repositories, models)
  ├── di/            # Dependency injection setup (GetIt registrations)
  ├── l10n/          # Localization files (.arb)
  ├── presentation/  # UI components and screens
  ├── providers/     # Riverpod providers
  ├── utils/         # Utility functions and extensions
  └── main.dart      # Application entry point
```

## 🌍 Localization

The project is pre-configured with:

- `flutter_localizations` SDK package.
- `intl` for translations.
- `l10n.yaml` for build_runner generation.

### To add new translations:
1. Add your `.arb` files inside `lib/l10n/`.
2. Run:
   ```bash
   flutter gen-l10n
   ```

### Usage in widgets:
```dart
AppLocalizations.of(context)!.helloWorld
```

## 🔌 Network & Connectivity

- API calls handled via `ApiService` using Dio.
- Automatic connection checks with `internet_connection_checker_plus`.
- Global network status monitoring.
- Common `ApiResponse` model for success/error handling.

## 🛠️ Extending the Core

- Add features in `lib/features/`.
- Register new services in `lib/core/di/`.

---

**Note:** This core project aims to save development time and keeps your codebase clean, maintainable, and production-ready from day one.

