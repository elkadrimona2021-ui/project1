// lib/calculator_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'solar_calculations.dart';
import 'result_card.dart';
import 'time_comparison_screen.dart';
import 'about_screen.dart';

class CalculatorScreen extends StatefulWidget {
  final Function(Map<String, String>?) onResultChanged;
  final Map<String, String>? initialResult;

  const CalculatorScreen({Key? key, required this.onResultChanged, this.initialResult}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String heightStr = '2';
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.fromDateTime(DateTime.now());
  String latitudeStr = '25.2048';
  String longitudeStr = '55.2708';
  Map<String, String>? result;
  List<Map<String, String>> timeComparison = [];

  @override
  void initState() {
    super.initState();
    result = widget.initialResult;
  }

  DateTime _combinedDateTime() {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _calculateShadow() {
    final h = double.tryParse(heightStr) ?? 0.0;
    final lat = double.tryParse(latitudeStr) ?? 0.0;
    final lon = double.tryParse(longitudeStr) ?? 0.0;
    final dt = _combinedDateTime();

    final res = calculateShadow(height: h, lat: lat, lon: lon, dt: dt);
    setState(() {
      result = res;
    });
    widget.onResultChanged(result);
  }

  void generateComparisonAndNavigate() {
    final h = double.tryParse(heightStr) ?? 0.0;
    final lat = double.tryParse(latitudeStr) ?? 0.0;
    final lon = double.tryParse(longitudeStr) ?? 0.0;
    final comp = generateTimeComparison(height: h, lat: lat, lon: lon, date: date);
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

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final timeStr = time.format(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.shade50, Colors.purple.shade50, Colors.pink.shade50]),
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
                            gradient: LinearGradient(colors: [Colors.yellow.shade700, Colors.orange.shade600]),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                          ),
                          child: const Icon(Icons.wb_sunny, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 12),
                        Text('ShadowCast', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, foreground: Paint()..shader = LinearGradient(colors: [Colors.purple.shade600, Colors.pink.shade600]).createShader(const Rect.fromLTWH(0,0,200,0)))),
                        const SizedBox(height: 6),
                        Text('Calculate shadows with precision', style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      decoration: BoxDecoration(color: Colors.white.withAlpha((0.95 * 255).round())
                          , borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Height
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: const [
                                Icon(Icons.straighten, color: Colors.purple),
                                SizedBox(width: 8),
                                Text('Object Height (meters)', style: TextStyle(fontWeight: FontWeight.w600)),
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
                                    Row(children: const [Icon(Icons.calendar_today, color: Colors.blue), SizedBox(width:8), Text('Date', style: TextStyle(fontWeight: FontWeight.w600))]),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: _pickDate,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                        decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade100), borderRadius: BorderRadius.circular(12)),
                                        child: Text(dateStr),
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
                                    Row(children: const [Icon(Icons.access_time, color: Colors.pink), SizedBox(width:8), Text('Time', style: TextStyle(fontWeight: FontWeight.w600))]),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: _pickTime,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                        decoration: BoxDecoration(border: Border.all(color: Colors.pink.shade100), borderRadius: BorderRadius.circular(12)),
                                        child: Text(timeStr),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: const [
                                Icon(Icons.place, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Location', style: TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: latitudeStr,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                                  decoration: InputDecoration(
                                    hintText: 'Latitude',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  ),
                                  onChanged: (v) => setState(() => latitudeStr = v),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  initialValue: longitudeStr,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                                  decoration: InputDecoration(
                                    hintText: 'Longitude',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  ),
                                  onChanged: (v) => setState(() => longitudeStr = v),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: _calculateShadow,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Calculate Shadow', style: TextStyle(fontWeight: FontWeight.bold)),
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

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: generateComparisonAndNavigate,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Column(
                              children: const [Icon(Icons.access_time), SizedBox(height: 4), Text('Compare', style: TextStyle(fontSize: 12))],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Visual screen - if result exists, open a simple visualization modal
                              if (result == null || result!.containsKey('error')) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calculate a shadow first to see visualization')));
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    width: 400,
                                    height: 480,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                                            const Text('Shadow Visualization', style: TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(width: 40),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Expanded(
                                          child: LayoutBuilder(builder: (context, constraints) {
                                            final az = double.tryParse(result?['azimuth'] ?? '0') ?? 0.0;
                                            final sl = double.tryParse(result?['shadowLength'] ?? '0') ?? 0.0;
                                            final scaled = (sl * 30).clamp(0.0, 140.0);
                                            // Using CustomPaint would be ideal but use simple stack:
                                            return Center(
                                              child: Container(
                                                width: 360,
                                                height: 360,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                                                child: Stack(
                                                  children: [
                                                    // Compass labels
                                                    Positioned(top: 8, left: 0, right: 0, child: Center(child: Text('N', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)))),
                                                    Positioned(bottom: 8, left: 0, right: 0, child: Center(child: Text('S', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)))),
                                                    Positioned(left: 8, top: constraints.maxHeight/2 - 10, child: Text('W', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold))),
                                                    Positioned(right: 8, top: constraints.maxHeight/2 - 10, child: Text('E', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold))),
                                                    // Object
                                                    Positioned(
                                                      left: 160,
                                                      top: 140,
                                                      child: Column(
                                                        children: [
                                                          Container(width: 40, height: 10, decoration: BoxDecoration(color: Colors.yellow[600], shape: BoxShape.circle)),
                                                          const SizedBox(height: 6),
                                                          Container(width: 30, height: 60, decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(4))),
                                                        ],
                                                      ),
                                                    ),
                                                    // Shadow line
                                                    Positioned(
                                                      left: 200,
                                                      top: 200,
                                                      child: Transform.rotate(
                                                        angle: (az) * 3.1415926535 / 180.0,
                                                        child: Container(
                                                          width: scaled,
                                                          height: 12,
                                                          decoration: BoxDecoration(color:Colors.black.withAlpha((0.35 * 255).round())
                                                              , borderRadius: BorderRadius.circular(8)),
                                                        ),
                                                      ),
                                                    ),
                                                    // Shadow label
                                                    Positioned(bottom: 12, left: 0, right: 0, child: Center(child: Text('${result?['shadowLength']}m ${result?['direction']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)))),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 8),
                                        if (result != null)
                                          Text('Sun Elevation: ${result?['elevation']}°  |  Azimuth: ${result?['azimuth']}°', style: const TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Column(
                              children: const [Icon(Icons.explore), SizedBox(height: 4), Text('Visualize', style: TextStyle(fontSize: 12))],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _openAbout,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Column(
                              children: const [Icon(Icons.info_outline), SizedBox(height: 4), Text('About', style: TextStyle(fontSize: 12))],
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
