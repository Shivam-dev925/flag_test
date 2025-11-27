# Applying Feature Flags to Raxa Project

This guide shows you how to apply the feature flag pattern from this demo to your main Raxa Flutter project.

## Quick Overview

The demo you just created shows:
- ✅ How to manage experimental features safely
- ✅ How to keep code in `main` branch but hide from production
- ✅ How to enable features per environment (dev, staging, production)
- ✅ How to organize features by category

## Step-by-Step Integration

### 1. Copy Core Files to Raxa Project

```bash
# From your Raxa project root
cd /Volumes/Transcend/Raxa-Backend-BE/Frontend/raxa_flutter_hybrid

# Create core directory if it doesn't exist
mkdir -p lib/core

# Copy feature flag files
cp /Volumes/Transcend/feature_flag_demo/lib/core/feature_flags.dart lib/core/
cp /Volumes/Transcend/feature_flag_demo/lib/core/feature_flag_service.dart lib/core/
```

### 2. Add Dependency to pubspec.yaml

```yaml
dependencies:
  shared_preferences: ^2.3.4  # For runtime flag storage
```

Then run:
```bash
flutter pub get
```

### 3. Initialize Feature Flag Service in main.dart

```dart
// In lib/main.dart
import 'core/feature_flag_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize feature flags BEFORE runApp
  await FeatureFlagService.instance.init();

  runApp(const MyApp());
}
```

### 4. Configure Your Doctor AI Avatar Feature

Update `lib/core/feature_flags.dart`:

```dart
class FeatureFlags {
  // Advanced Technology Projects
  static const Feature doctorAIAvatar = Feature(
    id: 'doctor_ai_avatar',
    name: 'Doctor AI Avatar',
    description: 'AI-powered doctor avatar with voice interaction',
    category: ProjectCategory.advancedTechnology,
    compileTimeFlag: 'ENABLE_DOCTOR_AI_AVATAR',
    defaultEnabled: false,  // OFF by default
    canToggleAtRuntime: true,  // Can toggle in debug mode
  );

  static const List<Feature> allFeatures = [
    doctorAIAvatar,
    // Add other features here
  ];

  // Convenience getter
  static Future<bool> get isDoctorAIEnabled => doctorAIAvatar.isEnabled();
}
```

### 5. Wrap Your Doctor AI Feature Code

In your Doctor AI screens/widgets:

```dart
// Option 1: Hide entire screen
if (await FeatureFlags.isDoctorAIEnabled) {
  // Show Doctor AI screen
  return DoctorAIScreen();
} else {
  // Show fallback or nothing
  return SizedBox.shrink();
}

// Option 2: Conditionally show in navigation
if (await FeatureFlags.isDoctorAIEnabled) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DoctorAIScreen()),
  );
}

// Option 3: Hide menu item
FutureBuilder<bool>(
  future: FeatureFlags.isDoctorAIEnabled,
  builder: (context, snapshot) {
    if (snapshot.data != true) return SizedBox.shrink();

    return ListTile(
      title: Text('🚀 Doctor AI Avatar'),
      onTap: () => Navigator.push(...),
    );
  },
)
```

### 6. Update Your Branch Strategy

#### Current Branch: `v2025.12.01`

**Option A: Merge to `develop` with Feature Flags (Recommended)**

```bash
# Your current branch has Doctor AI code
git checkout v2025.12.01

# Make sure feature is wrapped with flags
# ... (code changes from steps above)

# Commit the feature flag implementation
git add .
git commit -m "feat: Add Doctor AI avatar behind feature flag

- Wrapped Doctor AI in ENABLE_DOCTOR_AI_AVATAR flag
- Default OFF for production
- Marked as Advanced Technology project
- Can be toggled in debug/staging

BREAKING: This feature is experimental and disabled by default"

# Merge to develop
git checkout develop
git merge v2025.12.01

# Push to develop
git push origin develop
```

**Benefits:**
- Code is in `develop` branch
- Production builds won't show it (flag is OFF by default)
- Staging can enable it with `--dart-define`
- No need for separate long-lived branch

#### Build Commands for Different Environments

**Development (All Features Enabled):**
```bash
flutter run --dart-define=ENABLE_DOCTOR_AI_AVATAR=true
```

**Staging (Selected Features):**
```bash
flutter build apk \
  --dart-define=ENABLE_DOCTOR_AI_AVATAR=true \
  --dart-define=ENVIRONMENT=staging
```

**Production (Stable Only):**
```bash
flutter build apk --release
# Doctor AI will NOT be included
```

### 7. GitHub Workflow Integration

Update your CI/CD to use feature flags:

```yaml
# .github/workflows/android-deploy.yml

# Staging build with advanced features
- name: Build Staging APK
  run: |
    flutter build apk \
      --dart-define=ENABLE_DOCTOR_AI_AVATAR=true \
      --dart-define=ENVIRONMENT=staging

# Production build (no experimental features)
- name: Build Production APK
  run: |
    flutter build apk --release
```

### 8. Add Settings Screen (Optional)

Copy the settings screen to allow runtime toggling in debug mode:

```bash
cp /Volumes/Transcend/feature_flag_demo/lib/screens/settings_screen.dart \
   lib/presentation/mobile/settings/feature_flags_screen.dart
```

Add a menu item to access it:
```dart
ListTile(
  title: Text('Feature Flags'),
  trailing: Icon(Icons.flag),
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FeatureFlagsScreen()),
  ),
)
```

## Deployment Workflow

### For Develop Branch (Testing)

1. **Merge your feature with flags:**
   ```bash
   git checkout develop
   git merge v2025.12.01
   git push origin develop
   ```

2. **Build with feature enabled for testing:**
   ```bash
   flutter build apk --dart-define=ENABLE_DOCTOR_AI_AVATAR=true
   ```

3. **Test on staging environment**

### For Production

1. **Do NOT merge to `main` yet** until feature is stable
2. **If you must release other features:**
   ```bash
   # Cherry-pick only stable commits
   git checkout main
   git cherry-pick <stable-commit-hash>
   git push origin main
   ```

3. **When Doctor AI is ready for production:**
   ```bash
   # Update the defaultEnabled flag
   defaultEnabled: true,  // Now enabled by default

   # Or keep it OFF and require explicit flag
   # (users must opt-in via settings)
   ```

## Testing Checklist

Before merging to `develop`:

- [ ] Feature flag is properly configured
- [ ] Default is `false` in `feature_flags.dart`
- [ ] All Doctor AI code is wrapped with `if (await FeatureFlags.isDoctorAIEnabled)`
- [ ] App builds and runs with flag OFF (production simulation)
- [ ] App builds and runs with flag ON (staging simulation)
- [ ] No references to Doctor AI visible when flag is OFF
- [ ] Feature works correctly when flag is ON

## Real-World Example Commands

### Your Current Situation

```bash
# 1. On your current branch with Doctor AI code
cd /Volumes/Transcend/Raxa-Backend-BE/Frontend/raxa_flutter_hybrid
git checkout v2025.12.01

# 2. Copy feature flag system
cp /Volumes/Transcend/feature_flag_demo/lib/core/*.dart lib/core/

# 3. Wrap Doctor AI code with flags (manual step)
# Edit your Doctor AI files to check FeatureFlags.isDoctorAIEnabled

# 4. Test production simulation (feature should be hidden)
flutter run --release

# 5. Test with feature enabled
flutter run --dart-define=ENABLE_DOCTOR_AI_AVATAR=true

# 6. If tests pass, merge to develop
git add .
git commit -m "feat: Add Doctor AI behind feature flag"
git push origin v2025.12.01

# Create PR to develop on GitHub
# After merge, production builds will NOT include Doctor AI
```

## Benefits of This Approach

1. **✅ Keep Code in Main Repo:** No separate branches needed
2. **✅ Safe for Production:** Experimental code is hidden by default
3. **✅ Easy Testing:** Enable with a single flag
4. **✅ Gradual Rollout:** Enable for specific environments
5. **✅ No Merge Conflicts:** Code stays in sync with main branch
6. **✅ Fast Iteration:** Toggle features without rebuilding

## FAQ

**Q: Will the Doctor AI code be in the production APK?**
A: No! Flutter's tree-shaking removes code behind false flags in release builds.

**Q: Can users enable it in production builds?**
A: No, runtime toggles only work in debug/profile mode. Release builds ignore them.

**Q: How do I enable it for beta testers?**
A: Build with the flag: `flutter build apk --dart-define=ENABLE_DOCTOR_AI_AVATAR=true`

**Q: What if I want to test production behavior?**
A: Run: `flutter run --release` (flag is OFF by default, simulates production)

**Q: Can I have multiple experimental features?**
A: Yes! Add them all to `FeatureFlags.allFeatures` and wrap with individual flags.

## Next Steps

1. ✅ Test this demo app (`cd feature_flag_demo && flutter run`)
2. Copy files to Raxa project
3. Wrap Doctor AI code with feature flags
4. Test both flag ON and OFF scenarios
5. Merge to `develop` branch
6. Production builds will exclude the feature automatically!

---

**Pro Tip:** Keep a build script for each environment:

```bash
# scripts/build_staging.sh
flutter build apk \
  --dart-define=ENABLE_DOCTOR_AI_AVATAR=true \
  --dart-define=ENVIRONMENT=staging

# scripts/build_production.sh
flutter build apk --release
```

This makes it easy to build correct versions consistently!
