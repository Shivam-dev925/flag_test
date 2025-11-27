# Feature Flag Demo

A comprehensive Flutter demo app showcasing how to implement and manage feature flags for experimental features and advanced technology projects.

## 🎯 Purpose

This demo demonstrates best practices for:
- Managing experimental features safely
- Separating stable vs. experimental code
- Using compile-time and runtime feature flags
- Organizing features by project category (Stable, Advanced Technology, Experimental, Beta)
- Building different versions with different features enabled/disabled

## 📋 Features

### Feature Categories

#### ✅ **Stable Features**
- Always available in production
- Fully tested and production-ready
- Example: Enhanced Search

#### 🚀 **Advanced Technology**
- Cutting-edge experimental projects
- Requires explicit opt-in
- Default OFF in production
- Examples: Doctor AI Avatar, Voice to Text

#### 🧪 **Experimental**
- Features under development
- May have bugs or incomplete functionality
- Can be toggled in debug mode
- Examples: Dark Mode, Offline Mode

#### 🔵 **Beta**
- Nearly stable features
- Ready for wider testing
- Example: Enhanced features

## 🏗️ Architecture

### Core Components

```
lib/
├── core/
│   ├── feature_flags.dart         # Central feature flag registry
│   └── feature_flag_service.dart  # Runtime flag management
├── features/
│   ├── doctor_ai/                 # Advanced Technology features
│   └── experimental/              # Experimental features
└── screens/
    └── settings_screen.dart       # Feature flag management UI
```

### Feature Flag System

The system supports two types of flags:

1. **Compile-Time Flags** (via `--dart-define`)
   - Completely removes code in production if not enabled
   - Best for security-sensitive features
   - Example: `--dart-define=ENABLE_DOCTOR_AI_AVATAR=true`

2. **Runtime Flags** (via SharedPreferences)
   - Can be toggled in debug/profile mode
   - Persists across app restarts
   - Example: Toggle dark mode in Settings

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK (included with Flutter)
- iOS Simulator or Android Emulator (or physical device)

### Installation

```bash
cd feature_flag_demo
flutter pub get
```

### Running the App

#### Debug Mode (All features can be toggled)
```bash
flutter run
```

#### With Specific Features Enabled
```bash
# Enable Doctor AI Avatar
flutter run --dart-define=ENABLE_DOCTOR_AI_AVATAR=true

# Enable Dark Mode
flutter run --dart-define=ENABLE_DARK_MODE=true

# Enable multiple features
flutter run \
  --dart-define=ENABLE_DOCTOR_AI_AVATAR=true \
  --dart-define=ENABLE_VOICE_TO_TEXT=true \
  --dart-define=ENABLE_DARK_MODE=true
```

#### Production Build (Experimental features hidden by default)
```bash
# Build without experimental features
flutter build apk --release

# Build with specific advanced tech features
flutter build apk --release \
  --dart-define=ENABLE_DOCTOR_AI_AVATAR=true
```

## 💡 Usage Examples

### Adding a New Feature Flag

1. **Define the feature in `lib/core/feature_flags.dart`:**

```dart
static const Feature myNewFeature = Feature(
  id: 'my_new_feature',
  name: 'My New Feature',
  description: 'Description of what this feature does',
  category: ProjectCategory.experimental,
  compileTimeFlag: 'ENABLE_MY_NEW_FEATURE',
  defaultEnabled: false,
  canToggleAtRuntime: true,
);

// Add to allFeatures list
static const List<Feature> allFeatures = [
  // ... existing features
  myNewFeature,
];
```

2. **Use the feature in your code:**

```dart
// Check if feature is enabled
if (await FeatureFlags.myNewFeature.isEnabled()) {
  // Show feature UI
  return MyNewFeatureWidget();
}
```

3. **Add convenience getter (optional):**

```dart
static Future<bool> get isMyNewFeatureEnabled => myNewFeature.isEnabled();

// Usage
if (await FeatureFlags.isMyNewFeatureEnabled) {
  // ...
}
```

### Toggling Features at Runtime

In debug mode:
1. Open the app
2. Tap the Settings icon (⚙️) in the app bar
3. Find your feature under its category
4. Toggle the switch

### Checking Feature Status in Code

```dart
// Quick check
final isEnabled = await FeatureFlags.isDoctorAIEnabled;

// Detailed check with feature object
final feature = FeatureFlags.doctorAIAvatar;
if (await feature.isEnabled()) {
  // Feature is enabled
}

// Check if any advanced tech features are enabled
if (await FeatureFlags.hasAdvancedTechEnabled()) {
  // Show advanced tech section
}
```

## 🔒 Production Safety

### How Release Builds Work

In **release mode** (`flutter build apk --release`):
- All experimental features are **hidden by default**
- Only features with compile-time flags set to `true` are included
- Runtime toggles are ignored
- Code for disabled features is tree-shaken (removed from final binary)

### Force Disable All Experimental Features

```bash
flutter build apk --release \
  --dart-define=FORCE_DISABLE_ALL_EXPERIMENTAL=true
```

This overrides all feature flags and ensures no experimental code runs in production.

## 📊 Build Variants

### Development Build
```bash
flutter run \
  --dart-define=ENABLE_DOCTOR_AI_AVATAR=true \
  --dart-define=ENABLE_VOICE_TO_TEXT=true \
  --dart-define=ENABLE_DARK_MODE=true \
  --dart-define=ENABLE_EXPERIMENTAL_FEATURES=true
```

### Staging Build (Selected Advanced Features)
```bash
flutter build apk \
  --dart-define=ENABLE_DOCTOR_AI_AVATAR=true \
  --dart-define=ENVIRONMENT=staging
```

### Production Build (Stable Only)
```bash
flutter build apk --release
```

## 🧪 Testing Features

### Debug Mode Testing
1. Run app in debug mode
2. Enable feature in Settings
3. Test functionality
4. Disable feature to verify graceful degradation

### Production Simulation
```bash
# Build in release mode without experimental features
flutter build apk --release

# Install on device
adb install build/app/outputs/flutter-apk/app-release.apk

# Verify experimental features are not visible
```

## 📝 Best Practices

### When to Use Each Category

| Category | Use Case | Default | Toggleable |
|----------|----------|---------|------------|
| **Stable** | Production-ready features | ON | No |
| **Advanced Technology** | Experimental high-tech projects | OFF | Yes (debug) |
| **Experimental** | Features under development | OFF | Yes (debug) |
| **Beta** | Nearly stable, wide testing | ON | Yes |

### Feature Flag Naming Convention

```dart
// Compile-time flags (uppercase with ENABLE_ prefix)
ENABLE_DOCTOR_AI_AVATAR
ENABLE_VOICE_TO_TEXT

// Runtime flag IDs (lowercase with underscores)
doctor_ai_avatar
voice_to_text
```

### Security Considerations

1. **Never expose sensitive features in production** without explicit compile-time flags
2. **Use compile-time flags** for features that could pose security risks
3. **Set `canToggleAtRuntime: false`** for features that shouldn't be user-toggleable
4. **Default to `false`** for all experimental features

## 🔧 Makefile / Scripts (Optional)

Create build scripts for common scenarios:

```bash
# scripts/build_dev.sh
flutter run \
  --dart-define=ENABLE_DOCTOR_AI_AVATAR=true \
  --dart-define=ENABLE_EXPERIMENTAL_FEATURES=true

# scripts/build_production.sh
flutter build apk --release \
  --dart-define=FORCE_DISABLE_ALL_EXPERIMENTAL=true
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web

## 🤝 Contributing

When adding new experimental features:

1. Add feature definition to `FeatureFlags`
2. Create feature screen/widget
3. Wrap with feature flag check
4. Set appropriate category and defaults
5. Update documentation
6. Test in both debug and release builds

## 📚 Additional Resources

- [Flutter Build Modes](https://docs.flutter.dev/testing/build-modes)
- [Conditional Compilation in Dart](https://dart.dev/guides/language/language-tour#conditional-compilation)
- [SharedPreferences Package](https://pub.dev/packages/shared_preferences)

## 🐛 Troubleshooting

### Feature not showing up in Settings
- Check that it's added to `allFeatures` list
- Verify the category is correct
- Ensure `canToggleAtRuntime: true` if you want it toggleable

### Feature still visible in release build
- Verify you're building in release mode (`--release`)
- Check that the compile-time flag is not set
- Ensure feature check uses `await feature.isEnabled()`

### Runtime toggle not persisting
- Ensure `FeatureFlagService.init()` is called in `main()`
- Check SharedPreferences is properly initialized
- Verify app has storage permissions

## 📄 License

MIT License - feel free to use this as a template for your own projects!

## 🙏 Acknowledgments

Built as a demonstration for managing experimental features in Flutter applications, inspired by real-world production apps that need to manage multiple feature releases safely.

---

**Note:** This is a demo app. In production, consider using remote config (Firebase Remote Config, etc.) for more dynamic feature flag management.
