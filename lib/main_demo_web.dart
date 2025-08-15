import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lockerroomtalk/theme_modern.dart';
import 'package:lockerroomtalk/providers/app_state_provider.dart';
import 'package:lockerroomtalk/models/user.dart';
import 'package:lockerroomtalk/services/demo_data_service.dart';
import 'package:lockerroomtalk/screens/home/home_feed_screen.dart';
import 'package:lockerroomtalk/screens/search/search_screen.dart';
import 'package:lockerroomtalk/screens/profile/profile_screen.dart';
import 'package:lockerroomtalk/screens/chat/chat_rooms_screen.dart';
import 'package:lockerroomtalk/screens/create/create_review_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = AppStateProvider();
            // Initialize as guest for demo
            provider.continueAsGuest();
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'LockerRoom Talk',
        debugShowCheckedModeBanner: false,
        theme: ModernTheme.lightTheme,
        darkTheme: ModernTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const DemoAppShell(),
      ),
    );
  }
}

class DemoAppShell extends StatefulWidget {
  const DemoAppShell({super.key});

  @override
  State<DemoAppShell> createState() => _DemoAppShellState();
}

class _DemoAppShellState extends State<DemoAppShell> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = const [
    HomeFeedScreen(),
    SearchScreen(), 
    CreateReviewScreen(),
    ChatRoomsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        height: 72,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface.withOpacity(0.98),
              theme.colorScheme.surface.withOpacity(0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 32,
              offset: const Offset(0, 16),
              spreadRadius: -8,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
                isActive: _currentIndex == 0,
              ),
              _buildNavItem(
                icon: Icons.search_rounded,
                label: 'Search',
                index: 1,
                isActive: _currentIndex == 1,
              ),
              _buildActionButton(),
              _buildNavItem(
                icon: Icons.chat_bubble_rounded,
                label: 'Chat',
                index: 3,
                isActive: _currentIndex == 3,
              ),
              _buildNavItem(
                icon: Icons.account_circle_rounded,
                label: 'Profile',
                index: 4,
                isActive: _currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(isActive ? 8 : 6),
                decoration: BoxDecoration(
                  gradient: isActive ? ModernColors.primaryGradient : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: isActive ? 22 : 20,
                  color: isActive
                      ? Colors.white
                      : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: isActive ? 10 : 9,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? ModernColors.primary
                      : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = 2;
          });
          _pageController.animateToPage(
            2,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: ModernColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ModernColors.primary.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}