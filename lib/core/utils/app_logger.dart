import 'dart:developer' as developer;

enum LogLevel { debug, info, warn, error }

class AppLogger {
  static LogLevel minLevel = LogLevel.debug;

  static void _log(LogLevel level, String message, {Object? data, String? tag}) {
    if (level.index < minLevel.index) return;
    final prefix = switch (level) {
      LogLevel.debug => '🐛',
      LogLevel.info => 'ℹ️',
      LogLevel.warn => '⚠️',
      LogLevel.error => '❌',
    };
    final line = [
      prefix,
      if (tag != null) '[$tag]',
      message,
      if (data != null) '=> ${_short(data)}',
    ].join(' ');
    developer.log(line, name: tag ?? 'app');
  }

  static String _short(Object data) {
    final s = data.toString();
    return s.length > 180 ? s.substring(0, 180) + '…' : s;
  }

  static void d(String msg, {Object? data, String? tag}) => _log(LogLevel.debug, msg, data: data, tag: tag);
  static void i(String msg, {Object? data, String? tag}) => _log(LogLevel.info, msg, data: data, tag: tag);
  static void w(String msg, {Object? data, String? tag}) => _log(LogLevel.warn, msg, data: data, tag: tag);
  static void e(String msg, {Object? data, String? tag}) => _log(LogLevel.error, msg, data: data, tag: tag);
}
