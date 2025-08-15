import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:lockerroomtalk/firebase_options.dart';
import 'package:lockerroomtalk/theme/modern_theme.dart';
import 'package:lockerroomtalk/screens/auth/auth_wrapper.dart';
import 'package:lockerroomtalk/screens/settings/settings_screen.dart';
import 'package:lockerroomtalk/screens/notifications/notifications_screen.dart';
import 'package:lockerroomtalk/screens/profile/edit_profile_screen.dart';
import 'package:lockerroomtalk/screens/comments/comments_screen.dart';
import 'package:lockerroomtalk/screens/reviews/review_detail_screen.dart';
import 'package:lockerroomtalk/models/review.dart';
import 'package:lockerroomtalk/models/user.dart';
import 'package:lockerroomtalk/providers/app_state_provider.dart';
import 'package:lockerroomtalk/services/review_service.dart';
import 'package:lockerroomtalk/services/analytics_service.dart';
import 'package:lockerroomtalk/config/environment_config.dart';
import 'package:lockerroomtalk/core/logger.dart';
import 'package:lockerroomtalk/core/error_handler.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set environment based on build mode
    const String environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );
    
    switch (environment) {
      case 'production':
        EnvironmentConfig.setEnvironment(Environment.production);
        break;
      case 'staging':
        EnvironmentConfig.setEnvironment(Environment.staging);
        break;
      default:
        EnvironmentConfig.setEnvironment(Environment.development);
    }
    
    logger.info('Starting WhisperDate in ${EnvironmentConfig.environment} mode');
    
    // Initialize Firebase
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      logger.info('Firebase initialized successfully');
    } catch (e, stackTrace) {
      logger.critical(
        'Firebase initialization failed',
        error: e,
        stackTrace: stackTrace,
      );
      // In production, you might want to show an error screen instead
      if (EnvironmentConfig.isProduction) {
        runApp(const ErrorApp());
        return;
      }
    }
    
    // Initialize Analytics
    try {
      await analytics.initialize();
      analytics.logEvent(AnalyticsEvent.appOpened);
    } catch (e) {
      logger.error('Analytics initialization failed', error: e);
    }
    
    // Set up global error handlers
    FlutterError.onError = (FlutterErrorDetails details) {
      logger.error(
        'Flutter error',
        error: details.exception,
        stackTrace: details.stack,
        extra: {
          'library': details.library,
          'context': details.context?.toString(),
        },
      );
      
      analytics.logError(
        'Flutter error',
        error: details.exception,
        stackTrace: details.stack,
        fatal: false,
      );
    };
    
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    runApp(const LockerRoomTalkApp());
  }, (error, stack) {
    logger.critical(
      'Unhandled error in app',
      error: error,
      stackTrace: stack,
    );
    
    analytics.logError(
      'Unhandled error',
      error: error,
      stackTrace: stack,
      fatal: true,
    );
  });
}

// Error app shown when critical initialization fails
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade700,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Unable to start WhisperDate',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Restart the app
                    SystemNavigator.pop();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LockerRoomTalkApp extends StatelessWidget {
  const LockerRoomTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Locker Room Talk',
            debugShowCheckedModeBanner: false,
            theme: ModernTheme.lightTheme,
            darkTheme: ModernTheme.darkTheme,
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AuthWrapper(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
              '/notifications': (context) => const NotificationsScreen(),
              '/profile/edit': (context) => const EditProfileScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name?.startsWith('/review/') == true) {
                // Extract review ID from route
                final reviewId = settings.name!.split('/').last;
                return MaterialPageRoute(
                  builder: (context) => FutureBuilder<Review?>(
                    future: ReviewService().getReview(reviewId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Scaffold(
                          body: Center(child: Text('Review not found')),
                        );
                      }
                      return ReviewDetailScreen(review: snapshot.data!);
                    },
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
  
  Review _createMockReview(String id) {
    // Mock review for demo purposes
    return Review(
      id: id,
      authorId: 'author_1',
      subjectName: 'Alex Martinez',
      subjectAge: 26,
      subjectGender: Gender.other,
      category: DatingPreference.men,
      dateDuration: DateDuration.twoToThreeHours,
      dateYear: 2024,
      relationshipType: RelationshipType.casual,
      title: 'Great coffee date experience!',
      content: 'Had an amazing time at the new coffee shop downtown. Great conversation and really nice atmosphere.',
      rating: 5,
      wouldRecommend: true,
      location: Location(
        city: 'Fort Washington',
        state: 'MD',
        country: 'US',
        coords: Coordinates(lat: 38.7073, lng: -77.0365),
      ),
      stats: ReviewStats(likes: 15, comments: 8, views: 120),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    );
  }
}
