import 'package:flutter/material.dart';

/// Voice Assistant Screen
///
/// This is an experimental feature demonstrating hands-free voice interaction.
/// Feature is behind ENABLE_VOICE_ASSISTANT flag.
class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isListening = false;
  String _status = 'Say "Hey Assistant" to begin';
  final List<String> _conversation = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      if (_isListening) {
        _status = 'Listening...';
        _simulateResponse();
      } else {
        _status = 'Say "Hey Assistant" to begin';
      }
    });
  }

  void _simulateResponse() {
    Future.delayed(const Duration(seconds: 2), () {
      if (_isListening && mounted) {
        setState(() {
          _conversation.add('User: How can you help me?');
          _conversation.add(
              'Assistant: I can assist with voice commands, answer questions, and help navigate the app hands-free.');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎙️ Voice Assistant'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Status card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isListening
                    ? [Colors.blue.shade600, Colors.blue.shade800]
                    : [Colors.grey.shade300, Colors.grey.shade400],
              ),
            ),
            child: Column(
              children: [
                // Animated microphone indicator
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: 80 + (_isListening ? _controller.value * 20 : 0),
                      height: 80 + (_isListening ? _controller.value * 20 : 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: const Icon(
                        Icons.mic,
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  _status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Conversation history
          Expanded(
            child: _conversation.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.voice_chat,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No conversation yet',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the microphone button to start',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _conversation.length,
                    itemBuilder: (context, index) {
                      final message = _conversation[index];
                      final isUser = message.startsWith('User:');
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message,
                            style: TextStyle(
                              color: isUser ? Colors.blue.shade900 : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Control buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Clear conversation
                IconButton(
                  onPressed: _conversation.isNotEmpty
                      ? () {
                          setState(() {
                            _conversation.clear();
                          });
                        }
                      : null,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Clear conversation',
                ),

                // Main mic button
                FloatingActionButton.large(
                  onPressed: _toggleListening,
                  backgroundColor: _isListening ? Colors.red : Colors.blue,
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    size: 36,
                  ),
                ),

                // Settings
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Voice settings coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings_voice),
                  tooltip: 'Voice settings',
                ),
              ],
            ),
          ),

          // Experimental badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.orange.shade100,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.science, size: 16, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  '🧪 Experimental Feature - Use with caution',
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
    );
  }
}
