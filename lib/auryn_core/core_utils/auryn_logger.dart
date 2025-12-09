/// lib/auryn_core/core_utils/auryn_logger.dart
/// Structured logging utility for AURYN Offline.
/// 
/// Provides consistent, production-ready logging with appropriate levels.
/// In production builds, only warnings and errors are logged.
/// Debug and info logs are suppressed to avoid noise.

import 'package:flutter/foundation.dart';

/// Log levels for AURYN
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Centralized logger for AURYN Offline
class AurynLogger {
  static final AurynLogger _instance = AurynLogger._internal();
  factory AurynLogger() => _instance;
  AurynLogger._internal();

  /// Minimum log level to display (configurable)
  /// In release mode, defaults to warning
  /// In debug mode, defaults to debug
  LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.warning;

  /// Sets the minimum log level
  void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Logs a debug message
  /// Only visible in debug builds by default
  void debug(String message, {String? tag, Object? error}) {
    _log(LogLevel.debug, message, tag: tag, error: error);
  }

  /// Logs an info message
  /// Useful for tracking flow and state changes
  void info(String message, {String? tag, Object? error}) {
    _log(LogLevel.info, message, tag: tag, error: error);
  }

  /// Logs a warning message
  /// Indicates potential issues or unexpected states
  void warning(String message, {String? tag, Object? error}) {
    _log(LogLevel.warning, message, tag: tag, error: error);
  }

  /// Logs an error message
  /// Critical issues that need attention
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Internal log method
  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Filter based on minimum level
    if (level.index < _minLevel.index) return;

    final levelStr = _levelToString(level);
    final tagStr = tag != null ? '[$tag] ' : '';
    final timestamp = DateTime.now().toIso8601String();

    // Format: [TIMESTAMP] [LEVEL] [TAG] Message
    final logMessage = '[$timestamp] [$levelStr] $tagStr$message';

    // Use debugPrint to ensure proper output in all environments
    if (kDebugMode || level.index >= LogLevel.warning.index) {
      debugPrint(logMessage);
      
      if (error != null) {
        debugPrint('  Error: $error');
      }
      
      if (stackTrace != null) {
        debugPrint('  Stack trace:\n$stackTrace');
      }
    }
  }

  /// Converts log level to string
  String _levelToString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARN';
      case LogLevel.error:
        return 'ERROR';
    }
  }
}
