// lib/main.dart
import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'solar_calculations.dart';
  
void main() {
  runApp(const ShadowCastApp());
}

class ShadowCastApp extends StatefulWidget {
  const ShadowCastApp({Key? key}) : super(key: key);

  @override
  State<ShadowCastApp> createState() => _ShadowCastAppState();
}

class _ShadowCastAppState extends State<ShadowCastApp> {
  Map<String, String>? lastResult;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShadowCast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: false,
      ),
      home: CalculatorScreen(
        initialResult: lastResult,
        onResultChanged: (res) {
          setState(() {
            lastResult = res;
          });
        },
      ),
    );
  }
}
