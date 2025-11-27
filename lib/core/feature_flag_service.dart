import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing runtime feature flags
///
/// This service handles persistent storage of feature flag states using SharedPreferences.
/// It allows users to toggle features at runtime in debug/profile builds.
class FeatureFlagService {
  static FeatureFlagService? _instance;
  static FeatureFlagService get instance {
    _instance ??= FeatureFlagService._();
    return _instance!;
  }

  FeatureFlagService._();

  SharedPreferences? _prefs;

  /// Initialize the service (call this at app startup)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Storage key prefix for feature flags
  static const String _keyPrefix = 'feature_flag_';

  /// Get feature flag state
  Future<bool?> isFeatureEnabled(String featureId) async {
    if (_prefs == null) await init();
    return _prefs?.getBool('$_keyPrefix$featureId');
  }

  /// Set feature flag state
  Future<void> setFeatureEnabled(String featureId, bool enabled) async {
    if (_prefs == null) await init();
    await _prefs?.setBool('$_keyPrefix$featureId', enabled);
  }

  /// Toggle feature flag
  Future<bool> toggleFeature(String featureId) async {
    final currentState = await isFeatureEnabled(featureId) ?? false;
    final newState = !currentState;
    await setFeatureEnabled(featureId, newState);
    return newState;
  }

  /// Reset all feature flags to default
  Future<void> resetAll() async {
    if (_prefs == null) await init();
    final keys = _prefs?.getKeys() ?? {};
    for (var key in keys) {
      if (key.startsWith(_keyPrefix)) {
        await _prefs?.remove(key);
      }
    }
  }

  /// Get all enabled features
  Future<List<String>> getEnabledFeatures() async {
    if (_prefs == null) await init();
    final keys = _prefs?.getKeys() ?? {};
    final enabledFeatures = <String>[];

    for (var key in keys) {
      if (key.startsWith(_keyPrefix)) {
        final enabled = _prefs?.getBool(key) ?? false;
        if (enabled) {
          enabledFeatures.add(key.replaceFirst(_keyPrefix, ''));
        }
      }
    }

    return enabledFeatures;
  }

  /// Export feature flag states for debugging
  Future<Map<String, bool>> exportFlags() async {
    if (_prefs == null) await init();
    final keys = _prefs?.getKeys() ?? {};
    final flags = <String, bool>{};

    for (var key in keys) {
      if (key.startsWith(_keyPrefix)) {
        flags[key.replaceFirst(_keyPrefix, '')] = _prefs?.getBool(key) ?? false;
      }
    }

    return flags;
  }
}
