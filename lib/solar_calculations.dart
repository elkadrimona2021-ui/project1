import 'dart:math';

class SolarCalc {
  static double _degToRad(double d) => d * pi / 180;
  static double _radToDeg(double r) => r * 180 / pi;

  // Simplified solar position (good enough for this app)
  static Map<String, double> getSolarData(
      DateTime date, double lat, double lon) {
    final double hour = date.hour + date.minute / 60;
    final double decl = 23.45 *
        sin(_degToRad(360 * (284 + date.dayOfYear) / 365));
    final double ha = (hour - 12) * 15;

    double elevation = _radToDeg(asin(
      sin(_degToRad(lat)) * sin(_degToRad(decl)) +
          cos(_degToRad(lat)) *
              cos(_degToRad(decl)) *
              cos(_degToRad(ha)),
    ));

    double azimuth = _radToDeg(acos(
      (sin(_degToRad(decl)) -
              sin(_degToRad(elevation)) * sin(_degToRad(lat))) /
          (cos(_degToRad(elevation)) * cos(_degToRad(lat))),
    ));

    if (hour > 12) azimuth = 360 - azimuth;

    return {"elevation": elevation, "azimuth": azimuth};
  }

  static double shadowLength(double height, double elevationDeg) {
    if (elevationDeg <= 0) return double.infinity;
    return height / tan(_degToRad(elevationDeg));
  }

  static String azimuthToDirection(double a) {
    if (a < 22.5) return "N";
    if (a < 67.5) return "NE";
    if (a < 112.5) return "E";
    if (a < 157.5) return "SE";
    if (a < 202.5) return "S";
    if (a < 247.5) return "SW";
    if (a < 292.5) return "W";
    if (a < 337.5) return "NW";
    return "N";
  }
}

extension DayOfYear on DateTime {
  int get dayOfYear => int.parse(format("D"));
  String format(String fmt) =>
      DateTime(year, month, day).difference(DateTime(year)).inDays.toString();
}
