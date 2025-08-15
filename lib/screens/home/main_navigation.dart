import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lockerroomtalk/theme.dart';
import 'package:lockerroomtalk/providers/app_state_provider.dart';
import 'package:lockerroomtalk/screens/home/home_feed_screen.dart';
import 'package:lockerroomtalk/screens/create/create_review_screen.dart';
import 'package:lockerroomtalk/screens/chat/chat_rooms_screen.dart';
import 'package:lockerroomtalk/screens/search/search_screen.dart';
import 'package:lockerroomtalk/screens/profile/profile_screen.dart';
import 'package:lockerroomtalk/screens/guest/guest_profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> 
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;
  
  List<Widget> _getPages(bool isGuest) => isGuest 
    ? [
        const HomeFeedScreen(),
        const SearchScreen(),
        const ChatRoomsScreen(),
        const GuestProfileScreen(),
      ]
    : [
        const HomeFeedScreen(),
        const SearchScreen(),
        const CreateReviewScreen(),
        const ChatRoomsScreen(),
        const ProfileScreen(),
      ];

  List<NavItem> _getNavigationItems(bool isGuest) => isGuest
    ? [
        NavItem(
          icon: Icons.home_rounded,
          label: 'Home',
        ),
        NavItem(
          icon: Icons.search_rounded,
          label: 'Search',
        ),
        NavItem(
          icon: Icons.chat_bubble_rounded,
          label: 'Chat',
          badgeCount: 3,
        ),
        NavItem(
          icon: Icons.account_circle_rounded,
          label: 'Account',
        ),
      ]
    : [
        NavItem(
          icon: Icons.home_rounded,
          label: 'Home',
        ),
        NavItem(
          icon: Icons.search_rounded,
          label: 'Search',
        ),
        NavItem(
          icon: Icons.add_rounded,
          label: 'Create',
          isAction: true,
        ),
        NavItem(
          icon: Icons.chat_bubble_rounded,
          label: 'Chat',
          badgeCount: 2,
        ),
        NavItem(
          icon: Icons.account_circle_rounded,
          label: 'Profile',
        ),
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    // Enhanced haptic feedback based on interaction type
    final items = _getNavigationItems(!context.read<AppStateProvider>().isGuest);
    if (items[index].isAction) {
      HapticFeedback.mediumImpact(); // Stronger feedback for action button
      _fabAnimationController.forward().then((_) {
        _fabAnimationController.reverse();
      });
    } else {
      HapticFeedback.selectionClick(); // Subtle feedback for navigation
    }
    
    if (index == _currentIndex) {
      // Double-tap effect - scroll to top or refresh
      HapticFeedback.lightImpact();
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );

    context.read<AppStateProvider>().setCurrentNavIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final theme = Theme.of(context);
        final isGuest = appState.isGuest;
        final pages = _getPages(isGuest);
        final navigationItems = _getNavigationItems(isGuest);
        
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBody: true,
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              appState.setCurrentNavIndex(index);
            },
            children: pages,
          ),
          bottomNavigationBar: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.surface.withValues(alpha: 0.98),
                  theme.colorScheme.surface.withValues(alpha: 0.95),
                  theme.colorScheme.surface.withValues(alpha: 0.92),
                ],
                stops: [0.0, 0.5, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: theme.brightness == Brightness.dark 
                    ? AppColors.ultraGlassStroke.withValues(alpha: 0.4)
                    : AppColors.glassStroke.withValues(alpha: 0.3),
                width: 0.8,
              ),
              boxShadow: [
                // Primary elevated shadow
                BoxShadow(
                  color: theme.brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: 0.6)
                      : Colors.black.withValues(alpha: 0.12),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: -8,
                ),
                // Secondary ambient shadow
                BoxShadow(
                  color: theme.brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
                // Subtle highlight
                BoxShadow(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.white.withValues(alpha: 0.9),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                ),
                // Neon accent glow
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 60,
                  offset: const Offset(0, 4),
                  spreadRadius: -12,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.ultraGlassBg.withValues(alpha: 0.6),
                      AppColors.ultraGlassBg.withValues(alpha: 0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                children: navigationItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isActive = index == _currentIndex;
                  
                  return Expanded(
                    child: _buildNavItem(
                      item: item,
                      index: index,
                      isActive: isActive,
                      onTap: () => _onTabTapped(index),
                    ),
                  );
                }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required NavItem item,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item.isAction)
              AnimatedBuilder(
                animation: _fabAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fabScaleAnimation.value,
                    child: Transform.rotate(
                      angle: _fabRotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: AppColors.meshGradient1,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: -2,
                            ),
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 40,
                              offset: const Offset(0, 16),
                              spreadRadius: -8,
                            ),
                            BoxShadow(
                              color: AppColors.neonGlassBg,
                              blurRadius: 60,
                              offset: const Offset(0, 4),
                              spreadRadius: -10,
                            ),
                          ],
                        ),
                        child: Icon(
                          item.icon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                },
              )
            else
              _buildRegularIcon(item, isActive),
            
            if (!item.isAction) ...[
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: isActive ? 12 : 11,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                  letterSpacing: isActive ? 0.3 : 0.1,
                  height: 1.2,
                ),
                child: Text(item.label),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRegularIcon(NavItem item, bool isActive) {
    final theme = Theme.of(context);
    
    Widget iconWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(isActive ? 12 : 10),
      decoration: BoxDecoration(
        gradient: isActive 
            ? AppColors.primaryGradient.scale(0.3)
            : null,
        color: !isActive ? Colors.transparent : null,
        borderRadius: BorderRadius.circular(18),
        border: isActive ? Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ) : null,
        boxShadow: isActive ? [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ] : null,
      ),
      child: Icon(
        item.icon,
        size: isActive ? 24 : 22,
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
      ),
    );

    // Add badge if needed
    if (item.badgeCount > 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                item.badgeCount > 99 ? '99+' : '${item.badgeCount}',
                style: TextStyle(
                  color: theme.colorScheme.onError,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return iconWidget;
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final bool isAction;
  final int badgeCount;

  NavItem({
    required this.icon,
    required this.label,
    this.isAction = false,
    this.badgeCount = 0,
  });
}