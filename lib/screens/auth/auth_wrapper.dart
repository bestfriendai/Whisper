import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lockerroomtalk/providers/app_state_provider.dart';
import 'package:lockerroomtalk/screens/auth/modern_auth_screen.dart';
import 'package:lockerroomtalk/screens/onboarding/onboarding_flow.dart';
import 'package:lockerroomtalk/screens/app_shell.dart';
import 'package:lockerroomtalk/widgets/enhanced_loading.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        if (appState.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check guest mode first
        if (appState.isGuest) {
          return const AppShell();
        }
        
        // Then check authentication
        if (appState.isAuthenticated) {
          // Check if user has completed onboarding
          if (appState.currentUser?.username?.isNotEmpty == true) {
            return const AppShell();
          } else {
            return const OnboardingFlow();
          }
        }
        
        // Default to auth screen
        return const ModernAuthScreen();
      },
    );
  }
}