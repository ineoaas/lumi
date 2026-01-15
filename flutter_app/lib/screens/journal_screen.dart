import 'package:flutter/material.dart';
import '../services/lumi_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'color_result_screen.dart';
import 'chart_of_day_screen.dart';
import 'calendar_screen.dart';
import 'reflection_complete_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final LumiService _lumiService = LumiService();
  final DatabaseService _dbService = DatabaseService();
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());
  bool _isLoading = true;
  bool _hasEntryToday = false;
  Map<String, dynamic>? _todaysEntry;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkTodaysEntry();
  }

  Future<void> _checkTodaysEntry() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final entry = await _dbService.getColorByDate(today);

      if (entry != null) {
        // User already has an entry for today
        setState(() {
          _hasEntryToday = true;
          _todaysEntry = entry;
          _isLoading = false;
        });

        // Navigate to reflection complete screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ReflectionCompleteScreen(todaysEntry: entry),
            ),
          );
        }
      } else {
        setState(() {
          _hasEntryToday = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to check entry: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking for today's entry
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                Color(0xFF8b5cf6),
                Color(0xFF6366f1),
                Color(0xFF4c1d95),
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Purple swirly background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color(0xFF8b5cf6),
                  Color(0xFF6366f1),
                  Color(0xFF4c1d95),
                ],
              ),
            ),
          ),
          // Swirl effect overlay (simplified)
          Positioned.fill(
            child: CustomPaint(
              painter: SwirlPainter(),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(Icons.menu_book, color: Colors.white, size: 40),
                      const SizedBox(width: 12),
                      const Text(
                        'LUMI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Navigation tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChartOfDayScreen()),
                          );
                        },
                        child: const Text('Chart of\nthe day',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CalendarScreen()),
                          );
                        },
                        child: const Text('Calendar',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Journal',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Journal inputs
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputField(
                            'What Happened in the morning?', 0),
                        const SizedBox(height: 20),
                        _buildInputField(
                            'A challange you faced today', 1),
                        const SizedBox(height: 20),
                        _buildInputField(
                            'An important interaction', 2),
                        const SizedBox(height: 20),
                        _buildInputField('A Key moment?', 3),
                        const SizedBox(height: 20),
                        _buildInputField('A meaningful thought', 4),
                        const SizedBox(height: 40),
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
                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitJournal,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFc4b5fd),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                    ),
                                  )
                                : const Text(
                                    'Generate Colour',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Footer
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Privacy Policy',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(width: 40),
                            Text('Terms & Conditions',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controllers[index],
          style: const TextStyle(color: Colors.white),
          maxLines: 2,
          decoration: InputDecoration(
            fillColor: const Color(0xFFc4b5fd).withOpacity(0.4),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitJournal() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final lines = _controllers.map((c) => c.text.trim()).toList();
      if (lines.every((line) => line.isEmpty)) {
        setState(() {
          _errorMessage = 'Please enter at least one description';
          _isLoading = false;
        });
        return;
      }

      // Get real user ID from authentication
      final userId = AuthService().currentUserId;
      if (userId == null) {
        setState(() {
          _errorMessage = 'Not logged in';
          _isLoading = false;
        });
        return;
      }

      // Get AI analysis from backend
      final result = await _lumiService.predictLines(lines);
      if (!mounted) return;

      // Save to database using authenticated Supabase client
      final dbService = DatabaseService();
      final hue = result['hue'] as int? ?? 0;
      final colorHex = '#${hue.toString().padLeft(3, '0')}000';
      final confidenceStr = result['confidence'] as String? ?? '0%';
      final moodScore = int.parse(confidenceStr.replaceAll('%', '').split('.')[0]);

      await dbService.saveDailyColor(
        userId: userId,
        emotion: result['emotion'] as String? ?? 'Neutral',
        colorHex: colorHex,
        moodScore: moodScore,
        description: result['summary'] as String?,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ColorResultScreen(prediction: result),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

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
}

// Custom painter for swirl effect
class SwirlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFec4899).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw some circular swirls
    canvas.drawCircle(
        Offset(size.width * 0.3, size.height * 0.3), 150, paint);
    canvas.drawCircle(
        Offset(size.width * 0.7, size.height * 0.7), 100, paint);

    paint.color = const Color(0xFF60a5fa).withOpacity(0.2);
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.2), 120, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
