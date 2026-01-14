import 'package:flutter/material.dart';
import 'journal_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4a148c), Color(0xFF6a1b9a)],
              ),
            ),
          ),
          // Character illustration
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.3),
              ),
              child: Center(
                child: Icon(Icons.person, size: 200, color: Colors.brown[300]),
              ),
            ),
          ),
          // Sign Up Form
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 60),
                    const Text(
                      'Username:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.2),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Password:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.2),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Confirm\nPassword:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.2),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.2),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to journal screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const JournalScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4a148c),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 32),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.facebook,
                              color: Colors.white, size: 32),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.business,
                              color: Colors.white, size: 32),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}