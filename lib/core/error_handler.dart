import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whisperdate/core/logger.dart';

class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final ErrorType type;
  final ErrorSeverity severity;
  final Map<String, dynamic>? metadata;

  AppError({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
    this.type = ErrorType.unknown,
    this.severity = ErrorSeverity.medium,
    this.metadata,
  });

  @override
  String toString() => 'AppError: $message (code: $code, type: $type)';

  String get userMessage {
    switch (type) {
      case ErrorType.network:
        return 'Network error. Please check your connection and try again.';
      case ErrorType.authentication:
        return 'Authentication failed. Please sign in again.';
      case ErrorType.permission:
        return 'You don\'t have permission to perform this action.';
      case ErrorType.validation:
        return message;
      case ErrorType.server:
        return 'Server error. Please try again later.';
      case ErrorType.notFound:
        return 'The requested resource was not found.';
      case ErrorType.rateLimit:
        return 'Too many requests. Please slow down.';
      case ErrorType.maintenance:
        return 'The app is under maintenance. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}

enum ErrorType {
  network,
  authentication,
  permission,
  validation,
  server,
  notFound,
  rateLimit,
  maintenance,
  unknown,
}

enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  final List<ErrorCallback> _errorCallbacks = [];
  final Map<String, DateTime> _errorThrottleMap = {};
  final Duration _throttleDuration = const Duration(seconds: 5);

  void registerErrorCallback(ErrorCallback callback) {
    _errorCallbacks.add(callback);
  }

  void unregisterErrorCallback(ErrorCallback callback) {
    _errorCallbacks.remove(callback);
  }

  Future<T?> handleError<T>(
    Future<T> Function() operation, {
    String? context,
    bool showUserMessage = true,
    VoidCallback? onRetry,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      final appError = _parseError(error, stackTrace);
      
      if (!_shouldThrottle(appError.code ?? appError.message)) {
        _logError(appError, context);
        
        if (showUserMessage) {
          _showErrorToUser(appError, onRetry);
        }
        
        _notifyCallbacks(appError);
      }
      
      return null;
    }
  }

  T? handleSyncError<T>(
    T Function() operation, {
    String? context,
    bool showUserMessage = true,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      final appError = _parseError(error, stackTrace);
      
      if (!_shouldThrottle(appError.code ?? appError.message)) {
        _logError(appError, context);
        
        if (showUserMessage) {
          _showErrorToUser(appError, null);
        }
        
        _notifyCallbacks(appError);
      }
      
      return null;
    }
  }

  AppError _parseError(dynamic error, StackTrace? stackTrace) {
    if (error is AppError) {
      return error;
    }

    if (error is PlatformException) {
      return AppError(
        message: error.message ?? 'Platform error occurred',
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
        type: _getErrorTypeFromCode(error.code),
        severity: ErrorSeverity.medium,
      );
    }

    if (error is FormatException) {
      return AppError(
        message: 'Invalid data format',
        originalError: error,
        stackTrace: stackTrace,
        type: ErrorType.validation,
        severity: ErrorSeverity.low,
      );
    }

    if (error is TypeError) {
      return AppError(
        message: 'Type error in application',
        originalError: error,
        stackTrace: stackTrace,
        type: ErrorType.unknown,
        severity: ErrorSeverity.high,
      );
    }

    String message = 'Unknown error occurred';
    if (error != null) {
      message = error.toString();
    }

    return AppError(
      message: message,
      originalError: error,
      stackTrace: stackTrace,
      type: ErrorType.unknown,
      severity: ErrorSeverity.medium,
    );
  }

  ErrorType _getErrorTypeFromCode(String code) {
    if (code.contains('network') || code.contains('connection')) {
      return ErrorType.network;
    }
    if (code.contains('auth') || code.contains('sign')) {
      return ErrorType.authentication;
    }
    if (code.contains('permission') || code.contains('denied')) {
      return ErrorType.permission;
    }
    if (code.contains('not_found') || code.contains('404')) {
      return ErrorType.notFound;
    }
    if (code.contains('rate') || code.contains('limit')) {
      return ErrorType.rateLimit;
    }
    if (code.contains('server') || code.contains('500')) {
      return ErrorType.server;
    }
    return ErrorType.unknown;
  }

  void _logError(AppError error, String? context) {
    final logLevel = _getLogLevel(error.severity);
    final contextStr = context != null ? ' [Context: $context]' : '';
    
    logger.log(
      '${error.message}$contextStr',
      level: logLevel,
      error: error.originalError,
      stackTrace: error.stackTrace,
      extra: {
        'code': error.code,
        'type': error.type.toString(),
        'severity': error.severity.toString(),
        ...?error.metadata,
      },
    );
  }

  LogLevel _getLogLevel(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return LogLevel.warning;
      case ErrorSeverity.medium:
        return LogLevel.error;
      case ErrorSeverity.high:
      case ErrorSeverity.critical:
        return LogLevel.critical;
    }
  }

  bool _shouldThrottle(String key) {
    final now = DateTime.now();
    final lastError = _errorThrottleMap[key];
    
    if (lastError != null && now.difference(lastError) < _throttleDuration) {
      return true;
    }
    
    _errorThrottleMap[key] = now;
    
    // Clean up old entries
    _errorThrottleMap.removeWhere((k, v) => 
      now.difference(v) > const Duration(minutes: 5));
    
    return false;
  }

  void _showErrorToUser(AppError error, VoidCallback? onRetry) {
    // This should be implemented with your UI framework
    // For now, we'll use a simple print statement
    debugPrint('Show to user: ${error.userMessage}');
  }

  void _notifyCallbacks(AppError error) {
    for (final callback in _errorCallbacks) {
      try {
        callback(error);
      } catch (e) {
        debugPrint('Error in error callback: $e');
      }
    }
  }

  static void showErrorSnackBar(BuildContext context, String message, {VoidCallback? onRetry}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static void showErrorDialog(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            if (onRetry != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: const Text('Retry'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDismiss?.call();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

typedef ErrorCallback = void Function(AppError error);

final errorHandler = ErrorHandler();