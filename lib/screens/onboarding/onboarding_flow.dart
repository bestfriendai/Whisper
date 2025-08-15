import 'package:flutter/material.dart';
import 'package:whisperdate/screens/onboarding/welcome_screen.dart';
import 'package:whisperdate/screens/onboarding/location_screen.dart';
import 'package:whisperdate/screens/onboarding/username_screen.dart';
import 'package:whisperdate/screens/home/main_navigation.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    const WelcomeScreen(),
    const LocationScreen(),
    const UsernameScreen(),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: OnboardingProvider(
        currentPage: _currentPage,
        totalPages: _pages.length,
        nextPage: _nextPage,
        previousPage: _previousPage,
        completeOnboarding: _completeOnboarding,
        child: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: _pages,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingProvider extends InheritedWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final VoidCallback completeOnboarding;

  const OnboardingProvider({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.nextPage,
    required this.previousPage,
    required this.completeOnboarding,
    required super.child,
  });

  static OnboardingProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<OnboardingProvider>();
  }

  @override
  bool updateShouldNotify(OnboardingProvider oldWidget) {
    return currentPage != oldWidget.currentPage;
  }
}