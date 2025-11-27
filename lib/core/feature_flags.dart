import 'package:flutter/foundation.dart';
import 'feature_flag_service.dart';

/// Feature categories for organizing experimental features
enum ProjectCategory {
  stable('Stable', '✅'),
  advancedTechnology('Advanced Technology', '🚀'),
  experimental('Experimental', '🧪'),
  beta('Beta', '🔵');

  const ProjectCategory(this.displayName, this.emoji);
  final String displayName;
  final String emoji;
}

/// Individual feature definition
class Feature {
  final String id;
  final String name;
  final String description;
  final ProjectCategory category;
  final bool defaultEnabled;

  /// Compile-time flag name (use with --dart-define)
  final String? compileTimeFlag;

  /// Whether this feature can be toggled at runtime
  final bool canToggleAtRuntime;

  const Feature({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.defaultEnabled = false,
    this.compileTimeFlag,
    this.canToggleAtRuntime = true,
  });

  /// Check if feature is enabled (considers both compile-time and runtime flags)
  Future<bool> isEnabled() async {
    // In release mode, only enable if compile-time flag is set
    if (kReleaseMode && compileTimeFlag != null) {
      return const bool.fromEnvironment('FORCE_DISABLE_ALL_EXPERIMENTAL', defaultValue: false)
          ? false
          : bool.fromEnvironment(compileTimeFlag!, defaultValue: defaultEnabled);
    }

    // In debug/profile mode, check runtime toggle
    if (canToggleAtRuntime) {
      return await FeatureFlagService.instance.isFeatureEnabled(id) ?? defaultEnabled;
    }

    return defaultEnabled;
  }
}

/// Central feature flag registry
class FeatureFlags {
  FeatureFlags._();

  // ========================================================================
  // ADVANCED TECHNOLOGY PROJECTS
  // ========================================================================

  static const Feature doctorAIAvatar = Feature(
    id: 'doctor_ai_avatar',
    name: 'Doctor AI Avatar',
    description: 'AI-powered doctor avatar with voice interaction and real-time responses',
    category: ProjectCategory.advancedTechnology,
    compileTimeFlag: 'ENABLE_DOCTOR_AI_AVATAR',
    defaultEnabled: false,
  );

  static const Feature voiceToText = Feature(
    id: 'voice_to_text',
    name: 'Voice to Text',
    description: 'Real-time voice transcription using Whisper.cpp',
    category: ProjectCategory.advancedTechnology,
    compileTimeFlag: 'ENABLE_VOICE_TO_TEXT',
    defaultEnabled: false,
  );

  static const Feature voiceAssistant = Feature(
    id: 'voice_assistant',
    name: 'Voice Assistant',
    description: 'AI-powered voice assistant for hands-free interaction',
    category: ProjectCategory.experimental,
    compileTimeFlag: 'ENABLE_VOICE_ASSISTANT',
    defaultEnabled: false,
  );

  // ========================================================================
  // EXPERIMENTAL FEATURES
  // ========================================================================

  static const Feature darkMode = Feature(
    id: 'dark_mode',
    name: 'Dark Mode',
    description: 'System-wide dark theme support',
    category: ProjectCategory.experimental,
    compileTimeFlag: 'ENABLE_DARK_MODE',
    defaultEnabled: false,
    canToggleAtRuntime: true,
  );

  static const Feature offlineMode = Feature(
    id: 'offline_mode',
    name: 'Offline Mode',
    description: 'Full offline support with local data sync',
    category: ProjectCategory.experimental,
    defaultEnabled: false,
  );

  // ========================================================================
  // BETA FEATURES
  // ========================================================================

  static const Feature enhancedSearch = Feature(
    id: 'enhanced_search',
    name: 'Enhanced Search',
    description: 'Fuzzy search with advanced filtering',
    category: ProjectCategory.beta,
    defaultEnabled: true, // Safe to enable by default
  );

  // ========================================================================
  // FEATURE REGISTRY
  // ========================================================================

  /// All registered features
  static const List<Feature> allFeatures = [
    // Advanced Technology
    doctorAIAvatar,
    voiceToText,

    // Experimental
    voiceAssistant,
    darkMode,
    offlineMode,

    // Beta
    enhancedSearch,
  ];

  /// Get features by category
  static List<Feature> getFeaturesByCategory(ProjectCategory category) {
    return allFeatures.where((f) => f.category == category).toList();
  }

  /// Check if any advanced tech features are enabled
  static Future<bool> hasAdvancedTechEnabled() async {
    for (var feature in getFeaturesByCategory(ProjectCategory.advancedTechnology)) {
      if (await feature.isEnabled()) return true;
    }
    return false;
  }

  /// Check if any experimental features are enabled
  static Future<bool> hasExperimentalEnabled() async {
    for (var feature in getFeaturesByCategory(ProjectCategory.experimental)) {
      if (await feature.isEnabled()) return true;
    }
    return false;
  }

  // ========================================================================
  // CONVENIENCE METHODS (for quick access in code)
  // ========================================================================

  static Future<bool> get isDoctorAIEnabled => doctorAIAvatar.isEnabled();
  static Future<bool> get isVoiceToTextEnabled => voiceToText.isEnabled();
  static Future<bool> get isVoiceAssistantEnabled => voiceAssistant.isEnabled();
  static Future<bool> get isDarkModeEnabled => darkMode.isEnabled();
  static Future<bool> get isOfflineModeEnabled => offlineMode.isEnabled();
  static Future<bool> get isEnhancedSearchEnabled => enhancedSearch.isEnabled();
}
