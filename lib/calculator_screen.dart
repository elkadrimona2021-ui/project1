import 'package:flutter/material.dart';
import 'solar_calculations.dart';
import 'result_card.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final heightC = TextEditingController();
  final latC = TextEditingController();
  final lonC = TextEditingController();

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  double? length;
  String? direction;

  void calc() {
    final dt = DateTime(
        date.year, date.month, date.day, time.hour, time.minute);

    final solar = SolarCalc.getSolarData(
      dt,
      double.parse(latC.text),
      double.parse(lonC.text),
    );

    final shadow = SolarCalc.shadowLength(
      double.parse(heightC.text),
      solar["elevation"]!,
    );

    final dir = SolarCalc.azimuthToDirection(solar["azimuth"]!);

    setState(() {
      length = shadow;
      direction = dir;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shadow Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: heightC, decoration: const InputDecoration(labelText: "Object Height (m)"), keyboardType: TextInputType.number),
            TextField(controller: latC, decoration: const InputDecoration(labelText: "Latitude"), keyboardType: TextInputType.number),
            TextField(controller: lonC, decoration: const InputDecoration(labelText: "Longitude"), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  final d = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (d != null) setState(() => date = d);
                },
                child: Text("Select Date: ${date.toString().split(' ')[0]}")),
            ElevatedButton(
                onPressed: () async {
                  final t = await showTimePicker(
                      context: context, initialTime: time);
                  if (t != null) setState(() => time = t);
                },
                child: Text("Select Time: ${time.format(context)}")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: calc, child: const Text("Calculate")),
            const SizedBox(height: 20),
            if (length != null)
              ResultCard(shadow: length!, direction: direction!),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, "/compare"),
                child: const Text("Time Comparison")),
          ],
        ),
      ),
    );
  }
}