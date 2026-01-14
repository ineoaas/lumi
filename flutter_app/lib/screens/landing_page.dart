import 'package:flutter/material.dart';
import 'login_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a0033), Color(0xFF4a148c)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with LUMI logo
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.menu_book, color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          'LUMI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFFb19cd9),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        // Hero text
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Take care\nof ',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFb19cd9),
                                  height: 1.2,
                                ),
                              ),
                              TextSpan(
                                text: 'yourself',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Book illustration
                        Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.menu_book,
                            size: 80,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Feature section
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFc4b5fd).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFc4b5fd).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 4,
                                height: 40,
                                color: const Color(0xFFff6b9d),
                                margin: const EdgeInsets.only(bottom: 16),
                              ),
                              const Text(
                                'Improve your\nmental health',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Track your emotions, journal your thoughts, and visualize your mental wellness journey with color-coded insights.',
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // CTA Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFb19cd9),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Footer section
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Ready for your\n',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'next ',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFFb19cd9),
                                        height: 1.2,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Session?',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 28),
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: const Icon(Icons.facebook,
                                        color: Colors.white, size: 28),
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: const Icon(Icons.business,
                                        color: Colors.white, size: 28),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}