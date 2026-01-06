// lib/calculator_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'solar_calculations.dart';
import 'result_card.dart';
import 'time_comparison_screen.dart';
import 'about_screen.dart';

class CalculatorScreen extends StatefulWidget {
  final Function(Map<String, String>?) onResultChanged;
  final Map<String, String>? initialResult;

  const CalculatorScreen({
    Key? key,
    required this.onResultChanged,
    this.initialResult,
  }) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String heightStr = '2';
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.fromDateTime(DateTime.now());

  double latitude = 25.2048;
  double longitude = 55.2708;

  String locationStatus = 'Using default location';
  bool isLoadingLocation = false;

  Map<String, String>? result;
  List<Map<String, String>> timeComparison = [];

  @override
  void initState() {
    super.initState();
    result = widget.initialResult;
    _getCurrentLocation();
  }


  // ================= LOCATION =================
  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
      locationStatus = 'Getting your location...';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationStatus = 'Location services disabled';
          isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationStatus = 'Location permission denied';
            isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationStatus = 'Location permission permanently denied';
          isLoadingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        locationStatus = 'Using your current location';
        isLoadingLocation = false;
      });
    } catch (_) {
      setState(() {
        locationStatus = 'Could not get location';
        isLoadingLocation = false;
      });
    }
  }

  // ================= CALCULATION =================
  DateTime _combinedDateTime() {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _calculateShadow() {
    final h = double.tryParse(heightStr) ?? 0.0;
    final dt = _combinedDateTime();

    final res = calculateShadow(height: h, lat: latitude, lon: longitude, dt: dt);
    setState(() {
      result = res;
    });
    widget.onResultChanged(result);
    if (res != null && !res.containsKey('error')) {
      saveSimulationToServer(res, heightStr, latitude, longitude, date, time);
    }
  }

  // ================= SAVE TO SERVER =================
  Future<void> saveSimulationToServer(
      Map<String, String> result,
      String height,
      double latitude,
      double longitude,
      DateTime selectedDate,
      TimeOfDay selectedTime,
      ) async {
    if (result.containsKey('error')) return;

    final url = Uri.parse('http://jennnaa.atwebpages.com/save_simulations.php');

    final body = {
      'height': double.parse(height),
      'latitude': latitude,
      'longitude': longitude,
      'date': selectedDate.toIso8601String().split('T')[0],
      'time': '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
      'shadowLength': double.parse(result['shadowLength']!),
      'direction': result['direction'],
      'elevation': double.parse(result['elevation']!),
      'azimuth': double.parse(result['azimuth']!),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print('Server response: ${response.statusCode} - ${response.body}');
    } catch (e) {
      print('Error sending to server: $e');
    }
  }

  // ================= NAVIGATION =================
  void generateComparisonAndNavigate() {
    final h = double.tryParse(heightStr) ?? 0.0;
    final comp = generateTimeComparison(height: h, lat: latitude, lon: longitude, date: date);
    setState(() {
      timeComparison = comp;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TimeComparisonScreen(
          comparisons: timeComparison,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: time);
    if (picked != null) setState(() => time = picked);
  }

  void _openAbout() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AboutScreen(onBack: () => Navigator.of(context).pop()),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final timeStr = time.format(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF6F00), Color(0xFFFFB300)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF6F00).withAlpha((0.4 * 255).round()),
                                blurRadius: 20,
                                spreadRadius: 4,
                              )
                            ],
                          ),
                          child: const Icon(Icons.wb_sunny, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'ShamsTrack',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Color(0xFFE65100), Color(0xFFFF6F00)],
                              ).createShader(const Rect.fromLTWH(0, 0, 200, 0)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Track the sun, predict the shadow',
                          style: TextStyle(
                            color: Color(0xFF5D4037),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // ===== Input Card =====
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.95 * 255).round()),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFF6F00).withAlpha((0.15 * 255).round()),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Height
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: const [
                                Icon(Icons.straighten, color: Color(0xFFFF6F00)),
                                SizedBox(width: 8),
                                Text('Object Height (meters)', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF5D4037))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: heightStr,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => setState(() => heightStr = v),
                            decoration: InputDecoration(
                              hintText: '2.0',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFFF6F00), width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: const [
                                      Icon(Icons.calendar_today, color: Color(0xFFFF8F00)),
                                      SizedBox(width: 8),
                                      Text('Date', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF5D4037)))
                                    ]),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: _pickDate,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Color(0xFFFFCC80)),
                                          borderRadius: BorderRadius.circular(12),
                                          color: Color(0xFFFFF8E1),
                                        ),
                                        child: Text(dateStr, style: TextStyle(color: Color(0xFF5D4037))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: const [
                                      Icon(Icons.access_time, color: Color(0xFFFF8F00)),
                                      SizedBox(width: 8),
                                      Text('Time', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF5D4037)))
                                    ]),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: _pickTime,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Color(0xFFFFCC80)),
                                          borderRadius: BorderRadius.circular(12),
                                          color: Color(0xFFFFF8E1),
                                        ),
                                        child: Text(timeStr, style: TextStyle(color: Color(0xFF5D4037))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Location status indicator
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFFFB74D), width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isLoadingLocation ? Icons.location_searching : Icons.location_on,
                                  color: Color(0xFFE65100),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    locationStatus,
                                    style: TextStyle(
                                      color: Color(0xFF5D4037),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (!isLoadingLocation)
                                  IconButton(
                                    icon: Icon(Icons.refresh, size: 20, color: Color(0xFFE65100)),
                                    onPressed: _getCurrentLocation,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: _calculateShadow,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Color(0xFFFF6F00),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: Color(0xFFFF6F00).withAlpha((0.4 * 255).round()),
                            ),
                            child: const Text('Calculate Shadow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Result card
                    if (result != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ResultCard(result: result!),
                      ),

                    // Buttons row (Compare / Visualize / About)
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Compare
                        Expanded(
                          child: OutlinedButton(
                            onPressed: generateComparisonAndNavigate,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: BorderSide(color: Color(0xFFFF8F00), width: 2),
                              foregroundColor: Color(0xFFE65100),
                            ),
                            child: Column(
                              children: const [
                                Icon(Icons.access_time, color: Color(0xFFFF6F00)),
                                SizedBox(height: 4),
                                Text('Compare', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Visualize
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              if (result == null || result!.containsKey('error')) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Calculate a shadow first to see visualization'),
                                    backgroundColor: Color(0xFFE65100),
                                  ),
                                );
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (_) => ShadowVisualizationDialog(result: result!),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: BorderSide(color: Color(0xFFFF8F00), width: 2),
                              foregroundColor: Color(0xFFE65100),
                            ),
                            child: Column(
                              children: const [
                                Icon(Icons.explore, color: Color(0xFFFF6F00)),
                                SizedBox(height: 4),
                                Text('Visualize', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // About
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _openAbout,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: BorderSide(color: Color(0xFFFF8F00), width: 2),
                              foregroundColor: Color(0xFFE65100),
                            ),
                            child: Column(
                              children: const [
                                Icon(Icons.info_outline, color: Color(0xFFFF6F00)),
                                SizedBox(height: 4),
                                Text('About', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// You can move the ShadowVisualizationDialog to a separate file if needed
class ShadowVisualizationDialog extends StatelessWidget {
  final Map<String, String> result;
  const ShadowVisualizationDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final az = double.tryParse(result['azimuth'] ?? '0') ?? 0.0;
    final sl = double.tryParse(result['shadowLength'] ?? '0') ?? 0.0;
    final scaled = (sl * 30).clamp(20.0, 140.0);
    final angleInRadians = (az - 90) * 3.1415926535 / 180.0;
    final centerX = 180.0;
    final centerY = 180.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 400,
        height: 520,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Color(0xFF5D4037)),
                ),
                const Text(
                  'Shadow Visualization',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Stack(
                  children: [
                    // Compass and shadow line
                    Positioned(
                      left: centerX,
                      top: centerY,
                      child: Transform.rotate(
                        angle: angleInRadians,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: scaled,
                          height: 10,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF424242).withAlpha((0.7 * 255).round()),
                                Color(0xFF424242).withAlpha((0.2 * 255).round()),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    // Object at center
                    Positioned(
                      left: centerX - 15,
                      top: centerY - 35,
                      child: Column(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF6F00), Color(0xFFFFB300)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFF6F00).withAlpha((0.6 * 255).round()),
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Icon(Icons.wb_sunny, color: Colors.white, size: 16),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 20,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFF6D4C41),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 4),
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
            const SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Sun Elevation: ${result['elevation']}°  |  Azimuth: ${result['azimuth']}°',
                style: const TextStyle(
                  color: Color(0xFF5D4037),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
