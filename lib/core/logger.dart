import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:lockerroomtalk/config/environment_config.dart';

enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  critical,
}

class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();

  static const String _name = 'WhisperDate';
  final List<LogEntry> _logHistory = [];
  final int _maxHistorySize = 1000;

  void log(
    String message, {
    LogLevel level = LogLevel.info,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    if (!_shouldLog(level)) return;

    final logEntry = LogEntry(
      message: message,
      level: level,
      timestamp: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );

    _addToHistory(logEntry);
    _printLog(logEntry);
    _sendToRemote(logEntry);
  }

  void verbose(String message, {Map<String, dynamic>? extra}) {
    log(message, level: LogLevel.verbose, extra: extra);
  }

  void debug(String message, {Map<String, dynamic>? extra}) {
    log(message, level: LogLevel.debug, extra: extra);
  }

  void info(String message, {Map<String, dynamic>? extra}) {
    log(message, level: LogLevel.info, extra: extra);
  }

  void warning(String message, {Map<String, dynamic>? extra}) {
    log(message, level: LogLevel.warning, extra: extra);
  }

  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    log(
      message,
      level: LogLevel.error,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  void critical(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    log(
      message,
      level: LogLevel.critical,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  bool _shouldLog(LogLevel level) {
    if (!EnvironmentConfig.enableLogging && !kDebugMode) {
      return false;
    }

    if (EnvironmentConfig.isProduction) {
      return level.index >= LogLevel.warning.index;
    }

    return true;
  }

  void _addToHistory(LogEntry entry) {
    _logHistory.add(entry);
    if (_logHistory.length > _maxHistorySize) {
      _logHistory.removeAt(0);
    }
  }

  void _printLog(LogEntry entry) {
    if (!kDebugMode && !EnvironmentConfig.isDevelopment) return;

    final colorCode = _getColorCode(entry.level);
    final resetCode = '\x1B[0m';
    final levelStr = entry.level.toString().split('.').last.toUpperCase();
    final timestamp = entry.timestamp.toIso8601String();

    String logMessage = '$colorCode[$levelStr] $timestamp - ${entry.message}$resetCode';

    if (entry.error != null) {
      logMessage += '\nError: ${entry.error}';
    }

    if (entry.extra != null && entry.extra!.isNotEmpty) {
      logMessage += '\nExtra: ${entry.extra}';
    }

    developer.log(
      logMessage,
      name: _name,
      error: entry.error,
      stackTrace: entry.stackTrace,
      level: _getLogLevel(entry.level),
    );

    if (entry.stackTrace != null && (entry.level == LogLevel.error || entry.level == LogLevel.critical)) {
      debugPrintStack(stackTrace: entry.stackTrace, label: entry.message);
    }
  }

  String _getColorCode(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return '\x1B[37m'; // White
      case LogLevel.debug:
        return '\x1B[36m'; // Cyan
      case LogLevel.info:
        return '\x1B[32m'; // Green
      case LogLevel.warning:
        return '\x1B[33m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m'; // Red
      case LogLevel.critical:
        return '\x1B[35m'; // Magenta
    }
  }

  int _getLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return 300;
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.critical:
        return 1200;
    }
  }

  void _sendToRemote(LogEntry entry) {
    if (!EnvironmentConfig.enableCrashlytics) return;
    if (entry.level.index < LogLevel.warning.index) return;

    // TODO: Implement remote logging (Sentry, Crashlytics, etc.)
    // This would send logs to your remote logging service
  }

  List<LogEntry> getHistory({LogLevel? minLevel}) {
    if (minLevel == null) {
      return List.unmodifiable(_logHistory);
    }
    return List.unmodifiable(
      _logHistory.where((entry) => entry.level.index >= minLevel.index),
    );
  }

  void clearHistory() {
    _logHistory.clear();
  }

  String exportLogs() {
    final buffer = StringBuffer();
    for (final entry in _logHistory) {
      buffer.writeln(entry.toString());
    }
    return buffer.toString();
  }
}

class LogEntry {
  final String message;
  final LogLevel level;
  final DateTime timestamp;
  final dynamic error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? extra;

  LogEntry({
    required this.message,
    required this.level,
    required this.timestamp,
    this.error,
    this.stackTrace,
    this.extra,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    final levelStr = level.toString().split('.').last.toUpperCase();
    buffer.write('[$levelStr] ${timestamp.toIso8601String()} - $message');
    
    if (error != null) {
      buffer.write(' | Error: $error');
    }
    
    if (extra != null && extra!.isNotEmpty) {
      buffer.write(' | Extra: $extra');
    }
    
    return buffer.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'level': level.toString(),
      'timestamp': timestamp.toIso8601String(),
      'error': error?.toString(),
      'stackTrace': stackTrace?.toString(),
      'extra': extra,
    };
  }
}

final logger = Logger();