import 'package:flutter/material.dart';
import 'chart_of_day_screen.dart';
import 'journal_screen.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

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
                        child: const Text('Journal',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Calendar grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        // Days of week header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
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
                            itemCount: 31,
                            itemBuilder: (context, index) {
                              // Random colors for demo (in real app, would be from data)
                              final colors = [
                                const Color(0xFFfbbf24), // Yellow
                                const Color(0xFFef4444), // Red
                                const Color(0xFF3b82f6), // Blue
                                const Color(0xFF10b981), // Green
                                const Color(0xFFf59e0b), // Orange
                                Colors.grey, // Neutral
                              ];
                              final dayColor = colors[index % colors.length];

                              return Container(
                                decoration: BoxDecoration(
                                  color: dayColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
}