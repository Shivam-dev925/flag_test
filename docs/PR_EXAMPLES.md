# Pull Request Examples: Feature Flags Strategy

This guide shows real-world examples of creating PRs to `develop` and `main` branches with different feature flag scenarios.

## Scenario 1: New Experimental Feature (With Feature Flag)

### 🎯 Use Case
You built Doctor AI Avatar - an experimental feature that should:
- ✅ Be merged to `develop` for testing
- ❌ NOT be visible in production yet
- ✅ Be toggleable in staging/dev environments

### Git Workflow

```bash
# Your current branch with Doctor AI code
git checkout v2025.12.01  # or your feature branch

# Ensure feature is wrapped with flags
# (Manual step - wrap code with FeatureFlags.isDoctorAIEnabled)

# Add feature flag configuration
git add lib/core/feature_flags.dart
git add lib/core/feature_flag_service.dart
git add lib/main.dart  # FeatureFlagService.init()
git add lib/presentation/mobile/doctor_ai/  # Your feature code

# Commit with clear message
git commit -m "feat(advanced-tech): Add Doctor AI avatar behind feature flag

Implements:
- AI-powered doctor avatar with voice interaction
- Socket-based real-time communication
- Animated avatar visualization
- Voice-to-text integration

Feature Flag:
- Flag: ENABLE_DOCTOR_AI_AVATAR
- Default: OFF (hidden in production)
- Category: Advanced Technology
- Can toggle: Yes (in debug/staging)

Usage:
  # Enable for testing
  flutter run --dart-define=ENABLE_DOCTOR_AI_AVATAR=true

  # Production build (feature hidden)
  flutter build apk --release

BREAKING CHANGE: This is an experimental feature behind a flag.
Production builds will NOT include this feature unless explicitly enabled.

Refs: #123
Co-authored-by: Team Member <email@example.com>"

# Push your branch
git push origin v2025.12.01
```

### PR to `develop` (Experimental Feature)

**PR Title:**
```
feat(advanced-tech): Add Doctor AI avatar behind feature flag 🚀
```

**PR Description:**
```markdown
## 🚀 Advanced Technology Feature

### Summary
Adds Doctor AI Avatar - an experimental AI-powered medical assistant feature.

**⚠️ This feature is behind a feature flag and OFF by default in production.**

### What's Changed
- ✅ Implemented Doctor AI avatar with real-time voice interaction
- ✅ Added socket-based communication for AI responses
- ✅ Created animated avatar visualization
- ✅ Integrated voice-to-text capability
- ✅ Wrapped feature behind `ENABLE_DOCTOR_AI_AVATAR` flag

### Feature Flag Configuration

```dart
Feature: Doctor AI Avatar
ID: doctor_ai_avatar
Flag: ENABLE_DOCTOR_AI_AVATAR
Category: Advanced Technology
Default: OFF
Toggleable: Yes (debug/staging only)
```

### How to Test

**Enable the feature:**
```bash
# Debug mode (can toggle in Settings)
flutter run

# Or force enable with flag
flutter run --dart-define=ENABLE_DOCTOR_AI_AVATAR=true
```

**Verify production safety:**
```bash
# Build without flag (feature should be hidden)
flutter build apk --release

# Install and verify Doctor AI is NOT visible
```

### Testing Checklist
- [ ] Feature works correctly when flag is ON
- [ ] Feature is completely hidden when flag is OFF
- [ ] Production build excludes the feature (verify APK)
- [ ] No crashes when feature is disabled
- [ ] Settings screen shows feature toggle (debug only)
- [ ] Staging build can enable with flag

### Build Commands

| Environment | Command | Feature Visible? |
|-------------|---------|------------------|
| **Development** | `flutter run` | Toggle in Settings |
| **Staging** | `flutter build apk --dart-define=ENABLE_DOCTOR_AI_AVATAR=true` | ✅ Yes |
| **Production** | `flutter build apk --release` | ❌ No |

### Merge Safety

- ✅ Safe to merge to `develop` - feature is behind flag
- ❌ Do NOT merge to `main` yet - feature is experimental
- ✅ Production builds will NOT include this feature
- ✅ Tree-shaking removes code in release builds when flag is OFF

### Screenshots
[Add screenshots of feature enabled vs disabled]

### Related Issues
Closes #123

### Labels
`advanced-technology` `feature-flag` `experimental` `do-not-merge-to-main`
```

**Create PR:**
```bash
# Using GitHub CLI
gh pr create \
  --base develop \
  --head v2025.12.01 \
  --title "feat(advanced-tech): Add Doctor AI avatar behind feature flag 🚀" \
  --body-file .github/PR_TEMPLATE_EXPERIMENTAL.md

# Or via GitHub web interface
# https://github.com/yourusername/your-repo/compare/develop...v2025.12.01
```

---

## Scenario 2: Stable Feature (No Feature Flag Needed)

### 🎯 Use Case
You fixed a bug or added a stable feature that should go to production immediately.

### Git Workflow

```bash
git checkout -b fix/login-validation

# Make your changes
git add lib/presentation/mobile/auth/login_screen.dart

git commit -m "fix: Validate email format on login

- Added email regex validation
- Show error message for invalid emails
- Prevent API call with malformed email

Fixes: #456"

git push origin fix/login-validation
```

### PR to `develop` (Stable Fix)

**PR Title:**
```
fix: Validate email format on login
```

**PR Description:**
```markdown
## 🐛 Bug Fix

### Summary
Adds email format validation to prevent invalid login attempts.

### What's Changed
- Added regex validation for email format
- Show error message for invalid emails
- Prevent unnecessary API calls with malformed emails

### Testing
- [ ] Invalid email shows error
- [ ] Valid email allows login
- [ ] Error message is user-friendly

### No Feature Flag Required
This is a stable bug fix ready for production.

Fixes #456
```

**Create PR:**
```bash
gh pr create \
  --base develop \
  --head fix/login-validation \
  --title "fix: Validate email format on login" \
  --body "Bug fix - no feature flag required. Ready for production."
```

---

## Scenario 3: Promoting Experimental Feature to Production

### 🎯 Use Case
Doctor AI Avatar has been tested in staging and is ready for production. You want to enable it by default.

### Option A: Keep Flag but Enable by Default

```bash
git checkout develop
git pull origin develop

git checkout -b feat/enable-doctor-ai-production

# Edit lib/core/feature_flags.dart
# Change: defaultEnabled: false → defaultEnabled: true
```

**Changes to `feature_flags.dart`:**
```dart
static const Feature doctorAIAvatar = Feature(
  id: 'doctor_ai_avatar',
  name: 'Doctor AI Avatar',
  description: 'AI-powered doctor avatar with voice interaction',
  category: ProjectCategory.stable,  // Changed from advancedTechnology
  compileTimeFlag: 'ENABLE_DOCTOR_AI_AVATAR',
  defaultEnabled: true,  // Changed from false
);
```

**Commit:**
```bash
git commit -m "feat: Enable Doctor AI avatar for production

- Changed defaultEnabled: false → true
- Moved from Advanced Technology to Stable category
- Feature has been tested in staging
- Ready for production deployment

Testing:
- Tested with 50+ users in staging
- No critical bugs reported
- Performance metrics within acceptable range
- User feedback: 4.5/5 stars

Refs: #123"

git push origin feat/enable-doctor-ai-production
```

**PR to `main`:**
```markdown
## 🚀 Feature Promotion: Doctor AI Avatar

### Summary
Promotes Doctor AI Avatar from experimental to stable production feature.

### What's Changed
- Changed `defaultEnabled: false → true`
- Moved category from `Advanced Technology` to `Stable`
- Feature is now enabled by default in all builds

### Testing Results
| Metric | Result |
|--------|--------|
| **Staging Users** | 50+ |
| **Bug Reports** | 0 critical, 2 minor (fixed) |
| **Performance** | ✅ Within limits |
| **User Feedback** | 4.5/5 ⭐ |
| **Test Duration** | 2 weeks |

### Rollback Plan
If issues arise in production:
```bash
# Quick rollback: disable flag
flutter build apk --dart-define=FORCE_DISABLE_ALL_EXPERIMENTAL=true

# Or revert commit and redeploy
```

### Ready for Production
- ✅ Thoroughly tested in staging
- ✅ No breaking changes
- ✅ Easy rollback mechanism
- ✅ User documentation complete

Closes #123
```

### Option B: Remove Flag Completely (Feature is Stable)

```bash
git checkout -b refactor/stabilize-doctor-ai

# Remove feature flag checks from code
# Delete if (await FeatureFlags.isDoctorAIEnabled) checks
# Make feature always available
```

**Commit:**
```bash
git commit -m "refactor: Stabilize Doctor AI avatar - remove feature flag

- Removed feature flag checks (feature is stable)
- Always available in all builds
- Moved from experimental to core features
- Updated documentation

BREAKING CHANGE: Doctor AI Avatar is now a core feature.
Cannot be disabled via feature flags.

Refs: #123"
```

---

## Scenario 4: Multiple Features with Mixed Flags

### 🎯 Use Case
You have 3 features:
1. Doctor AI Avatar - experimental (flagged)
2. Dark Mode - beta (flagged)
3. Search Enhancement - stable (no flag)

### Git Workflow

```bash
git checkout -b feat/multi-feature-update

# Make changes...

git commit -m "feat: Add multiple features with appropriate flags

Features:
1. Doctor AI Avatar (Advanced Technology)
   - Behind ENABLE_DOCTOR_AI_AVATAR flag
   - Default: OFF

2. Dark Mode (Experimental)
   - Behind ENABLE_DARK_MODE flag
   - Default: OFF
   - Can toggle in Settings

3. Enhanced Search (Stable)
   - No flag required
   - Always enabled
   - Ready for production

Feature Flags:
- Only experimental features are flagged
- Stable features are always available
- Each flag is independent

Testing matrix:
| Feature | Dev | Staging | Production |
|---------|-----|---------|------------|
| Doctor AI | Toggle | ON | OFF |
| Dark Mode | Toggle | ON | OFF |
| Search | ON | ON | ON |

Refs: #123, #124, #125"
```

**PR Description:**
```markdown
## 🎨 Multi-Feature Update

### Features Added

#### 🚀 Doctor AI Avatar (Experimental)
- **Flag:** `ENABLE_DOCTOR_AI_AVATAR`
- **Default:** OFF
- **Category:** Advanced Technology
- **Status:** Testing in dev/staging only

#### 🌙 Dark Mode (Experimental)
- **Flag:** `ENABLE_DARK_MODE`
- **Default:** OFF
- **Category:** Experimental
- **Status:** Beta testing

#### ✅ Enhanced Search (Stable)
- **No flag required**
- **Always enabled**
- **Status:** Production ready

### Build Matrix

| Build Type | Doctor AI | Dark Mode | Search |
|------------|-----------|-----------|--------|
| **Development** | Toggleable | Toggleable | ✅ ON |
| **Staging** | `--dart-define=ENABLE_DOCTOR_AI_AVATAR=true` | `--dart-define=ENABLE_DARK_MODE=true` | ✅ ON |
| **Production** | ❌ OFF | ❌ OFF | ✅ ON |

### Build Commands

```bash
# Development (all features toggleable)
flutter run

# Staging (enable experimental features)
flutter build apk \
  --dart-define=ENABLE_DOCTOR_AI_AVATAR=true \
  --dart-define=ENABLE_DARK_MODE=true

# Production (only stable features)
flutter build apk --release
```

### Testing Checklist
- [ ] All features work independently
- [ ] Flags don't interfere with each other
- [ ] Production build excludes experimental features
- [ ] Search works regardless of flag states
- [ ] No crashes when flags are OFF

### Safe to Merge?
- ✅ Safe for `develop` - experimental features are flagged
- ⚠️ Only merge to `main` if Search Enhancement is tested
- ✅ Production builds will only include Search

Closes #123, #124, #125
```

---

## Scenario 5: Emergency Hotfix (No Flag, Direct to Main)

### 🎯 Use Case
Critical security bug needs immediate fix in production.

### Git Workflow

```bash
# Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/security-patch-auth

# Fix the issue
git add lib/data/auth/auth_service.dart

git commit -m "fix(security): Patch authentication token vulnerability

SECURITY FIX:
- Fixed token validation bypass
- Added additional JWT verification
- Rate-limited auth attempts

Impact: Critical
Risk: Low (isolated change)
Tested: Yes (unit + integration tests)

CVE: CVE-2024-XXXXX
Refs: #999"

git push origin hotfix/security-patch-auth
```

**PR to `main` (Emergency):**

```markdown
## 🚨 SECURITY HOTFIX

### ⚠️ Critical Security Issue
**DO NOT DISCLOSE DETAILS PUBLICLY UNTIL DEPLOYED**

### Summary
Patches critical authentication vulnerability discovered in production.

### What's Changed
- Fixed token validation logic
- Added additional verification steps
- Rate-limited authentication attempts

### Risk Assessment
- **Severity:** Critical
- **Exploitability:** High
- **Fix Risk:** Low (isolated change)
- **Rollback Plan:** Revert commit if issues

### Testing
- ✅ Unit tests pass
- ✅ Integration tests pass
- ✅ Manual testing complete
- ✅ Staging deployment verified

### Deployment Plan
1. Merge to `main` immediately
2. Deploy to production ASAP
3. Monitor error logs
4. Notify security team

### No Feature Flag
This is a critical security fix - cannot be behind flag.

**MERGE AND DEPLOY IMMEDIATELY**

Fixes #999 (private security issue)
```

**Create PR:**
```bash
gh pr create \
  --base main \
  --head hotfix/security-patch-auth \
  --title "🚨 SECURITY: Patch authentication vulnerability" \
  --label "security,critical,hotfix" \
  --assignee @security-team
```

---

## Decision Tree: When to Use Feature Flags

```
Is this change...
│
├─ Critical security fix?
│  └─ NO FLAG → PR to main → immediate deploy
│
├─ Bug fix (stable)?
│  └─ NO FLAG → PR to develop → normal release
│
├─ New experimental feature?
│  └─ WITH FLAG → PR to develop → toggle in staging
│
├─ Mature experimental feature?
│  └─ ENABLE FLAG → PR to main → production ready
│
└─ Removing mature feature flag?
   └─ NO FLAG → PR to main → feature is now core
```

---

## PR Template Files

### `.github/PULL_REQUEST_TEMPLATE/experimental_feature.md`

```markdown
## 🚀 Experimental Feature

**Feature Name:**
**Category:** [ ] Advanced Technology [ ] Experimental [ ] Beta

### Feature Flag Configuration
- **Flag ID:** `ENABLE_FEATURE_NAME`
- **Default:** OFF
- **Compile-time Flag:** `--dart-define=ENABLE_FEATURE_NAME=true`
- **Can Toggle at Runtime:** [ ] Yes [ ] No

### Summary
[Describe the feature]

### How to Test
```bash
# Enable feature
flutter run --dart-define=ENABLE_FEATURE_NAME=true

# Test production (feature hidden)
flutter build apk --release
```

### Testing Checklist
- [ ] Works when flag is ON
- [ ] Hidden when flag is OFF
- [ ] No crashes when disabled
- [ ] Production build verified

### Merge Safety
- [ ] Safe to merge to `develop`
- [ ] NOT ready for `main` (experimental)
- [ ] Feature flag tested in both states

### Labels
Add: `experimental`, `feature-flag`, `do-not-merge-to-main`
```

### `.github/PULL_REQUEST_TEMPLATE/stable_feature.md`

```markdown
## ✅ Stable Feature

### Summary
[Describe the feature]

### What's Changed
-
-
-

### Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing complete

### No Feature Flag Required
This feature is production-ready and stable.

### Ready for Production
- [ ] Tested thoroughly
- [ ] No breaking changes
- [ ] Documentation updated

Closes #
```

---

## Quick Command Reference

### Create PR to `develop` (with flag)
```bash
git checkout -b feat/my-experimental-feature
# ... make changes ...
git commit -m "feat: Add experimental feature behind flag"
git push origin feat/my-experimental-feature

gh pr create \
  --base develop \
  --head feat/my-experimental-feature \
  --title "feat: Add experimental feature behind flag 🚀" \
  --label "experimental,feature-flag"
```

### Create PR to `main` (stable)
```bash
git checkout -b feat/stable-feature
# ... make changes ...
git commit -m "feat: Add stable feature"
git push origin feat/stable-feature

gh pr create \
  --base main \
  --head feat/stable-feature \
  --title "feat: Add stable feature" \
  --label "stable,production-ready"
```

### Enable flag for production
```bash
git checkout -b feat/enable-feature-production
# Edit feature_flags.dart: defaultEnabled: true
git commit -m "feat: Enable feature for production"
git push origin feat/enable-feature-production

gh pr create \
  --base main \
  --head feat/enable-feature-production \
  --title "feat: Enable feature for production ✅"
```

---

## Summary Table

| Scenario | Branch | Flag? | Merge To | Deploy To Production? |
|----------|--------|-------|----------|-----------------------|
| Experimental feature | `feat/doctor-ai` | ✅ Yes (OFF) | `develop` | ❌ No (flagged OFF) |
| Bug fix | `fix/login` | ❌ No | `develop` → `main` | ✅ Yes |
| Enable experimental | `feat/enable-ai` | ✅ Yes (ON) | `main` | ✅ Yes |
| Hotfix | `hotfix/security` | ❌ No | `main` | ✅ Yes (immediate) |
| Remove flag | `refactor/stabilize` | ❌ No (removed) | `main` | ✅ Yes |

---

**Remember:**
- ✅ Feature flags = merge to develop safely
- ❌ No flag needed for stable features
- 🚀 Enable flag = promote to production
- 🔥 Hotfixes = direct to main, no flag
