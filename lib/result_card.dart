// lib/result_card.dart
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final Map<String, String> result;

  const ResultCard({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (result.containsKey('error')) { //error
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.nights_stay, size: 48, color: Colors.indigo),
              const SizedBox(height: 12),
              Text(
                result['error'] ?? 'Error',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }

    return Card( // success
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text(
              'Shadow Results', //title
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                foreground: Paint()..shader = LinearGradient(
                  colors: [Colors.purple.shade700, Colors.pink.shade600],
                ).createShader(const Rect.fromLTWH(0,0,200,0)),
              ),
            ),
            const SizedBox(height: 12),
            GridView(
              shrinkWrap: true, //results
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.2,
              ),
              children: [
                _statBox('Shadow Length', '${result['shadowLength']}m', Colors.purple),
                _statBox('Direction', result['direction'] ?? '-', Colors.pink),
                _statBox('Sun Elevation', '${result['elevation']}°', Colors.blue),
                _statBox('Azimuth', '${result['azimuth']}°', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String title, String value, Color base) {//reusable widget used to display one piece of the shadow result
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [base.withOpacity(0.15), base.withOpacity(0.08)]),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: base.withOpacity(0.9), fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: base)),
        ],
      ),
    );
  }
}
