const int _kConsoleWidth = 79;

abstract class LogHelper {
  static String parseTableContent(Map<String, String> map) {
    int columnWidth = (_kConsoleWidth ~/ 2) - 3;

    String body = _spiteContent(map, columnWidth).map((entry) {
      if (entry.length != 2) return '';

      return '| ${entry[0].padRight(columnWidth)} | ${(entry[1]).padRight(columnWidth)} |';
    }).join('\n');

    String content = '\n';
    content += '+${''.padRight(columnWidth + 2, '-')}+'
        '${''.padRight(columnWidth + 2, '-')}+\n';
    content += body;
    content += '\n+${''.padRight(columnWidth + 2, '-')}+'
        '${''.padRight(columnWidth + 2, '-')}+';

    return content;
  }

  static String getHeader() {
    int columnWidth = _kConsoleWidth - 2;
    return '+${''.padRight(columnWidth, '-')}+';
  }

  static String parseTableHeader(String title) {
    int columnWidth = _kConsoleWidth - 2;

    return '|${' $title'.padRight(columnWidth, ' ')}|';
  }

  static List<List<String>> _spiteContent(
    Map<String, String> map,
    int columnWidth,
  ) {
    List<List<String>> content = [];

    map.forEach((key, value) {
      List<String> values = _splitContent(value, columnWidth);

      for (int i = 0; i < values.length; i++) {
        if (i == 0) {
          content.add([key.trim(), values[i]]);
        } else {
          content.add(['', values[i]]);
        }
      }
    });

    return content;
  }

  static List<String> _splitContent(String content, int columnWidth) {
    return RegExp('.{1,$columnWidth}')
        .allMatches(content.trim())
        .map((m) => m.group(0) ?? '')
        .toList();
  }
}
