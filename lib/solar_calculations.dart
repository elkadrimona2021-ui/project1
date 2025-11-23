// lib/solar_calculations.dart
import 'dart:math';

class SunPosition {
  final double elevation;
  final double azimuth;
  SunPosition({required this.elevation, required this.azimuth});
}

String getDirection(double azimuth) {
  final dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  final idx = ((azimuth / 45).round()) % 8;
  return dirs[idx];
}

SunPosition calculateSunPosition({
  required double lat,
  required double lon,
  required DateTime dt,
}) {
  // Based on the JS algorithm you provided (approximate)
  // Convert to Julian Day
  final jd = dt.millisecondsSinceEpoch / 86400000.0 + 2440587.5;
  final n = jd - 2451545.0;
  double L = (280.460 + 0.9856474 * n) % 360;
  double g = (357.528 + 0.9856003 * n) % 360;
  double lambda = L +
      1.915 * sin(g * pi / 180) +
      0.020 * sin(2 * g * pi / 180);
  double epsilon = 23.439 - 0.0000004 * n;
  double declination =
      asin(sin(epsilon * pi / 180) * sin(lambda * pi / 180)) * 180 / pi;

  final hours = dt.hour + dt.minute / 60.0 + dt.second / 3600.0;
  final hourAngle = (hours - 12.0) * 15.0;

  final latRad = lat * pi / 180.0;
  final decRad = declination * pi / 180.0;
  final haRad = hourAngle * pi / 180.0;

  final elevationRad = asin(
    sin(latRad) * sin(decRad) +
        cos(latRad) * cos(decRad) * cos(haRad),
  );
  final elevation = elevationRad * 180.0 / pi;

  final azimuthRad = atan2(
    sin(haRad),
    cos(haRad) * sin(latRad) - tan(decRad) * cos(latRad),
  );
  double azimuth = (azimuthRad * 180.0 / pi + 180.0) % 360.0;

  return SunPosition(elevation: elevation, azimuth: azimuth);
}

Map<String, String> calculateShadow({
  required double height,
  required double lat,
  required double lon,
  required DateTime dt,
}) {
  final pos = calculateSunPosition(lat: lat, lon: lon, dt: dt);

  if (pos.elevation <= 0) {
    return {'error': 'The sun is below the horizon at this time'};
  }

  final shadowLength = height / tan(pos.elevation * pi / 180.0);
  final direction = getDirection(pos.azimuth);

  return {
    'shadowLength': shadowLength.toStringAsFixed(2),
    'direction': direction,
    'elevation': pos.elevation.toStringAsFixed(1),
    'azimuth': pos.azimuth.toStringAsFixed(1),
  };
}

List<Map<String, String>> generateTimeComparison({
  required double height,
  required double lat,
  required double lon,
  required DateTime date,
}) {
  final List<Map<String, String>> times = [];

  for (int hour = 6; hour <= 18; hour++) {
    final dt = DateTime(date.year, date.month, date.day, hour, 0);
    final pos = calculateSunPosition(lat: lat, lon: lon, dt: dt);
    if (pos.elevation > 0) {
      final shadowLength = height / tan(pos.elevation * pi / 180.0);
      times.add({
        'time': dt.hour.toString().padLeft(2, '0') + ':00',
        'shadowLength': shadowLength.toStringAsFixed(2),
        'direction': getDirection(pos.azimuth),
        'elevation': pos.elevation.toStringAsFixed(1),
      });
    }
  }

  return times;
}
