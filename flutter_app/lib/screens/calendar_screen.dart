import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'chart_of_day_screen.dart';
import 'journal_screen.dart';
import 'reflection_summary_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DatabaseService _dbService = DatabaseService();
  Map<String, Map<String, dynamic>> _entriesByDate = {};
  bool _isLoading = true;
  String? _errorMessage;
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool _isSelectingRange = false;

  @override
  void initState() {
    super.initState();
    _loadCalendarData();
  }

  Future<void> _loadCalendarData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get entries for the current month
      final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
      final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

      final entries = await _dbService.getColorsByDateRange(
        firstDay.toIso8601String().split('T')[0],
        lastDay.toIso8601String().split('T')[0],
      );

      // Convert list to map by date
      final entriesMap = <String, Map<String, dynamic>>{};
      for (var entry in entries) {
        final date = entry['date'] as String;
        entriesMap[date] = entry;
      }

      setState(() {
        _entriesByDate = entriesMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _getColorFromHex(String? colorHex) {
    if (colorHex == null) return Colors.grey.shade300;
    try {
      // Remove # if present
      final hex = colorHex.replaceAll('#', '');

      // Extract hue from the hex (first 3 digits represent hue 0-360)
      final hueStr = hex.substring(0, 3);
      final hue = int.parse(hueStr);

      // Convert to HSL color
      return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.75, 0.55).toColor();
    } catch (e) {
      return Colors.grey.shade300;
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    _loadCalendarData();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    _loadCalendarData();
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday

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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChartOfDayScreen()),
                          );
                        },
                        child: const Text('Chart of\nthe day',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Calendar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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
                        child:
                            const Text('Journal', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Month selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left,
                            color: Colors.white, size: 32),
                        onPressed: _previousMonth,
                      ),
                      Text(
                        '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.white, size: 32),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Range selection and summarize buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _toggleRangeSelection,
                          icon: Icon(_isSelectingRange
                              ? Icons.close
                              : Icons.date_range),
                          label: Text(_isSelectingRange
                              ? 'Cancel'
                              : 'Select Range'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSelectingRange
                                ? Colors.red.withOpacity(0.8)
                                : Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      if (_isSelectingRange &&
                          _selectedStartDate != null &&
                          _selectedEndDate != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _generateSummary,
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text('Summarize'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.withOpacity(0.9),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Calendar grid
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white))
                      : _errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'Error: $_errorMessage',
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  // Days of week header
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat',
                                      'Sun'
                                    ]
                                        .map((day) => SizedBox(
                                              width: 40,
                                              child: Text(
                                                day,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 20),
                                  // Calendar days
                                  Expanded(
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 7,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                      ),
                                      itemCount:
                                          firstWeekday - 1 + daysInMonth,
                                      itemBuilder: (context, index) {
                                        // Empty cells before the first day of month
                                        if (index < firstWeekday - 1) {
                                          return Container();
                                        }

                                        final day = index - firstWeekday + 2;
                                        final date = DateTime(
                                            _currentMonth.year,
                                            _currentMonth.month,
                                            day);
                                        final dateStr = date
                                            .toIso8601String()
                                            .split('T')[0];

                                        final entry = _entriesByDate[dateStr];
                                        final hasEntry = entry != null;
                                        final color = hasEntry
                                            ? _getColorFromHex(
                                                entry['color_hex'])
                                            : Colors.grey.shade300;

                                        final isSelected = (_selectedStartDate != null &&
                                                _selectedStartDate!.year == date.year &&
                                                _selectedStartDate!.month == date.month &&
                                                _selectedStartDate!.day == date.day) ||
                                            (_selectedEndDate != null &&
                                                _selectedEndDate!.year == date.year &&
                                                _selectedEndDate!.month == date.month &&
                                                _selectedEndDate!.day == date.day);

                                        final isInRange = _selectedStartDate != null &&
                                            _selectedEndDate != null &&
                                            date.isAfter(_selectedStartDate!) &&
                                            date.isBefore(_selectedEndDate!);

                                        return GestureDetector(
                                          onTap: () => _handleDateTap(date),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.yellow
                                                    : hasEntry
                                                        ? Colors.white
                                                            .withOpacity(0.3)
                                                        : Colors.transparent,
                                                width: isSelected ? 3 : 2,
                                              ),
                                              boxShadow: isInRange
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.yellow.withOpacity(0.3),
                                                        blurRadius: 4,
                                                      )
                                                    ]
                                                  : null,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$day',
                                                style: TextStyle(
                                                  color: hasEntry
                                                      ? Colors.white
                                                      : Colors.grey.shade500,
                                                  fontWeight: hasEntry
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
                const SizedBox(height: 20),
                // Legend
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'No entry',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10b981),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Has entry',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
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

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  void _handleDateTap(DateTime date) {
    if (!_isSelectingRange) {
      // First tap - check if entry exists, show details
      final dateStr = date.toIso8601String().split('T')[0];
      final entry = _entriesByDate[dateStr];
      if (entry != null) {
        _showEntryDetails(context, entry);
      }
    } else {
      // Range selection mode
      setState(() {
        if (_selectedStartDate == null) {
          _selectedStartDate = date;
        } else if (_selectedEndDate == null) {
          if (date.isBefore(_selectedStartDate!)) {
            _selectedEndDate = _selectedStartDate;
            _selectedStartDate = date;
          } else {
            _selectedEndDate = date;
          }
        } else {
          // Reset and start over
          _selectedStartDate = date;
          _selectedEndDate = null;
        }
      });
    }
  }

  void _toggleRangeSelection() {
    setState(() {
      _isSelectingRange = !_isSelectingRange;
      if (!_isSelectingRange) {
        _selectedStartDate = null;
        _selectedEndDate = null;
      }
    });
  }

  Future<void> _generateSummary() async {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date range first')),
      );
      return;
    }

    final entriesInRange = _entriesByDate.values
        .where((entry) {
          final entryDate = DateTime.parse(entry['date']);
          return (entryDate.isAfter(_selectedStartDate!) ||
                  entryDate.isAtSameMomentAs(_selectedStartDate!)) &&
              (entryDate.isBefore(_selectedEndDate!) ||
                  entryDate.isAtSameMomentAs(_selectedEndDate!));
        })
        .toList();

    if (entriesInRange.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No entries found in selected range')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReflectionSummaryScreen(
          startDate: _selectedStartDate!,
          endDate: _selectedEndDate!,
          entries: entriesInRange,
        ),
      ),
    );
  }

  void _showEntryDetails(BuildContext context, Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${entry['date']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getColorFromHex(entry['color_hex']),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry['mood'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Score: ${entry['mood_score'] ?? 0}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (entry['description'] != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(entry['description']),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
