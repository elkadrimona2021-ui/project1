// lib/about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final VoidCallback onBack;
  const AboutScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // gradient bg similar to React
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green.shade50, Colors.teal.shade50, Colors.cyan.shade50]),
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
                children: const [
                  Icon(Icons.info_outline, size: 56, color: Colors.green),
                  SizedBox(height: 8),
                  Text('About ShadowCast', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('How It Works', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            SizedBox(height: 8),
                            Text(
                              'ShadowCast calculates shadow length and direction using solar position algorithms. '
                                  'The app determines the sun\'s elevation and azimuth angles based on your location, '
                                  'date, and time, then applies trigonometry to compute precise shadow measurements.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Use Cases', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 8),
                            _useCaseRow('Photography', 'Plan golden hour shoots with optimal shadow angles'),
                            const SizedBox(height: 8),
                            _useCaseRow('Architecture', 'Design buildings considering shadow impact'),
                            const SizedBox(height: 8),
                            _useCaseRow('Gardening', 'Determine sunlight exposure for plant placement'),
                            const SizedBox(height: 8),
                            _useCaseRow('Solar Panels', 'Optimize panel placement avoiding shade'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.green.shade600, Colors.teal.shade500]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: const [
                          Text('Created with ☀️ by ShadowCast Team', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          SizedBox(height: 6),
                          Text('Version 1.0 | 2025', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _useCaseRow(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ]),
        )
      ],
    );
  }
}
