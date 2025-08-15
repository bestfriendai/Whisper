import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:lockerroomtalk/firebase_options.dart';
import 'package:lockerroomtalk/theme_modern.dart' as modern_theme;
import 'package:lockerroomtalk/screens/auth/modern_sign_in_screen.dart';
import 'package:lockerroomtalk/screens/modern_app_shell.dart';
import 'package:lockerroomtalk/providers/app_state_provider.dart';
import 'package:lockerroomtalk/services/auth_service.dart';
import 'package:lockerroomtalk/services/demo_mode_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize demo mode first
  await DemoModeService.initialize();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization failed, using demo mode: $e');
    DemoModeService.enableDemoMode();
  }
  
  runApp(const LockerRoomTalkApp());
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
            title: 'LockerRoom Talk',
            debugShowCheckedModeBanner: false,
            theme: modern_theme.ModernTheme.lightTheme,
            darkTheme: modern_theme.ModernTheme.darkTheme,
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const ModernAuthWrapper(),
          );
        },
      ),
    );
  }
}

class ModernAuthWrapper extends StatelessWidget {
  const ModernAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If user is signed in, show main app
        if (snapshot.hasData || DemoModeService.isDemoMode) {
          return const ModernAppShell();
        }

        // Otherwise show sign in screen
        return const ModernSignInScreen();
      },
    );
  }
}