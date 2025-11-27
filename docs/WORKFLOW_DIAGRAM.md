# Feature Flag Workflow - Visual Guide

## Your Doctor AI Avatar Journey

```
┌─────────────────────────────────────────────────────────────────┐
│                    CURRENT STATE                                 │
│  Branch: v2025.12.01                                            │
│  Feature: Doctor AI Avatar ✅ Complete                          │
│  Status: Ready to merge, but worried about production 😰       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   STEP 1: Add Feature Flags                      │
│                                                                  │
│  1. Copy feature flag files to your project                     │
│  2. Add shared_preferences dependency                           │
│  3. Initialize FeatureFlagService in main.dart                  │
│  4. Configure Doctor AI feature flag:                           │
│     - Flag: ENABLE_DOCTOR_AI_AVATAR                            │
│     - Default: OFF ❌                                           │
│     - Category: Advanced Technology 🚀                          │
│  5. Wrap all Doctor AI UI with feature checks                   │
│                                                                  │
│  Commit: "feat(advanced-tech): Add Doctor AI behind flag"      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   STEP 2: Test Both States                       │
│                                                                  │
│  ┌─────────────────────────┐  ┌─────────────────────────┐     │
│  │  Flag OFF (Production)   │  │  Flag ON (Staging)       │     │
│  │  flutter build --release │  │  flutter run --dart-def… │     │
│  │  ❌ Doctor AI NOT visible│  │  ✅ Doctor AI visible    │     │
│  │  ✅ App works normally   │  │  ✅ Feature works        │     │
│  └─────────────────────────┘  └─────────────────────────┘     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                  STEP 3: Push Your Branch                        │
│                                                                  │
│  git push origin v2025.12.01                                    │
│                                                                  │
│  Ready to create PR! ✅                                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
           ┌──────────────────┴──────────────────┐
           │                                      │
           ▼                                      ▼
┌───────────────────────────┐        ┌───────────────────────────┐
│   OPTION A (Recommended)   │        │   OPTION B (Advanced)     │
│   PR to `develop`          │        │   PR to `main`            │
│   (Experimental)           │        │   (Production Ready)      │
└───────────────────────────┘        └───────────────────────────┘
           │                                      │
           ▼                                      ▼
┌───────────────────────────┐        ┌───────────────────────────┐
│  Merge to develop ✅       │        │  Merge to main ✅          │
│                            │        │                           │
│  Production Impact:        │        │  Production Impact:       │
│  🟢 NONE - Flag is OFF     │        │  🔴 HIGH - Feature is ON  │
│                            │        │                           │
│  Doctor AI in Production:  │        │  Doctor AI in Production: │
│  ❌ Hidden (tree-shaken)   │        │  ✅ Visible to all users  │
│                            │        │                           │
│  Doctor AI in Staging:     │        │  Rollback:                │
│  ✅ Available with flag    │        │  Requires revert commit   │
│                            │        │                           │
│  Next Step:                │        │                           │
│  Test in staging →         │        │  └─────────┐              │
│  Then promote to prod      │        │           END             │
└───────────────────────────┘        └───────────────────────────┘
           │
           ▼
┌───────────────────────────────────────────────────────────────┐
│                  After Merge to develop                        │
│                                                                │
│  develop branch now has:                                       │
│  ✅ Doctor AI code (but hidden)                               │
│  ✅ Feature flag system                                        │
│  ✅ Safe to deploy to production (feature OFF)                │
│                                                                │
│  Build Commands:                                               │
│  ┌────────────────────────────────────────────────┐          │
│  │  Development:                                   │          │
│  │  flutter run                                    │          │
│  │  (Toggle in Settings)                           │          │
│  │                                                 │          │
│  │  Staging (enable feature):                      │          │
│  │  flutter build apk \                            │          │
│  │    --dart-define=ENABLE_DOCTOR_AI_AVATAR=true  │          │
│  │                                                 │          │
│  │  Production (feature hidden):                   │          │
│  │  flutter build apk --release                    │          │
│  └────────────────────────────────────────────────┘          │
└───────────────────────────────────────────────────────────────┘
           │
           ▼
┌───────────────────────────────────────────────────────────────┐
│                  Staging Testing Phase                         │
│                                                                │
│  1. Deploy staging build with flag ON                         │
│  2. Test with beta users (2+ weeks)                           │
│  3. Gather feedback                                            │
│  4. Fix any bugs                                               │
│  5. Monitor performance                                        │
│                                                                │
│  Metrics to track:                                             │
│  - User engagement                                             │
│  - Bug reports                                                 │
│  - Performance (CPU/RAM)                                       │
│  - Socket stability                                            │
│  - User satisfaction scores                                    │
└───────────────────────────────────────────────────────────────┘
           │
           ▼
      ┌─────────┐
      │ Ready?  │
      └────┬────┘
           │
    ┌──────┴──────┐
    │             │
   NO            YES
    │             │
    ▼             ▼
  Keep      ┌──────────────────────────────────┐
  testing   │  STEP 4: Promote to Production   │
            │                                  │
            │  Create new branch:              │
            │  feat/enable-doctor-ai-prod      │
            │                                  │
            │  Change in feature_flags.dart:   │
            │  - defaultEnabled: false → true  │
            │  - category: Advanced → Stable   │
            │                                  │
            │  Create PR to main               │
            └──────────────────────────────────┘
                        │
                        ▼
            ┌──────────────────────────────────┐
            │  PR Review Checklist             │
            │                                  │
            │  ✅ 2+ weeks staging testing     │
            │  ✅ No critical bugs             │
            │  ✅ Performance acceptable       │
            │  ✅ User feedback positive       │
            │  ✅ Team approval                │
            │  ✅ Rollback plan documented     │
            └──────────────────────────────────┘
                        │
                        ▼
            ┌──────────────────────────────────┐
            │  Merge to main ✅                 │
            │                                  │
            │  🎉 Doctor AI is now LIVE!       │
            │                                  │
            │  Production users can now:       │
            │  - Access Doctor AI Avatar       │
            │  - Use voice interaction         │
            │  - See socket reconnections      │
            │                                  │
            │  Monitor:                        │
            │  - Error rates                   │
            │  - Performance metrics           │
            │  - User feedback                 │
            └──────────────────────────────────┘
                        │
                        ▼
                    ┌───────┐
                    │  END  │
                    └───────┘
```

---

## Comparison Matrix

| Aspect | PR to `develop` (With Flag OFF) | PR to `main` (With Flag ON) |
|--------|--------------------------------|---------------------------|
| **Production Impact** | 🟢 None - feature hidden | 🔴 High - feature visible |
| **Risk Level** | 🟢 Low | 🟠 Medium-High |
| **Testing Phase** | Staging only | Live users |
| **Rollback** | Not needed (already OFF) | Requires revert/redeploy |
| **Iteration Speed** | 🟢 Fast (toggle flag) | 🔴 Slow (requires deploy) |
| **Team Confidence** | Build confidence first | Requires high confidence |
| **Best For** | Experimental features | Tested stable features |
| **Your Situation** | ✅ **RECOMMENDED** | Use after staging tests |

---

## Timeline Example

```
Week 1-2: Development
├─ Build Doctor AI Avatar
├─ Add feature flags
├─ Test locally
└─ Push branch ✅

Week 3: PR to develop
├─ Create PR (flag OFF)
├─ Code review
├─ Merge to develop ✅
└─ Deploy to staging (flag ON)

Week 4-5: Staging Testing
├─ Beta user testing
├─ Monitor metrics
├─ Fix bugs
└─ Gather feedback ✅

Week 6: Production Release
├─ Create PR to main (enable flag)
├─ Final review
├─ Merge to main ✅
└─ Deploy to production 🎉

Week 7+: Monitor & Iterate
├─ Monitor user feedback
├─ Track performance
├─ Fix issues
└─ Plan next features
```

---

## Build Commands Cheat Sheet

```bash
# 1️⃣ Development (Debug) - Toggle in app
flutter run
# → Doctor AI: Can toggle in Settings
# → Use this for: Daily development

# 2️⃣ Staging - Force enable
flutter run --dart-define=ENABLE_DOCTOR_AI_AVATAR=true
flutter build apk --dart-define=ENABLE_DOCTOR_AI_AVATAR=true
# → Doctor AI: Always visible
# → Use this for: Beta testing, staging environment

# 3️⃣ Production - Default (flag OFF)
flutter build apk --release
# → Doctor AI: Hidden (tree-shaken out of APK)
# → Use this for: Production builds before feature is ready

# 4️⃣ Production - Enable specific features
flutter build apk --release --dart-define=ENABLE_DOCTOR_AI_AVATAR=true
# → Doctor AI: Visible in production
# → Use this for: After staging testing is complete

# 5️⃣ Emergency - Force disable ALL experimental
flutter build apk --release --dart-define=FORCE_DISABLE_ALL_EXPERIMENTAL=true
# → Doctor AI: Guaranteed hidden
# → Use this for: Emergency rollback
```

---

## Decision Tree

```
                    Start: Doctor AI is ready
                              │
                              ▼
                    Has it been tested in staging?
                              │
                    ┌─────────┴─────────┐
                    │                   │
                   NO                  YES
                    │                   │
                    ▼                   ▼
        PR to develop (flag OFF)    Has it been tested for 2+ weeks?
        ✅ SAFE                             │
        Production unaffected       ┌───────┴────────┐
                │                   │                │
                ▼                  NO               YES
        Test in staging             │                │
        (flag ON)                   ▼                ▼
                │              Keep testing    Any critical bugs?
                ▼                                    │
        Satisfied with tests?              ┌────────┴────────┐
                │                          │                 │
        ┌───────┴────────┐                NO                YES
        │                │                 │                 │
       NO               YES                ▼                 ▼
        │                │          Team approved?      Fix bugs first
        ▼                ▼                 │             Go back to
   Fix issues    PR to main (enable)      │             staging
   Try again            │          ┌──────┴──────┐
                        ▼          │             │
                Deploy to prod    NO            YES
                🎉 Success!        │             │
                                   ▼             ▼
                            Not ready yet   PR to main
                            Keep testing    Enable flag
                                            Deploy! 🎉
```

---

## Your Recommended Path

```
┌────────────────────────────────────────────────────────────┐
│  📍 YOU ARE HERE                                           │
│  Branch: v2025.12.01                                       │
│  Status: Doctor AI complete, needs to merge                │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│  🔧 STEP 1: Add Feature Flags (30 minutes)                 │
│  - Copy files from demo                                    │
│  - Configure Doctor AI flag                                │
│  - Wrap UI code                                            │
│  - Test both states                                        │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│  📝 STEP 2: Create PR to develop (15 minutes)              │
│  - Use template from YOUR_DOCTOR_AI_PR_EXAMPLE.md         │
│  - Title: "feat(advanced-tech): Add Doctor AI behind flag"│
│  - Label: advanced-technology, feature-flag, safe-to-merge│
│  - Explain: Feature OFF by default, production safe        │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│  ✅ MERGE to develop                                       │
│  - Code review approved                                    │
│  - Tests pass                                              │
│  - Merge! ✅                                               │
│                                                            │
│  🎉 SUCCESS: Production is SAFE                           │
│  - Feature is in develop                                   │
│  - Production builds won't show it                         │
│  - Staging can enable it                                   │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│  🧪 STEP 3: Test in Staging (2 weeks)                      │
│  - Build: flutter build apk --dart-define=...              │
│  - Deploy to staging environment                           │
│  - Beta test with users                                    │
│  - Monitor metrics                                         │
│  - Fix any bugs                                            │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│  🚀 STEP 4: Enable for Production (when ready)             │
│  - Create PR to main: "feat: Enable Doctor AI"            │
│  - Change defaultEnabled: true                             │
│  - Team approval                                           │
│  - Merge to main                                           │
│  - Deploy to production 🎉                                 │
└────────────────────────────────────────────────────────────┘
```

---

## Key Takeaways

1. **✅ PR to `develop` first** - Safest approach, no production impact
2. **🧪 Test in staging** - Build with flag ON, test with beta users
3. **🚀 PR to `main` later** - Only after thorough staging testing
4. **🔒 Production is safe** - Feature is OFF by default, tree-shaken in release
5. **⚡ Easy rollback** - Just revert commit or build with FORCE_DISABLE

---

## Questions?

**Q: Will merging to develop affect production?**
A: **NO!** Feature is OFF by default and tree-shaken in release builds.

**Q: How do I test in staging?**
A: Build with `--dart-define=ENABLE_DOCTOR_AI_AVATAR=true`

**Q: When should I create PR to main?**
A: After 2+ weeks of staging testing with no critical bugs.

**Q: What if something breaks in production?**
A: Revert the enable commit or build with `FORCE_DISABLE_ALL_EXPERIMENTAL=true`

**Q: Can I have multiple experimental features?**
A: Yes! Each feature gets its own flag and can be toggled independently.

---

**🎯 Bottom Line:**
Create PR to `develop` → Test in staging → Then enable for production.
Your Doctor AI code is safe to merge right now! 🚀
