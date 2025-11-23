import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'time_comparison_screen.dart';
import 'about_screen.dart';

void main() => runApp(const ShadowCastApp());

class ShadowCastApp extends StatelessWidget {
  const ShadowCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ShadowCast",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      routes: {
        "/": (_) => const CalculatorScreen(),
        "/compare": (_) => const TimeComparisonScreen(),
        "/about": (_) => const AboutScreen(),
      },
    );
  }
}