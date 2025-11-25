// lib/solar_calculations.dart
import 'dart:math';

/// Holds sun position data
class SunPosition {
  final double elevation; // in degrees
  final double azimuth;   // in degrees

  SunPosition({required this.elevation, required this.azimuth});
}

/// Converts azimuth angle to cardinal direction
String getDirection(double azimuth) {
  final dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  final idx = ((azimuth / 45).round()) % 8;
  return dirs[idx];
}

/// Calculate sun position (approximate)
SunPosition calculateSunPosition({
  required double lat,
  required double lon,
  required DateTime dt,
}) {
  // Convert date to Julian Day
  final jd = dt.millisecondsSinceEpoch / 86400000.0 + 2440587.5;
  final n = jd - 2451545.0;

  // Mean longitude & anomaly
  double L = (280.460 + 0.9856474 * n) % 360;
  double g = (357.528 + 0.9856003 * n) % 360;

  // Ecliptic longitude
  double lambda = L + 1.915 * sin(g * pi / 180) + 0.020 * sin(2 * g * pi / 180);

  // Obliquity
  double epsilon = 23.439 - 0.0000004 * n;

  // Declination
  double declination = asin(sin(epsilon * pi / 180) * sin(lambda * pi / 180)) * 180 / pi;

  // Hour angle
  final hours = dt.hour + dt.minute / 60.0 + dt.second / 3600.0;
  final hourAngle = (hours - 12.0) * 15.0;

  final latRad = lat * pi / 180.0;
  final decRad = declination * pi / 180.0;
  final haRad = hourAngle * pi / 180.0;

  // Elevation angle
  final elevationRad = asin(sin(latRad) * sin(decRad) + cos(latRad) * cos(decRad) * cos(haRad));
  final elevation = elevationRad * 180.0 / pi;

  // Azimuth angle
  final azimuthRad = atan2(
    sin(haRad),
    cos(haRad) * sin(latRad) - tan(decRad) * cos(latRad),
  );
  final azimuth = (azimuthRad * 180.0 / pi + 180.0) % 360.0;

  return SunPosition(elevation: elevation, azimuth: azimuth);
}

/// Calculate shadow length and direction
Map<String, String> calculateShadow({
  required double height,
  required double lat,
  required double lon,
  required DateTime dt,
}) {
  if (height <= 0) {
    return {'error': 'Height must be positive'};
  }

  final pos = calculateSunPosition(lat: lat, lon: lon, dt: dt);

  if (pos.elevation <= 0) {
    return {'error': 'Sun is below the horizon at this time'};
  }

  final elevationRad = pos.elevation * pi / 180.0;
  final shadowLength = height / tan(elevationRad);

  return {
    'shadowLength': shadowLength.toStringAsFixed(2),
    'direction': getDirection(pos.azimuth),
    'elevation': pos.elevation.toStringAsFixed(1),
    'azimuth': pos.azimuth.toStringAsFixed(1),
  };
}

/// Generate a list of shadow info for each hour (or smaller steps)
List<Map<String, String>> generateTimeComparison({
  required double height,
  required double lat,
  required double lon,
  required DateTime date,
  int stepMinutes = 60, // default: every hour
}) {
  final List<Map<String, String>> times = [];

  // From 6:00 to 18:00
  for (int minutes = 0; minutes <= 12 * 60; minutes += stepMinutes) {
    final dt = DateTime(date.year, date.month, date.day, 6).add(Duration(minutes: minutes));
    final pos = calculateSunPosition(lat: lat, lon: lon, dt: dt);

    if (pos.elevation > 0) {
      final elevationRad = pos.elevation * pi / 180.0;
      final shadowLength = height / tan(elevationRad);

      times.add({
        'time': dt.hour.toString().padLeft(2, '0') + ':' + dt.minute.toString().padLeft(2, '0'),
        'shadowLength': shadowLength.toStringAsFixed(2),
        'direction': getDirection(pos.azimuth),
        'elevation': pos.elevation.toStringAsFixed(1),
        'azimuth': pos.azimuth.toStringAsFixed(1),
      });
    }
  }

  return times;
}

/// Debug function to verify sun position
void debugSunPosition() {
  final testDate = DateTime(2024, 6, 21, 12, 0); // Summer solstice
  final testLat = 25.2048; // Dubai
  final testLon = 55.2708;

  final pos = calculateSunPosition(lat: testLat, lon: testLon, dt: testDate);

  print('Sun elevation at noon: ${pos.elevation}°'); // expect ~88°
  print('Sun azimuth at noon: ${pos.azimuth}°');
}
