import 'package:flutter/material.dart';

/// Dark Mode Preview Screen
///
/// This is an example of an Experimental feature.
/// Shows how dark theme would look in the app.
class DarkModePreviewScreen extends StatefulWidget {
  const DarkModePreviewScreen({super.key});

  @override
  State<DarkModePreviewScreen> createState() => _DarkModePreviewScreenState();
}

class _DarkModePreviewScreenState extends State<DarkModePreviewScreen> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🌙 Dark Mode Preview'),
          actions: [
            Switch(
              value: _isDark,
              onChanged: (value) => setState(() => _isDark = value),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This experimental feature provides a system-wide dark theme '
                      'that reduces eye strain in low-light conditions.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.brightness_4, size: 48, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      'Preview Mode',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Toggle the switch to see how the app looks in dark mode',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Color Scheme'),
              subtitle: Text(_isDark ? 'Dark theme active' : 'Light theme active'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('Auto Switch'),
              subtitle: const Text('Follow system theme'),
              trailing: Switch(value: false, onChanged: null),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Scheduled Mode'),
              subtitle: const Text('Auto-enable at sunset'),
              trailing: Switch(value: false, onChanged: null),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '🧪 Experimental: Some screens may not fully support dark mode yet',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
