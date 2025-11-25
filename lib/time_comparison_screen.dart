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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF3E0), // Soft peach
                Color(0xFFFFE0B2), // Light orange
                Color(0xFFFFCC80), // Warm amber
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              children: [
                // Header with back button
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFF6F00).withAlpha((0.2 * 255).round()),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: onBack,
                        icon: const Icon(Icons.arrow_back, color: Color(0xFFE65100)),
                        tooltip: 'Back',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Daily Shadow Timeline',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
  
                // Title section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.9 * 255).round()),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF6F00).withAlpha((0.15 * 255).round()),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF6F00), Color(0xFFFFB300)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF6F00).withAlpha((0.4 * 255).round()),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.wb_twilight, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shadow Changes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5D4037),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Throughout the day',
                              style: TextStyle(
                                color: Color(0xFF8D6E63),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFE65100), Color(0xFFFF6F00)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${comparisons.length} times',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
  
                // List of time comparisons
                Expanded(
                  child: comparisons.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 64,
                          color: Color(0xFFFF8F00),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No data available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Calculate a shadow first',
                          style: TextStyle(
                            color: Color(0xFF8D6E63),
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.separated(
                    itemCount: comparisons.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final item = comparisons[idx];
                      final time = item['time'] ?? '--:--';
                      final shadowLength = item['shadowLength'] ?? '0.0';
                      final direction = item['direction'] ?? 'N';
                      final elevation = item['elevation'] ?? '0';
                      final azimuth = item['azimuth'] ?? '0';
  
                      // Determine if it's sunrise, midday, or sunset period
                      IconData timeIcon = Icons.wb_sunny;
                      Color timeColor = Color(0xFFFF8F00);
  
                      if (time.contains('06:') || time.contains('07:')) {
                        timeIcon = Icons.wb_twilight;
                        timeColor = Color(0xFFFF6F00);
                      } else if (time.contains('12:') || time.contains('13:')) {
                        timeIcon = Icons.wb_sunny;
                        timeColor = Color(0xFFFFB300);
                      } else if (time.contains('17:') || time.contains('18:')) {
                        timeIcon = Icons.nights_stay;
                        timeColor = Color(0xFFE65100);
                      }
  
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF6F00).withAlpha((0.12 * 255).round()),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // Show detailed info dialog
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Details at $time',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF5D4037),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => Navigator.pop(context),
                                              icon: Icon(Icons.close, color: Color(0xFF5D4037)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        _buildDetailRow('Shadow Length', '$shadowLength m', Icons.straighten),
                                        _buildDetailRow('Direction', direction, Icons.explore),
                                        _buildDetailRow('Sun Elevation', '$elevation°', Icons.arrow_upward),
                                        _buildDetailRow('Sun Azimuth', '$azimuth°', Icons.compass_calibration),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Time badge
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [timeColor, timeColor.withOpacity(0.7)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: timeColor.withAlpha((0.3 * 255).round()),
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(timeIcon, color: Colors.white, size: 28),
                                        const SizedBox(height: 4),
                                        Text(
                                          time,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
  
                                  // Shadow info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.straighten,
                                              size: 16,
                                              color: Color(0xFF8D6E63),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Shadow Length',
                                              style: TextStyle(
                                                color: Color(0xFF8D6E63),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$shadowLength m',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF5D4037),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_upward,
                                              size: 14,
                                              color: Color(0xFF8D6E63),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Elevation: $elevation°',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8D6E63),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
  
                                  // Direction badge
                                  Column(
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFFFF8F00), Color(0xFFFFB300)],
                                          ),
                                          borderRadius: BorderRadius.circular(14),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFFFF8F00).withAlpha((0.3 * 255).round()),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.navigation,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              direction,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '$azimuth°',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF8D6E63),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  
    Widget _buildDetailRow(String label, String value, IconData icon) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6F00), Color(0xFFFFB300)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Color(0xFF8D6E63),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: Color(0xFF5D4037),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }