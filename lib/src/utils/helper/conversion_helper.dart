abstract class ConversionHelper {
  static String getMB(double bytes) {
    double megabit = bytes / 1024.0 / 1024.0;
    return megabit.toStringAsFixed(2);
  }
}
