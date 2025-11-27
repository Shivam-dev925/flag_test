import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'core/feature_flags.dart';
import 'core/feature_flag_service.dart';
import 'screens/settings_screen.dart';
import 'features/doctor_ai/doctor_ai_screen.dart';
import 'features/experimental/dark_mode_preview.dart';
import 'features/experimental/voice_assistant_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize feature flag service
  await FeatureFlagService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feature Flag Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flag Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              // Reload feature states after returning from settings
              _loadFeatureStates();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadFeatureStates,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 24),

                  // Build mode indicator
                  _buildBuildModeCard(),
                  const SizedBox(height: 24),

                  // Stable Features
                  _buildStableSection(),
                  const SizedBox(height: 24),

                  // Advanced Technology Projects
                  if (_hasAdvancedTechFeatures())
                    _buildAdvancedTechSection(),

                  if (_hasAdvancedTechFeatures())
                    const SizedBox(height: 24),

                  // Experimental Features
                  if (_hasExperimentalFeatures())
                    _buildExperimentalSection(),

                  if (_hasExperimentalFeatures())
                    const SizedBox(height: 24),

                  // Quick stats
                  _buildStatsCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feature Flags Demo',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage experimental features and advanced technology projects',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildBuildModeCard() {
    final mode = kReleaseMode ? 'Release' : (kProfileMode ? 'Profile' : 'Debug');
    final color = kReleaseMode ? Colors.red : (kProfileMode ? Colors.orange : Colors.green);

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Build Mode: $mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kReleaseMode
                        ? 'Experimental features are hidden in release builds'
                        : 'You can toggle features in Settings',
                    style: TextStyle(fontSize: 12, color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStableSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✅ Stable Features',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.home, color: Colors.green),
                title: const Text('Home Dashboard'),
                subtitle: const Text('Main application dashboard'),
                trailing: const Chip(
                  label: Text('Stable'),
                  backgroundColor: Colors.green,
                  labelStyle: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.search, color: Colors.green),
                title: const Text('Enhanced Search'),
                subtitle: const Text('Advanced search with filters'),
                trailing: _featureStates[FeatureFlags.enhancedSearch.id] == true
                    ? const Chip(
                        label: Text('Enabled'),
                        backgroundColor: Colors.blue,
                        labelStyle: TextStyle(color: Colors.white, fontSize: 10),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _hasAdvancedTechFeatures() {
    return FeatureFlags.getFeaturesByCategory(ProjectCategory.advancedTechnology)
        .any((f) => _featureStates[f.id] == true);
  }

  Widget _buildAdvancedTechSection() {
    final features = FeatureFlags.getFeaturesByCategory(ProjectCategory.advancedTechnology)
        .where((f) => _featureStates[f.id] == true)
        .toList();

    if (features.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '🚀 Advanced Technology',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Experimental',
                style: TextStyle(fontSize: 10, color: Colors.purple),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          color: Colors.purple.shade50,
          child: Column(
            children: [
              if (_featureStates[FeatureFlags.doctorAIAvatar.id] == true)
                ListTile(
                  leading: const Icon(Icons.smart_toy, color: Colors.purple),
                  title: const Text('Doctor AI Avatar'),
                  subtitle: const Text('AI-powered medical assistant'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoctorAIScreen(),
                      ),
                    );
                  },
                ),
              if (_featureStates[FeatureFlags.voiceToText.id] == true)
                ListTile(
                  leading: const Icon(Icons.mic, color: Colors.purple),
                  title: const Text('Voice to Text'),
                  subtitle: const Text('Real-time transcription'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Voice to Text feature coming soon!'),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  bool _hasExperimentalFeatures() {
    return FeatureFlags.getFeaturesByCategory(ProjectCategory.experimental)
        .any((f) => _featureStates[f.id] == true);
  }

  Widget _buildExperimentalSection() {
    final features = FeatureFlags.getFeaturesByCategory(ProjectCategory.experimental)
        .where((f) => _featureStates[f.id] == true)
        .toList();

    if (features.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '🧪 Experimental',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Use with caution',
                style: TextStyle(fontSize: 10, color: Colors.orange),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          color: Colors.orange.shade50,
          child: Column(
            children: [
              if (_featureStates[FeatureFlags.voiceAssistant.id] == true)
                ListTile(
                  leading: const Icon(Icons.mic, color: Colors.orange),
                  title: const Text('Voice Assistant'),
                  subtitle: const Text('Hands-free voice interaction'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VoiceAssistantScreen(),
                      ),
                    );
                  },
                ),
              if (_featureStates[FeatureFlags.darkMode.id] == true)
                ListTile(
                  leading: const Icon(Icons.dark_mode, color: Colors.orange),
                  title: const Text('Dark Mode'),
                  subtitle: const Text('System-wide dark theme'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DarkModePreviewScreen(),
                      ),
                    );
                  },
                ),
              if (_featureStates[FeatureFlags.offlineMode.id] == true)
                ListTile(
                  leading: const Icon(Icons.offline_bolt, color: Colors.orange),
                  title: const Text('Offline Mode'),
                  subtitle: const Text('Work without internet'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Offline Mode feature coming soon!'),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    final enabledCount = _featureStates.values.where((v) => v).length;
    final totalCount = FeatureFlags.allFeatures.length;

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Feature Statistics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', totalCount.toString()),
                _buildStatItem('Enabled', enabledCount.toString()),
                _buildStatItem('Disabled', (totalCount - enabledCount).toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
