# Example Pull Requests - Live Demonstrations

This document showcases three real PRs demonstrating different feature flag strategies.

## 📋 Overview

| PR | Type | Target Branch | Feature Flag? | Status |
|----|------|---------------|---------------|--------|
| [#1](https://github.com/Shivam-dev925/flag_test/pull/1) | Experimental Feature | `develop` | ✅ Yes (OFF) | Open |
| [#2](https://github.com/Shivam-dev925/flag_test/pull/2) | Stable Feature | `develop` | ❌ No | Open |
| [#3](https://github.com/Shivam-dev925/flag_test/pull/3) | Enable for Production | `main` | ✅ Yes (ON) | Open |

---

## PR #1: Experimental Feature WITH Flag (to develop) 🧪

### 🔗 [View PR #1](https://github.com/Shivam-dev925/flag_test/pull/1)

**Branch:** `feat/voice-assistant-experimental` → `develop`

### What It Demonstrates
- ✅ How to add an experimental feature safely
- ✅ Feature flag configuration (OFF by default)
- ✅ No production impact
- ✅ Can be enabled in staging/dev

### Key Points

#### Feature Flag Configuration
```dart
static const Feature voiceAssistant = Feature(
  id: 'voice_assistant',
  name: 'Voice Assistant',
  description: 'AI-powered voice assistant for hands-free interaction',
  category: ProjectCategory.experimental,
  compileTimeFlag: 'ENABLE_VOICE_ASSISTANT',
  defaultEnabled: false,  // OFF for production! ✅
);
```

#### Files Changed
- `lib/core/feature_flags.dart` - Added voice assistant flag
- `lib/features/experimental/voice_assistant_screen.dart` - New feature screen
- `lib/main.dart` - Integrated with feature flag check

#### Testing
```bash
# Feature OFF (production simulation)
flutter build apk --release
# Voice Assistant is NOT visible ✅

# Feature ON (staging)
flutter run --dart-define=ENABLE_VOICE_ASSISTANT=true
# Voice Assistant appears in Experimental section ✅
```

#### Why It's Safe to Merge
1. **Feature is OFF by default** - Production builds won't include it
2. **Tree-shaking** - Code is removed from release builds
3. **No breaking changes** - Doesn't affect existing features
4. **Independently toggleable** - Can enable in staging only

### PR Description Highlights
```markdown
## 🧪 Experimental Feature: Voice Assistant

### ⚠️ Important: Feature Flag Strategy
This PR is **SAFE TO MERGE** to develop because:
- ✅ Feature is behind `ENABLE_VOICE_ASSISTANT` flag
- ✅ Default is **OFF** in production
- ✅ Flutter tree-shaking removes code in release builds
```

### Use This PR as Template When:
- Adding experimental features
- Building advanced technology projects
- Testing new features in staging only
- Keeping code in main repo without affecting production

---

## PR #2: Stable Feature WITHOUT Flag (to develop) ✅

### 🔗 [View PR #2](https://github.com/Shivam-dev925/flag_test/pull/2)

**Branch:** `feat/improve-search-filters` → `develop`

### What It Demonstrates
- ✅ Stable utility improvements don't need flags
- ✅ Production-ready code can go directly to develop
- ✅ Comprehensive testing approach
- ✅ No feature flag overhead for stable features

### Key Points

#### No Feature Flag Required
```dart
// This utility is ALWAYS available - no flag needed
class SearchUtils {
  static bool fuzzyMatch(String source, String query) {
    // Stable, tested, production-ready code
  }
}
```

#### Files Changed
- `lib/utils/search_utils.dart` - New search utilities
- `test/utils/search_utils_test.dart` - 15+ unit tests

#### Testing
```bash
# Run all tests
flutter test test/utils/search_utils_test.dart

# All 15 tests pass ✅
```

#### Why No Flag Needed
1. **Utility functions** - Not user-facing features
2. **Fully tested** - 100% code coverage
3. **No breaking changes** - Purely additive
4. **Production ready** - No experimental behavior

### PR Description Highlights
```markdown
## ✅ Stable Feature: Search Filter Improvements

### No Feature Flag Needed
This is a **stable utility improvement** that:
- Doesn't change existing UI
- Doesn't modify user-facing behavior
- Is fully tested and production-ready
```

### Use This PR as Template When:
- Adding utility functions
- Fixing bugs
- Improving performance
- Enhancing existing features (non-breaking)
- Making infrastructure improvements

---

## PR #3: Enable Experimental for Production (to main) 🌙✅

### 🔗 [View PR #3](https://github.com/Shivam-dev925/flag_test/pull/3)

**Branch:** `feat/enable-dark-mode-production` → `main`

### What It Demonstrates
- ✅ How to promote experimental feature to production
- ✅ Feature flag change (OFF → ON)
- ✅ Category change (Experimental → Stable)
- ✅ Production deployment strategy

### Key Points

#### Feature Flag Promotion
```dart
// Before (Experimental)
static const Feature darkMode = Feature(
  category: ProjectCategory.experimental,
  defaultEnabled: false,  // OFF ❌
);

// After (Stable)
static const Feature darkMode = Feature(
  category: ProjectCategory.stable,
  defaultEnabled: true,  // ON ✅
);
```

#### Files Changed
- `lib/core/feature_flags.dart` - Promoted dark mode to stable

#### Testing Evidence
| Metric | Result |
|--------|--------|
| Staging Duration | 3+ weeks |
| Beta Users | 150+ |
| Critical Bugs | 0 |
| User Rating | 4.7/5 ⭐ |

#### Why It's Ready for Production
1. **Thoroughly tested** - 3+ weeks in staging
2. **No critical bugs** - 0 issues found
3. **Positive feedback** - 4.7/5 rating
4. **Performance verified** - <1% CPU overhead

### PR Description Highlights
```markdown
## 🌙 Feature Promotion: Dark Mode to Production

### Testing Results
- **Staging Duration**: 3+ weeks
- **Beta Users**: 150+
- **Critical Bugs**: 0
- **User Rating**: 4.7/5 ⭐

### Rollback Plan
1. Revert commit
2. Or disable with flag
3. Or users can toggle OFF
```

### Use This PR as Template When:
- Promoting experimental features to production
- Enabling features after staging testing
- Moving from beta to stable
- Making features default-ON

---

## Comparison Matrix

| Aspect | PR #1 (Experimental) | PR #2 (Stable) | PR #3 (Enable) |
|--------|---------------------|----------------|----------------|
| **Target Branch** | `develop` | `develop` | `main` |
| **Feature Flag** | ✅ Yes (OFF) | ❌ No | ✅ Yes (ON) |
| **Production Impact** | 🟢 None | 🟢 Low | 🔴 High |
| **Risk Level** | 🟢 Low | 🟢 Low | 🟠 Medium |
| **Testing Phase** | Dev/Staging | Dev/Staging | Production |
| **Rollback** | Not needed | Revert commit | Revert or disable |
| **User Visibility** | Hidden | N/A | Visible to all |
| **Best For** | New features | Utilities/Fixes | Mature features |

---

## How to Use These PRs

### 1. Review the PRs
Visit each PR link and examine:
- Commit messages
- File changes
- PR descriptions
- Testing evidence

### 2. Compare Approaches
Notice the differences:
- PR #1: Feature flag OFF, safe to merge
- PR #2: No flag, utility improvement
- PR #3: Feature flag ON, production deployment

### 3. Copy Templates
Use these PRs as templates for your own:
- Copy PR description format
- Follow commit message structure
- Adopt testing checklist
- Use similar explanations

### 4. Adapt to Your Project
Modify for your use case:
- Replace feature names
- Update testing evidence
- Adjust build commands
- Customize for your workflow

---

## Quick Command Reference

### PR #1 Commands (Experimental)
```bash
# Test with flag OFF (production)
flutter build apk --release

# Test with flag ON (staging)
flutter run --dart-define=ENABLE_VOICE_ASSISTANT=true

# Merge to develop (safe)
gh pr merge 1
```

### PR #2 Commands (Stable)
```bash
# Run tests
flutter test test/utils/search_utils_test.dart

# Merge to develop (safe)
gh pr merge 2
```

### PR #3 Commands (Enable)
```bash
# Deploy to production
flutter build apk --release

# Monitor metrics
# (Check user engagement, crash rates, feedback)

# Rollback if needed
git revert 7a8afbc
git push origin main
```

---

## Real-World Workflow

```
Week 1-2: Development
├─ Build experimental feature (PR #1 approach)
├─ Add feature flag (OFF by default)
├─ Create PR to develop
└─ Merge (production unaffected) ✅

Week 3-4: Staging Testing
├─ Deploy to staging (flag ON)
├─ Test with beta users
├─ Fix bugs
└─ Gather feedback

Week 5: Stable Features
├─ Add utilities/fixes (PR #2 approach)
├─ No flag needed
├─ Create PR to develop
└─ Merge (production gets improvements) ✅

Week 6: Production Promotion
├─ Experimental feature is mature
├─ Create PR to main (PR #3 approach)
├─ Enable flag (OFF → ON)
└─ Deploy to production 🎉
```

---

## Key Takeaways

### ✅ DO
- Use flags for experimental features (PR #1)
- Skip flags for stable utilities (PR #2)
- Promote gradually (PR #3)
- Test thoroughly before enabling
- Document rollback plans

### ❌ DON'T
- Merge experimental features without flags to main
- Add flags to every change (overkill for utilities)
- Enable features in production without staging tests
- Skip testing in production simulation (flag OFF)
- Forget to update category when promoting

---

## Additional Resources

- [Full PR Examples](./PR_EXAMPLES.md) - Detailed scenarios
- [Your Doctor AI Workflow](./YOUR_DOCTOR_AI_PR_EXAMPLE.md) - Specific to your project
- [Workflow Diagram](./WORKFLOW_DIAGRAM.md) - Visual guide
- [Integration Guide](../APPLY_TO_RAXA.md) - Apply to Raxa project

---

## Questions?

**Q: Which PR approach should I use for my feature?**
A: Use the decision tree in [WORKFLOW_DIAGRAM.md](./WORKFLOW_DIAGRAM.md)

**Q: Can I see the actual code changes?**
A: Click any PR link above and go to "Files changed" tab

**Q: How do I adapt these for my project?**
A: Follow [YOUR_DOCTOR_AI_PR_EXAMPLE.md](./YOUR_DOCTOR_AI_PR_EXAMPLE.md)

**Q: What if I need to combine approaches?**
A: See [PR_EXAMPLES.md Scenario 4](./PR_EXAMPLES.md#scenario-4-multiple-features-with-mixed-flags)

---

**🎯 Bottom Line:**
- **PR #1** = Experimental feature, safe to merge to develop (flag OFF)
- **PR #2** = Stable improvement, no flag needed
- **PR #3** = Production deployment (flag ON)

View all PRs: https://github.com/Shivam-dev925/flag_test/pulls
