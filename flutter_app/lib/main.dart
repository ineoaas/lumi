import 'package:flutter/material.dart';
import 'screens/landing_page.dart';

void main() {
  runApp(const LumiApp());
}

class LumiApp extends StatelessWidget {
  const LumiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumi - Mental Health Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LandingPage(),
    );
  }
}
