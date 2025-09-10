# VetSan

Veterinary Services & Animal Care Platform

A comprehensive veterinary services mobile application built with Flutter, designed to connect pet owners with veterinary professionals in Rwanda.

## Features

- **User Authentication**: Secure login and registration system
- **Service Catalog**: Browse and search veterinary services across categories
- **Pet Management**: Add and manage your pets' profiles
- **Appointment Booking**: Schedule appointments with veterinarians
- **Veterinarian Profiles**: Connect with local veterinary professionals
- **Reviews & Ratings**: Rate and review services and veterinarians
- **Location Services**: Find nearby veterinary clinics and services
- **Push Notifications**: Stay updated with appointment reminders and health tips

## Tech Stack

- **Framework**: Flutter 3.4.3+
- **State Management**: Riverpod
- **HTTP Client**: Dio
- **Architecture**: Clean Architecture with Feature-based structure

## Getting Started

### Prerequisites

- Flutter SDK 3.4.3 or higher
- Dart SDK
- Android Studio / VS Code
- iOS development tools (for iOS builds)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/           # Core functionality (config, theme, routing)
├── features/       # Feature-based modules
│   ├── auth/       # Authentication
│   ├── home/       # Home screen
│   ├── services/   # Veterinary services catalog
│   ├── appointments/ # Appointment booking
│   ├── pets/       # Pet management
│   └── profile/    # User profile
├── shared/         # Shared components and utilities
└── main.dart       # App entry point
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.
