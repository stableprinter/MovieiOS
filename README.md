# MovieiOS

Native iOS (Swift) app that embeds the Flutter module from `movie_core`. Recreates the Movie Android app architecture with multiple Flutter engines.

## Architecture

- **Main screen**: Bottom tab bar with Browse and Favorite tabs. Each tab hosts a full-screen Flutter view.
- **Extra screen**: Movie detail launched when tapping a movie from the Favorite list. Uses a dynamically created Flutter engine.
- **Flutter engines**: `browse_engine` and `favorite_engine` are cached at launch. Extra engines are created per movie navigation and disposed when the screen is dismissed.

## Prerequisites

- Xcode 26+
- Flutter SDK (for building the Flutter module)
- CocoaPods (optional; this project uses pre-built XCFrameworks)

## Importing Flutter XCFrameworks

This project expects pre-built Flutter XCFrameworks from the `movie_core` module. **Build the frameworks before opening the iOS project.**

### 1. Build the Flutter module

From the `movie_core` directory:

```bash
cd /path/to/fastwork/movie_core
flutter pub get
flutter build ios-framework --output=../MovieiOS/Flutter
```

This creates:

```
MovieiOS/Flutter/
├── Debug/
│   ├── Flutter.xcframework
│   └── App.xcframework
├── Profile/
│   ├── Flutter.xcframework
│   └── App.xcframework
└── Release/
    ├── Flutter.xcframework
    └── App.xcframework
```

### 2. Xcode configuration

The project is already configured to use `$(PROJECT_DIR)/Flutter/$(CONFIGURATION)/` for framework search paths. Build configurations (Debug, Release, Profile) automatically select the matching frameworks.

**Important**: Always use `Flutter.xcframework` and `App.xcframework` from the **same** build mode. Mixing Debug/Release causes runtime crashes.

### 3. LLDB Init (optional, for debugging on iOS 16+)

To avoid crashes when debugging:

1. Run `flutter build ios-framework --output=../MovieiOS/Flutter` (generates LLDB files)
2. In Xcode: **Product → Scheme → Edit Scheme → Run**
3. Set **LLDB Init File** to: `$(PROJECT_DIR)/Flutter/flutter_lldbinit`

## Channel names (must match Android)

- **Method channel**: `com.movie.android/channel`
- **Event channel**: `com.movie.android/events`

## Run

1. Build Flutter frameworks (see above)
2. Open `MovieiOS.xcodeproj` in Xcode
3. Select a simulator or device
4. Build and run (⌘R)
