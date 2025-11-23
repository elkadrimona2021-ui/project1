// lib/time_comparison_screen.dart
import 'package:flutter/material.dart';

class TimeComparisonScreen extends StatelessWidget {
  final List<Map<String, String>> comparisons;
  final VoidCallback onBack;

  const TimeComparisonScreen({
    Key? key,
    required this.comparisons,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // gradient background mimic
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.indigo.shade50, Colors.blue.shade50, Colors.cyan.shade50]),
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  const Icon(Icons.access_time, size: 56, color: Colors.indigo),
                  const SizedBox(height: 8),
                  const Text('Time Comparison', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Shadow changes throughout the day', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: comparisons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, idx) {
                    final item = comparisons[idx];
                    return InkWell(
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.indigo.shade500, Colors.purple.shade500]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(item['time'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Shadow Length', style: TextStyle(color: Colors.grey)),
                                    Text('${item['shadowLength']}m', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [Colors.cyan.shade400, Colors.blue.shade500]),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(item['direction'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 6),
                                  Text('Elevation: ${item['elevation']}°', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
