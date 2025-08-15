import 'package:flutter/foundation.dart';
import 'package:whisperdate/config/environment_config.dart';
import 'package:whisperdate/core/logger.dart';

enum AnalyticsEvent {
  // Authentication events
  signUp,
  signIn,
  signOut,
  emailVerified,
  passwordReset,
  accountDeleted,
  
  // Profile events
  profileViewed,
  profileEdited,
  profilePhotoUploaded,
  profileVerified,
  
  // Review events
  reviewCreated,
  reviewViewed,
  reviewLiked,
  reviewReported,
  reviewDeleted,
  reviewShared,
  
  // Chat events
  chatStarted,
  messagesSent,
  photoSent,
  chatDeleted,
  userBlocked,
  userUnblocked,
  
  // Search events
  searchPerformed,
  filterApplied,
  searchResultClicked,
  
  // Navigation events
  screenViewed,
  tabChanged,
  deepLinkOpened,
  
  // Engagement events
  appOpened,
  appBackgrounded,
  sessionStarted,
  sessionEnded,
  
  // Premium events
  subscriptionStarted,
  subscriptionCancelled,
  subscriptionRenewed,
  premiumFeatureUsed,
  
  // Error events
  errorOccurred,
  crashReported,
  
  // Performance events
  slowNetworkDetected,
  longLoadTime,
  
  // User behavior
  tutorialStarted,
  tutorialCompleted,
  onboardingCompleted,
  notificationReceived,
  notificationClicked,
  settingsChanged,
}

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  bool _isInitialized = false;
  String? _userId;
  final Map<String, dynamic> _userProperties = {};
  final List<AnalyticsProvider> _providers = [];

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (EnvironmentConfig.enableAnalytics) {
        // Initialize Firebase Analytics
        _providers.add(FirebaseAnalyticsProvider());
        
        // Initialize other analytics providers
        if (EnvironmentConfig.sentryDsn.isNotEmpty) {
          _providers.add(SentryAnalyticsProvider());
        }
        
        // Initialize providers
        for (final provider in _providers) {
          await provider.initialize();
        }
      }
      
      _isInitialized = true;
      logger.info('Analytics service initialized');
    } catch (e, stackTrace) {
      logger.error(
        'Failed to initialize analytics',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void setUserId(String? userId) {
    _userId = userId;
    
    for (final provider in _providers) {
      provider.setUserId(userId);
    }
    
    logger.debug('Analytics user ID set: ${userId != null ? 'User logged in' : 'User logged out'}');
  }

  void setUserProperty(String name, dynamic value) {
    _userProperties[name] = value;
    
    for (final provider in _providers) {
      provider.setUserProperty(name, value);
    }
  }

  void setUserProperties(Map<String, dynamic> properties) {
    _userProperties.addAll(properties);
    
    for (final provider in _providers) {
      for (final entry in properties.entries) {
        provider.setUserProperty(entry.key, entry.value);
      }
    }
  }

  Future<void> logEvent(
    AnalyticsEvent event, {
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized || !EnvironmentConfig.enableAnalytics) {
      return;
    }

    final eventName = _getEventName(event);
    final enrichedParams = _enrichParameters(parameters);
    
    logger.debug('Analytics event: $eventName', extra: enrichedParams);
    
    for (final provider in _providers) {
      try {
        await provider.logEvent(eventName, enrichedParams);
      } catch (e) {
        logger.error('Failed to log event to provider', error: e);
      }
    }
  }

  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    await logEvent(
      AnalyticsEvent.screenViewed,
      parameters: {
        'screen_name': screenName,
        'screen_class': screenClass ?? screenName,
      },
    );
  }

  Future<void> logError(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) async {
    if (!_isInitialized) return;

    final parameters = {
      'message': message,
      'fatal': fatal,
      'error': error?.toString(),
      'stack_trace': stackTrace?.toString(),
    };
    
    await logEvent(AnalyticsEvent.errorOccurred, parameters: parameters);
    
    for (final provider in _providers) {
      try {
        await provider.logError(message, error, stackTrace, fatal);
      } catch (e) {
        logger.error('Failed to log error to provider', error: e);
      }
    }
  }

  Future<void> logPerformance(
    String name,
    Duration duration, {
    Map<String, dynamic>? metrics,
  }) async {
    if (!_isInitialized || !EnvironmentConfig.enableAnalytics) {
      return;
    }

    final parameters = {
      'duration_ms': duration.inMilliseconds,
      'name': name,
      ...?metrics,
    };
    
    if (duration.inSeconds > 3) {
      await logEvent(AnalyticsEvent.longLoadTime, parameters: parameters);
    }
    
    for (final provider in _providers) {
      try {
        await provider.logPerformance(name, duration, metrics);
      } catch (e) {
        logger.error('Failed to log performance to provider', error: e);
      }
    }
  }

  Future<void> startTrace(String name) async {
    for (final provider in _providers) {
      await provider.startTrace(name);
    }
  }

  Future<void> stopTrace(String name) async {
    for (final provider in _providers) {
      await provider.stopTrace(name);
    }
  }

  Map<String, dynamic> _enrichParameters(Map<String, dynamic>? parameters) {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'user_id': _userId,
      'environment': EnvironmentConfig.environment.toString(),
      'platform': defaultTargetPlatform.toString(),
      ...?parameters,
      ..._userProperties,
    };
  }

  String _getEventName(AnalyticsEvent event) {
    return event.toString().split('.').last.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).substring(1);
  }

  // Revenue tracking
  Future<void> logRevenue(
    double amount,
    String currency, {
    String? productId,
    int? quantity,
    Map<String, dynamic>? additionalParams,
  }) async {
    final parameters = {
      'value': amount,
      'currency': currency,
      'product_id': productId,
      'quantity': quantity,
      ...?additionalParams,
    };
    
    await logEvent(AnalyticsEvent.subscriptionStarted, parameters: parameters);
  }

  // A/B Testing
  Future<String?> getExperimentVariant(String experimentId) async {
    // This would integrate with your A/B testing service
    // For now, returning null (control group)
    return null;
  }

  void reset() {
    setUserId(null);
    _userProperties.clear();
    
    for (final provider in _providers) {
      provider.reset();
    }
  }
}

// Analytics Provider Interface
abstract class AnalyticsProvider {
  Future<void> initialize();
  void setUserId(String? userId);
  void setUserProperty(String name, dynamic value);
  Future<void> logEvent(String eventName, Map<String, dynamic> parameters);
  Future<void> logError(String message, dynamic error, StackTrace? stackTrace, bool fatal);
  Future<void> logPerformance(String name, Duration duration, Map<String, dynamic>? metrics);
  Future<void> startTrace(String name);
  Future<void> stopTrace(String name);
  void reset();
}

// Firebase Analytics Provider
class FirebaseAnalyticsProvider implements AnalyticsProvider {
  @override
  Future<void> initialize() async {
    // Initialize Firebase Analytics
    // firebase_analytics package would be used here
  }

  @override
  void setUserId(String? userId) {
    // FirebaseAnalytics.instance.setUserId(userId: userId);
  }

  @override
  void setUserProperty(String name, dynamic value) {
    // FirebaseAnalytics.instance.setUserProperty(name: name, value: value?.toString());
  }

  @override
  Future<void> logEvent(String eventName, Map<String, dynamic> parameters) async {
    // await FirebaseAnalytics.instance.logEvent(name: eventName, parameters: parameters);
  }

  @override
  Future<void> logError(String message, dynamic error, StackTrace? stackTrace, bool fatal) async {
    // Firebase Crashlytics integration
    // FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: fatal);
  }

  @override
  Future<void> logPerformance(String name, Duration duration, Map<String, dynamic>? metrics) async {
    // Firebase Performance Monitoring
    // final trace = FirebasePerformance.instance.newTrace(name);
    // metrics?.forEach((key, value) => trace.setMetric(key, value));
    // await trace.stop();
  }

  @override
  Future<void> startTrace(String name) async {
    // Firebase Performance trace start
  }

  @override
  Future<void> stopTrace(String name) async {
    // Firebase Performance trace stop
  }

  @override
  void reset() {
    // FirebaseAnalytics.instance.resetAnalyticsData();
  }
}

// Sentry Analytics Provider
class SentryAnalyticsProvider implements AnalyticsProvider {
  @override
  Future<void> initialize() async {
    // Initialize Sentry
    // await SentryFlutter.init((options) {
    //   options.dsn = EnvironmentConfig.sentryDsn;
    //   options.environment = EnvironmentConfig.environment.toString();
    // });
  }

  @override
  void setUserId(String? userId) {
    // Sentry.configureScope((scope) => scope.setUser(userId != null ? User(id: userId) : null));
  }

  @override
  void setUserProperty(String name, dynamic value) {
    // Sentry.configureScope((scope) => scope.setExtra(name, value));
  }

  @override
  Future<void> logEvent(String eventName, Map<String, dynamic> parameters) async {
    // Sentry.addBreadcrumb(Breadcrumb(message: eventName, data: parameters));
  }

  @override
  Future<void> logError(String message, dynamic error, StackTrace? stackTrace, bool fatal) async {
    // await Sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  Future<void> logPerformance(String name, Duration duration, Map<String, dynamic>? metrics) async {
    // Sentry performance monitoring
  }

  @override
  Future<void> startTrace(String name) async {
    // Sentry transaction start
  }

  @override
  Future<void> stopTrace(String name) async {
    // Sentry transaction stop
  }

  @override
  void reset() {
    // Sentry.configureScope((scope) => scope.clear());
  }
}

// Singleton instance
final analytics = AnalyticsService();