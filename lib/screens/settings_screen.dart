import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/feature_flags.dart';
import '../core/feature_flag_service.dart';

/// Settings screen for managing feature flags
///
/// This screen allows users to:
/// - View all available features organized by category
/// - Toggle features on/off (in debug mode)
/// - See which features are enabled via compile-time flags
/// - Reset all features to defaults
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, bool> _featureStates = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFeatureStates();
  }

  Future<void> _loadFeatureStates() async {
    setState(() => _loading = true);

    for (var feature in FeatureFlags.allFeatures) {
      _featureStates[feature.id] = await feature.isEnabled();
    }

    setState(() => _loading = false);
  }

  Future<void> _toggleFeature(Feature feature) async {
    if (!feature.canToggleAtRuntime) {
      _showCompileTimeFlagDialog(feature);
      return;
    }

    final newState = await FeatureFlagService.instance.toggleFeature(feature.id);
    setState(() {
      _featureStates[feature.id] = newState;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${feature.name} ${newState ? 'enabled' : 'disabled'}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCompileTimeFlagDialog(Feature feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compile-Time Flag Required'),
        content: Text(
          'This feature requires a compile-time flag to enable.\n\n'
          'Run with:\nflutter run --dart-define=${feature.compileTimeFlag}=true',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetAllFlags() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Flags?'),
        content: const Text('This will reset all feature flags to their defaults.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FeatureFlagService.instance.resetAll();
      await _loadFeatureStates();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All flags reset to defaults')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flags'),
        actions: [
          if (!kReleaseMode)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetAllFlags,
              tooltip: 'Reset all flags',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Build mode indicator
                _buildBuildModeCard(),

                const SizedBox(height: 16),

                // Features by category
                for (var category in ProjectCategory.values)
                  _buildCategorySection(category),
              ],
            ),
    );
  }

  Widget _buildBuildModeCard() {
    final mode = kReleaseMode ? 'Release' : (kProfileMode ? 'Profile' : 'Debug');
    final color = kReleaseMode ? Colors.red : (kProfileMode ? Colors.orange : Colors.green);

    return Card(
      margin: const EdgeInsets.all(16),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: color),
                const SizedBox(width: 8),
                Text(
                  'Build Mode: $mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              kReleaseMode
                  ? 'Experimental features are disabled in release builds. Use compile-time flags to enable.'
                  : 'You can toggle experimental features at runtime in $mode mode.',
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(ProjectCategory category) {
    final features = FeatureFlags.getFeaturesByCategory(category);
    if (features.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '${category.emoji} ${category.displayName}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...features.map((feature) => _buildFeatureTile(feature)),
        const Divider(),
      ],
    );
  }

  Widget _buildFeatureTile(Feature feature) {
    final isEnabled = _featureStates[feature.id] ?? false;
    final canToggle = !kReleaseMode && feature.canToggleAtRuntime;

    return ListTile(
      title: Text(feature.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(feature.description),
          if (feature.compileTimeFlag != null) ...[
            const SizedBox(height: 4),
            Text(
              'Flag: ${feature.compileTimeFlag}',
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            ),
          ],
        ],
      ),
      trailing: Switch(
        value: isEnabled,
        onChanged: canToggle ? (_) => _toggleFeature(feature) : null,
      ),
      onTap: canToggle ? () => _toggleFeature(feature) : null,
    );
  }
}
