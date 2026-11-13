import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RecallItApp());
}

class RecallItApp extends StatelessWidget {
  const RecallItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecallIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}