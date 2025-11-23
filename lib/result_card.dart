import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final double shadow;
  final String direction;

  const ResultCard({super.key, required this.shadow, required this.direction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Shadow Length: ${shadow.toStringAsFixed(2)} m",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Shadow Direction: $direction",
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
