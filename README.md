# GestAbsence

Absence tracking app for FSB. Manage attendance across students, teachers, and admins.

## Features

- **Student side**: View your absences and attendance records
- **Teacher side**: Mark attendance for classes
- **Admin side**: Dashboard with stats, manage students/teachers, schedule classes

## Setup

### Prerequisites
- Flutter SDK installed
- Dart 3.0+

### Installation

1. Clone the repo
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
├── main.dart                    # Entry point
├── config/                      # App configuration & styling
├── models/                      # Data models
├── screens/                     # UI screens
│   ├── login_screen.dart
│   ├── etudiant/               # Student screens
│   ├── enseignant/             # Teacher screens
│   └── admin/                  # Admin screens
└── services/                    # API calls & business logic
```

## Authentication

Uses email/password login. Session stored locally. Check `auth_service.dart` for details.

## Build & Deploy

Build APK:
```bash
flutter build apk --release
```
