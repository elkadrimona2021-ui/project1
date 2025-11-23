import 'package:flutter/material.dart';
import 'solar_calculations.dart';

class TimeComparisonScreen extends StatelessWidget {
  const TimeComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<int> times = [6, 9, 12, 15, 18];

    return Scaffold(
      appBar: AppBar(title: const Text("Time Comparison")),
      body: ListView.builder(
        itemCount: times.length,
        itemBuilder: (c, i) {
          final h = times[i];
          final dt = DateTime.now().copyWith(hour: h, minute: 0);

          final solar = SolarCalc.getSolarData(dt, 30, 35);
          final shadow = SolarCalc.shadowLength(1, solar["elevation"]!);

          return ListTile(
            title: Text("$h:00 → Shadow: ${shadow.toStringAsFixed(2)} m"),
          );
        },
      ),
    );
  }
}
