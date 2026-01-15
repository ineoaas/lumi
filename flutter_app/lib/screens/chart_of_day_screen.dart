import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/lumi_service.dart';
import 'calendar_screen.dart';
import 'journal_screen.dart';

class ChartOfDayScreen extends StatefulWidget {
  const ChartOfDayScreen({Key? key}) : super(key: key);

  @override
  State<ChartOfDayScreen> createState() => _ChartOfDayScreenState();
}

class _ChartOfDayScreenState extends State<ChartOfDayScreen> {
  final LumiService _lumiService = LumiService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _communityData;

  @override
  void initState() {
    super.initState();
    _loadCommunityMood();
  }

  Future<void> _loadCommunityMood() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _lumiService.getCommunityMoodToday();
      setState(() {
        _communityData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _getMoodColor(String mood) {
    // Map moods to colors
    switch (mood.toLowerCase()) {
      case 'joyful':
      case 'happy':
      case 'joy':
        return const Color(0xFFfbbf24); // Yellow
      case 'sad':
      case 'sadness':
        return const Color(0xFF3b82f6); // Blue
      case 'angry':
      case 'anger':
        return const Color(0xFFef4444); // Red
      case 'fearful':
      case 'fear':
        return const Color(0xFF8b5cf6); // Purple
      case 'surprised':
      case 'surprise':
        return const Color(0xFFec4899); // Pink
      case 'disgusted':
      case 'disgust':
        return const Color(0xFF10b981); // Green
      case 'neutral':
        return Colors.grey; // Grey
      default:
        return Colors.grey.shade600; // Dark grey
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        onPressed: () {},
                        child: const Text('Chart of\nthe day',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const JournalScreen()),
                          );
                        },
                        child: const Text('Journal',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // "Today, people are feeling..."
                const Text(
                  'Today, people are\nfeeling...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                // Loading, error, or chart
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : _errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.white, size: 48),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Could not load community mood',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : _communityData != null &&
                                  (_communityData!['total_entries'] as int) > 0
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      // Total entries badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '${_communityData!['total_entries']} people reflected today',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      // Pie chart
                                      SizedBox(
                                        width: 300,
                                        height: 300,
                                        child: CustomPaint(
                                          painter: PieChartPainter(
                                            data: _buildPieData(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      // Legend
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Wrap(
                                          spacing: 20,
                                          runSpacing: 16,
                                          alignment: WrapAlignment.center,
                                          children: _buildLegend(),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.sentiment_neutral,
                                          color: Colors.white.withOpacity(0.5),
                                          size: 80),
                                      const SizedBox(height: 20),
                                      Text(
                                        'No reflections yet today',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Be the first to journal today!',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                ),
                // Footer
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Privacy Policy',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(width: 40),
                      Text('Terms & Conditions',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieData> _buildPieData() {
    if (_communityData == null) return [];

    final moodCounts = _communityData!['mood_counts'] as Map<String, dynamic>;
    final total = _communityData!['total_entries'] as int;

    return moodCounts.entries.map((entry) {
      final mood = entry.key as String;
      final count = entry.value as int;
      final percentage = count / total;
      return PieData(mood, percentage, _getMoodColor(mood), count);
    }).toList();
  }

  List<Widget> _buildLegend() {
    if (_communityData == null) return [];

    final moodCounts = _communityData!['mood_counts'] as Map<String, dynamic>;
    final moodPercentages =
        _communityData!['mood_percentages'] as Map<String, dynamic>;

    return moodCounts.entries.map((entry) {
      final mood = entry.key as String;
      final count = entry.value as int;
      final percentage = moodPercentages[mood] as num;
      final color = _getMoodColor(mood);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$mood: $count (${percentage.toStringAsFixed(1)}%)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }).toList();
  }
}

// Pie chart painter
class PieChartPainter extends CustomPainter {
  final List<PieData> data;

  PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double startAngle = -math.pi / 2;

    for (var slice in data) {
      final sweepAngle = 2 * math.pi * slice.percentage;

      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw label if slice is large enough
      if (slice.percentage > 0.05) {
        // Only show label if > 5%
        final labelAngle = startAngle + sweepAngle / 2;
        final labelRadius = radius * 0.65;
        final labelX = center.dx + labelRadius * math.cos(labelAngle);
        final labelY = center.dy + labelRadius * math.sin(labelAngle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '${(slice.percentage * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black45,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant PieChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

class PieData {
  final String label;
  final double percentage;
  final Color color;
  final int count;

  PieData(this.label, this.percentage, this.color, this.count);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PieData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          percentage == other.percentage &&
          count == other.count;

  @override
  int get hashCode => label.hashCode ^ percentage.hashCode ^ count.hashCode;
}
