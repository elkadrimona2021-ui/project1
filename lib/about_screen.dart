import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
            "ShadowCast calculates sun position and shadow length.\nUseful for photography, gardening, planning, and more.\nCreated by Mona."),
      ),
    );
  }
}
