import 'package:flutter/foundation.dart';

enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment _environment = Environment.development;
  static Map<String, dynamic> _config = {};

  static Environment get environment => _environment;
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;
  static bool get isDebug => kDebugMode;

  static void setEnvironment(Environment env) {
    _environment = env;
    _loadConfig();
  }

  static void _loadConfig() {
    switch (_environment) {
      case Environment.development:
        _config = _developmentConfig;
        break;
      case Environment.staging:
        _config = _stagingConfig;
        break;
      case Environment.production:
        _config = _productionConfig;
        break;
    }
  }

  static String get apiBaseUrl => _config['apiBaseUrl'] ?? '';
  static String get firebaseProjectId => _config['firebaseProjectId'] ?? '';
  static bool get enableCrashlytics => _config['enableCrashlytics'] ?? false;
  static bool get enableAnalytics => _config['enableAnalytics'] ?? false;
  static bool get enableLogging => _config['enableLogging'] ?? true;
  static String get sentryDsn => _config['sentryDsn'] ?? '';
  static int get maxReviewsPerDay => _config['maxReviewsPerDay'] ?? 10;
  static int get maxMessagesPerHour => _config['maxMessagesPerHour'] ?? 100;
  static int get maxLoginAttempts => _config['maxLoginAttempts'] ?? 5;
  static bool get enableContentModeration => _config['enableContentModeration'] ?? true;
  static bool get profanityFilter => _config['profanityFilter'] ?? true;
  static bool get imageModeration => _config['imageModeration'] ?? true;

  static final Map<String, dynamic> _developmentConfig = {
    'apiBaseUrl': 'https://dev-api.whisperdate.com',
    'firebaseProjectId': 'whisperdate-dev',
    'enableCrashlytics': false,
    'enableAnalytics': false,
    'enableLogging': true,
    'sentryDsn': '',
    'maxReviewsPerDay': 100,
    'maxMessagesPerHour': 1000,
    'maxLoginAttempts': 10,
    'enableContentModeration': false,
    'profanityFilter': false,
    'imageModeration': false,
  };

  static final Map<String, dynamic> _stagingConfig = {
    'apiBaseUrl': 'https://staging-api.whisperdate.com',
    'firebaseProjectId': 'whisperdate-staging',
    'enableCrashlytics': true,
    'enableAnalytics': true,
    'enableLogging': true,
    'sentryDsn': 'YOUR_STAGING_SENTRY_DSN',
    'maxReviewsPerDay': 20,
    'maxMessagesPerHour': 200,
    'maxLoginAttempts': 5,
    'enableContentModeration': true,
    'profanityFilter': true,
    'imageModeration': true,
  };

  static final Map<String, dynamic> _productionConfig = {
    'apiBaseUrl': 'https://api.whisperdate.com',
    'firebaseProjectId': 'whisperdate-prod',
    'enableCrashlytics': true,
    'enableAnalytics': true,
    'enableLogging': false,
    'sentryDsn': 'YOUR_PRODUCTION_SENTRY_DSN',
    'maxReviewsPerDay': 10,
    'maxMessagesPerHour': 100,
    'maxLoginAttempts': 5,
    'enableContentModeration': true,
    'profanityFilter': true,
    'imageModeration': true,
  };
}