# Kids Routine Visual

A minimal Flutter app that helps kids (4–10) complete morning and evening routines using big icons, timers, and daily rewards. Works fully offline and stores everything locally per child profile.

## Features

- Two profiles (Child 1 / Child 2) with separate routines and progress
- Morning + Evening routines with icon cards and simple checklists
- Optional timers (e.g., brush teeth 2:00) with haptic/sound feedback
- Daily reset of progress based on local date
- Reward sticker dialog once a routine is fully complete
- Routine editor (add/edit/delete/reorder tasks)
- Web PWA offline cache + Android ready

## Tech stack

- Flutter (stable)
- Riverpod for state management
- GoRouter for navigation
- Hive for local storage

## Project structure

```
lib/
  app.dart
  main.dart
  core/
    icon_mapper.dart
    localization/
      app_localizations.dart
  data/
    defaults.dart
    models.dart
    storage.dart
  presentation/
    screens/
      home_screen.dart
      routine_editor_screen.dart
      routine_screen.dart
      settings_screen.dart
    state/
      app_state_notifier.dart
    widgets/
      reward_dialog.dart
      timer_overlay.dart
```

## Running locally

```bash
flutter pub get
flutter run
```

### Android (APK)

```bash
flutter build apk --release
```

### Web (PWA)

```bash
flutter build web
flutter run -d chrome
```

After the first load, the app should remain usable offline thanks to the service worker cache.

## Tests

```bash
flutter test
```

## Next steps (post-MVP)

- Add more icon packs and sticker themes
- Sound customization and larger visual timers
- Routine analytics shown locally to parents (no network)
- Per-task optional photos or custom icons
- Accessibility improvements for color-blind modes
