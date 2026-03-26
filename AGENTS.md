# Repository Guidelines

## Project Structure & Module Organization
- `lib/` contains the Flutter application code. Entry point is `lib/main.dart`.
- `web/` holds the web runner and web-specific assets.
- `build/` is generated output from local builds and should not be edited.
- `pubspec.yaml` declares dependencies and SDK constraints; `analysis_options.yaml` enables `flutter_lints`.
- Target organization: follow Clean Architecture. When adding modules, separate layers such as `lib/src/core`, `lib/src/features/<feature>/domain`, `lib/src/features/<feature>/data`, and `lib/src/features/<feature>/presentation`.

## Development Flow (Clean Architecture)
- Start from the `domain` layer: define entities, value objects, and use cases for the feature.
- Add `data` layer implementations: repositories, data sources, models, and mappers.
- Build the `presentation` layer last: state management, pages, and widgets.
- Keep dependencies flowing inward: `presentation` -> `domain`, `data` -> `domain`, never the reverse.
- Prefer interfaces/abstract classes in `domain`, concrete implementations in `data`.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies.
- `flutter run -d chrome` runs the app on the web target.
- `flutter build web` creates a release build under `build/web/`.
- `flutter analyze` runs static analysis.
- `dart format .` formats Dart source files.
- `flutter test` executes the test suite.

## Coding Style & Naming Conventions
- Indentation: 2 spaces (standard Dart formatting).
- File naming: `lower_snake_case.dart`.
- Types and widgets: `UpperCamelCase`.
- Prefer extracting reusable UI into separate widgets whenever possible.
- Avoid modifying generated artifacts in `build/`.

## Testing Guidelines (TDD First)
- TDD is the top priority: write tests before production code.
- Framework: `flutter_test`.
- Place tests in `test/` using names like `feature_widget_test.dart`.
- Consider Golden Tests for UI validation, especially for core screens.

## Commit & Pull Request Guidelines
- Use Git with Conventional Commits (e.g., `feat: add settings screen`).
- PRs should include a concise summary, testing notes (commands run), and screenshots for UI changes.
- When a change is relevant to users or contributors, update `README.md` accordingly.

## Quality Gate (Required)
- After finishing any change, always run, in order:
  `flutter analyze`, `dart format .`, `flutter test`.
