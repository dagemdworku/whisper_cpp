abstract class TimestampHelper {
  static String fromInt(int t, {bool comma = false}) {
    int msec = t * 10;
    int hr = msec ~/ (1000 * 60 * 60);
    msec = msec - hr * (1000 * 60 * 60);
    int min = msec ~/ (1000 * 60);
    msec = msec - min * (1000 * 60);
    int sec = msec ~/ 1000;
    msec = msec - sec * 1000;

    String separator = comma ? ',' : '.';
    String timestamp = '${hr.toString().padLeft(2, '0')}:'
        '${min.toString().padLeft(2, '0')}:'
        '${sec.toString().padLeft(2, '0')}$separator${msec.toString().padLeft(3, '0')}';

    return timestamp;
  }
}
