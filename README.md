# Monthly Shop Tracker 🛒

A production-ready, offline-first Flutter application designed to track shopping lists and monthly expenses with a sleek, modern aesthetic.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-%232D3037.svg?style=for-the-badge&logo=riverpod&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-Database-FFD600?style=for-the-badge)

## ✨ Features

- **Multi-List Management**: Create and organize multiple shopping lists for different stores or categories.
- **Permanent Aisle View**: Items are permanently grouped by category for a cleaner, highly organized shopping experience.
- **Smart Autocomplete & Price History**: Predictive item entry and historical price tracking.
- **Smart Totals**: Automatic calculation of total expenses based on "purchased" items.
- **Offline-First**: Fully functional without an internet connection using **Hive NoSQL** storage.
- **Localization (i18n)**: Full support for English and Indonesian.
- **Premium UI/UX**:
  - Sophisticated **Glassmorphism** (frosted glass) effects on headers and modals.
  - Dynamic **Animated Mesh Gradients** for a vibrant, living aesthetic.
  - **Fluid Micro-Interactions**: Smooth entrance animations and satisfying tactile feedback.
  - **Completion Celebration**: Automatic confetti bursts when a list is fully completed under budget.
  - Refined typography using **Outfit** for headlines and **Inter** for data readability.

## 🏗️ Architecture

The project follows a **Feature-First Clean Architecture** pattern to ensure scalability and testability:

- **Domain Layer**: Pure business logic and entities (ShoppingList, Item) with zero framework dependencies.
- **Data Layer**: Concrete implementation of repositories using Hive, including model mapping and code generation.
- **Presentation Layer**: Reactive state management using Riverpod (AsyncNotifiers) and modern Flutter UI components.

```text
lib/
├── core/               # App-wide constants and utilities
└── features/
    └── shopping/
        ├── data/       # Hive models and Repository implementations
        ├── domain/     # Entities, Abstract Repositories, and Use Cases
        └── presentation/ # Riverpod Providers, Screens, and Widgets
```

## 🛠️ Technology Stack

- **Framework**: Flutter 3.x
- **State Management**: [Riverpod](https://riverpod.dev/) (v2.x)
- **Local Storage**: [Hive](https://docs.hivedb.dev/)
- **Formatting**: [intl](https://pub.dev/packages/intl) for currency and date formatting
- **ID Generation**: [uuid](https://pub.dev/packages/uuid) for unique cross-session identifiers

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Dart SDK

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Breakrule/shopping_tracker.git
   cd monthly_shop_tracker
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate code (Hive Adapters)**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## 🧪 Testing

The project includes unit tests for core business logic:
```bash
flutter test
```

## 📜 License

This project is open-source and available under the MIT License.
