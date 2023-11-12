abstract class ConversionHelper {
  static String getMB(double bytes) {
    double megabit = bytes / 1024.0 / 1024.0;
    return megabit.toStringAsFixed(2);
  }

  static String getMS(num microseconds) {
    double milliseconds = microseconds / 1000.0;
    return milliseconds.toStringAsFixed(2);
  }
}
