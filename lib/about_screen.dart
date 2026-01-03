// lib/about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final VoidCallback onBack;
  const AboutScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow.shade100, Colors.orange.shade100, Colors.teal.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, color: Colors.orange),
                  label: const Text('Back', style: TextStyle(color: Colors.orange)),
                ),
              ),
              const SizedBox(height: 12),

              // Header
              Column(
                children: const [
                  Icon(Icons.wb_sunny_outlined, size: 60, color: Colors.orange),
                  SizedBox(height: 8),
                  Text(
                    'About ShamsTrack',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Main Content
              Expanded(
                child: ListView(
                  children: [
                    InfoCard(
                      title: 'How It Works',
                      content:
                      'ShamsTrack calculates shadow length and direction using solar position algorithms. '
                          'The app determines the sun\'s elevation and azimuth angles based on your location, date, and time, '
                          'then applies trigonometry to compute precise shadow measurements.',
                      icon: Icons.calculate_outlined,
                      iconColor: Colors.teal,
                    ),
                    const SizedBox(height: 12),
                    InfoCard(
                      title: 'Use Cases',
                      icon: Icons.lightbulb_outline,
                      iconColor: Colors.orange,
                      children: [
                        _useCaseRow(Icons.camera_alt, 'Photography', 'Plan golden hour shoots'),
                        const SizedBox(height: 8),
                        _useCaseRow(Icons.home, 'Architecture', 'Design buildings considering shadow impact'),
                        const SizedBox(height: 8),
                        _useCaseRow(Icons.grass, 'Gardening', 'Determine sunlight exposure for plants'),
                        const SizedBox(height: 8),
                        _useCaseRow(Icons.solar_power, 'Solar Panels', 'Optimize placement avoiding shade'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.teal.shade300]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: const [
                          Text(
                            'Created with ☀️ by ShamsTrack Team',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
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

  // Use Case Row
  Widget _useCaseRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.orange),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ]),
        ),
      ],
    );
  }
}

// Reusable Card Widget
class InfoCard extends StatelessWidget {
  final String title;
  final String? content;
  final IconData icon;
  final Color iconColor;
  final List<Widget>? children;

  const InfoCard({
    Key? key,
    required this.title,
    this.content,
    required this.icon,
    required this.iconColor,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            if (content != null) Text(content!),
            if (children != null) ...children!,
          ],
        ),
      ),
    );
  }
}
