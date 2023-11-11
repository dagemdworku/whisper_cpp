abstract class DoubleHandler {
  static double parse(dynamic value) {
    if (value == null) return double.nan;
    return double.tryParse(value.toString()) ?? double.nan;
  }
}
