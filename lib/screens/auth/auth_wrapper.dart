import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperdate/providers/app_state_provider.dart';
import 'package:whisperdate/screens/auth/modern_auth_screen.dart';
import 'package:whisperdate/screens/onboarding/onboarding_flow.dart';
import 'package:whisperdate/screens/app_shell.dart';
import 'package:whisperdate/widgets/enhanced_loading.dart';

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