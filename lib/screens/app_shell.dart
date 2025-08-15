import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lockerroomtalk/theme/modern_theme.dart';
import 'package:lockerroomtalk/providers/app_state_provider.dart';
import 'package:lockerroomtalk/screens/home/modern_home_feed.dart';
import 'package:lockerroomtalk/screens/explore/explore_screen.dart';
import 'package:lockerroomtalk/screens/create/create_review_screen_modern.dart';
import 'package:lockerroomtalk/screens/chat/chat_list_screen.dart';
import 'package:lockerroomtalk/screens/profile/profile_screen_modern.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  final List<Widget> _screens = [
    const ModernHomeFeed(),
    const ExploreScreen(),
    const CreateReviewScreenModern(),
    const ChatListScreen(),
    const ProfileScreenModern(),
  ];

  final List<NavItem> _navItems = [
    NavItem(icon: Icons.home_rounded, label: 'Home'),
    NavItem(icon: Icons.explore_rounded, label: 'Explore'),
    NavItem(icon: Icons.add_circle_rounded, label: 'Create'),
    NavItem(icon: Icons.chat_bubble_rounded, label: 'Chats'),
    NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    final appState = context.read<AppStateProvider>();
    
    // Check if guest and trying to access restricted features
    if (appState.isGuest && (index == 2 || index == 3)) {
      _showGuestRestrictionDialog();
      return;
    }

    HapticFeedback.lightImpact();
    setState(() {
      _currentIndex = index;
    });

    // Animate the selection
    _fabAnimationController.forward().then((_) {
      _fabAnimationController.reverse();
    });
  }

  void _showGuestRestrictionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ModernTheme.primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lock_outline,
                color: ModernTheme.primaryPink,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Sign Up Required'),
          ],
        ),
        content: const Text(
          'Create a free account to:\n• Write reviews\n• Send messages\n• Access all features',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to auth screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/auth',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ModernTheme.primaryPink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
              (index) => _buildNavItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _currentIndex == index;
    final item = _navItems[index];
    final isCreateButton = index == 2;
    final appState = context.watch<AppStateProvider>();
    final isRestricted = appState.isGuest && (index == 2 || index == 3);

    if (isCreateButton) {
      return GestureDetector(
        onTap: () => _onTabSelected(index),
        child: AnimatedBuilder(
          animation: _fabScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected ? _fabScaleAnimation.value : 1.0,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: isRestricted
                      ? LinearGradient(
                          colors: [Colors.grey.shade400, Colors.grey.shade500],
                        )
                      : const LinearGradient(
                          colors: ModernTheme.primaryGradient,
                        ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isRestricted
                          ? Colors.grey.withOpacity(0.3)
                          : ModernTheme.primaryPink.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  isRestricted ? Icons.lock_outline : item.icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            );
          },
        ),
      );
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabSelected(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Stack(
                  children: [
                    Icon(
                      item.icon,
                      color: isSelected
                          ? ModernTheme.primaryPink
                          : Colors.grey.shade400,
                      size: 26,
                    ),
                    if (isRestricted)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade400,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (index == 3 && !appState.isGuest) // Chat badge
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: ModernTheme.error,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '3',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected
                      ? ModernTheme.primaryPink
                      : Colors.grey.shade400,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}