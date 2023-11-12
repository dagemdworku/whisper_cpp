const int _kConsoleWidth = 79;

abstract class LogHelper {
  static String parseTableContent(Map<String, String> map) {
    int columnWidth = (_kConsoleWidth ~/ 2) - 3;

    String body = map.entries.map((entry) {
      return '| ${entry.key.padRight(columnWidth)} | ${(entry.value).padRight(columnWidth)} |';
    }).join('\n');

    String content = '\n';
    content += '+${''.padRight(columnWidth + 2, '-')}+'
        '${''.padRight(columnWidth + 2, '-')}+\n';
    content += body;
    content += '\n+${''.padRight(columnWidth + 2, '-')}+'
        '${''.padRight(columnWidth + 2, '-')}+';

    return content;
  }
}
