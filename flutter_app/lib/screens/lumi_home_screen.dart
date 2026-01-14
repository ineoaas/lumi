import 'package:flutter/material.dart';
import '../services/lumi_service.dart';
import '../widgets/color_orb.dart';

class LumiHomeScreen extends StatefulWidget {
  const LumiHomeScreen({Key? key}) : super(key: key);

  @override
  State<LumiHomeScreen> createState() => _LumiHomeScreenState();
}

class _LumiHomeScreenState extends State<LumiHomeScreen> {
  final LumiService _lumiService = LumiService();
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());

  final List<String> _placeholders = [
    'Morning...',
    'A key moment...',
    'Interaction...',
    'A challenge...',
    'Evening thought...',
  ];

  Map<String, dynamic>? _prediction;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _analyzeDay() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      // Collect all text inputs
      final lines = _controllers.map((c) => c.text.trim()).toList();

      // Check if at least one field has content
      if (lines.every((line) => line.isEmpty)) {
        setState(() {
          _errorMessage = 'Please enter at least one description';
          _isLoading = false;
        });
        return;
      }

      // Call the API
      final result = await _lumiService.predictLines(lines);

      setState(() {
        _prediction = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      // Show error in a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Widget _buildInputField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: _controllers[index],
        decoration: InputDecoration(
          hintText: _placeholders[index],
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_prediction == null) return const SizedBox.shrink();

    final emotion = _prediction!['emotion'] as String? ?? 'Neutral';
    final confidence = _prediction!['confidence'] as String? ?? '0%';
    final hue = _prediction!['hue'] as int?;
    final summary = _prediction!['summary'] as String? ?? '';
    final method = _prediction!['method'] as String? ?? '';
    final candidates = _prediction!['candidates'] as List<dynamic>? ?? [];

    final color = _lumiService.hueToColor(hue);
    final lightColor = _lumiService.hueToLightColor(hue);

    return Column(
      children: [
        const SizedBox(height: 32),
        // Color Orb
        ColorOrb(
          color: color,
          size: 150,
        ),
        const SizedBox(height: 24),
        // Emotion Label
        Text(
          emotion,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        // Confidence
        Text(
          'Confidence: $confidence',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        // Method
        Text(
          'Method: $method',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
        // Summary
        if (summary.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: color),
                    const SizedBox(width: 6),
                    Text(
                      'Your Day',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  summary,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
        // Candidate emotions
        if (candidates.length > 1) ...[
          const SizedBox(height: 20),
          Text(
            'Alternative emotions',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: candidates.take(3).map((candidate) {
              final label = candidate['label'] as String? ?? '';
              final score = candidate['score'] as num? ?? 0;
              final candidateHue = candidate['hue'] as int?;
              final candidateColor = _lumiService.hueToColor(candidateHue);

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: candidateColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: candidateColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: candidateColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$label (${(score * 100).toStringAsFixed(1)}%)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Lumi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Describe your day in five short lines.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              // Input fields
              ..._controllers.asMap().entries.map(
                    (entry) => _buildInputField(entry.key),
                  ),
              const SizedBox(height: 20),
              // Error message
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Analyze button
              ElevatedButton(
                onPressed: _isLoading ? null : _analyzeDay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Reveal My Color',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
              // Results section
              _buildResultsSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
