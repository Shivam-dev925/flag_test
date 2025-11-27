import 'package:flutter/material.dart';

/// Doctor AI Avatar Feature Screen
///
/// This is an example of an Advanced Technology project.
/// In production, this feature would be behind a compile-time flag.
class DoctorAIScreen extends StatefulWidget {
  const DoctorAIScreen({super.key});

  @override
  State<DoctorAIScreen> createState() => _DoctorAIScreenState();
}

class _DoctorAIScreenState extends State<DoctorAIScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 Doctor AI Avatar'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar visualization
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: _isListening
                          ? [
                              Colors.deepPurple,
                              Colors.purple.withOpacity(0.5),
                            ]
                          : [
                              Colors.grey.shade300,
                              Colors.grey.shade100,
                            ],
                    ),
                    boxShadow: _isListening
                        ? [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.5),
                              blurRadius: 20 + (_controller.value * 20),
                              spreadRadius: 5 + (_controller.value * 10),
                            ),
                          ]
                        : null,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.white,
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Status text
            Text(
              _isListening ? '🎤 Listening...' : '🤖 Ready to assist',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 20),

            // Sample conversation
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Interaction:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isListening
                        ? 'User: "What are my symptoms?"'
                        : 'Tap the button to start voice interaction',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Action button
            ElevatedButton.icon(
              onPressed: _toggleListening,
              icon: Icon(_isListening ? Icons.stop : Icons.mic),
              label: Text(_isListening ? 'Stop Listening' : 'Start Voice Chat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isListening ? Colors.red : Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Warning badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.science, size: 16, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    'Advanced Technology Project',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
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
