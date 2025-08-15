import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme_modern.dart';
import '../widgets/notification_badge.dart';
import 'home/modern_home_feed.dart';
import 'discover/modern_discover_screen.dart';
import 'chat/modern_chat_screen.dart';
import 'profile/modern_profile_screen.dart';
import 'reviews/modern_create_review.dart';

class ModernAppShell extends StatefulWidget {
  const ModernAppShell({super.key});

  @override
  State<ModernAppShell> createState() => _ModernAppShellState();
}

class _ModernAppShellState extends State<ModernAppShell>
    with TickerProviderStateMixin {
  
  // Helper function to safely trigger haptic feedback on non-web platforms
  void _triggerHapticFeedback([String type = 'selection']) {
    if (!kIsWeb) {
      try {
        switch (type) {
          case 'medium':
            _triggerHapticFeedback('medium');
            break;
          case 'selection':
          default:
            _triggerHapticFeedback();
            break;
        }
      } catch (e) {
        // Silently ignore haptic feedback errors
      }
    }
  }
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabController;
  late AnimationController _navController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;
  late Animation<Offset> _navSlideAnimation;

  bool _isCreating = false;

  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      hasNotification: false,
    ),
    NavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      label: 'Discover',
      hasNotification: false,
    ),
    NavItem(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Create',
      hasNotification: false,
      isCenter: true,
    ),
    NavItem(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Chat',
      hasNotification: true,
      notificationCount: 3,
    ),
    NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      hasNotification: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    _fabController = AnimationController(
      duration: ModernDuration.normal,
      vsync: this,
    );
    
    _navController = AnimationController(
      duration: ModernDuration.normal,
      vsync: this,
    );
    
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: ModernCurves.bounce,
    ));
    
    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: ModernCurves.easeInOutQuart,
    ));
    
    _navSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _navController,
      curve: ModernCurves.easeOutQuart,
    ));

    // Start navigation animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navController.forward();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabController.dispose();
    _navController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == 2) {
      // Center button - Create action
      _handleCreateAction();
      return;
    }

    setState(() {
      _currentIndex = index;
    });
    
    _pageController.animateToPage(
      index > 2 ? index - 1 : index, // Adjust for missing create page
      duration: ModernDuration.normal,
      curve: ModernCurves.easeInOutQuart,
    );
    
    _triggerHapticFeedback();
  }

  void _handleCreateAction() {
    setState(() {
      _isCreating = true;
    });
    
    _fabController.forward().then((_) {
      _fabController.reverse();
    });
    
    _triggerHapticFeedback('medium');
    
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ModernCreateReview(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          
          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: ModernDuration.normal,
      ),
    ).then((_) {
      setState(() {
        _isCreating = false;
      });
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const ModernHomeFeed();
      case 1:
        return const ModernDiscoverScreen();
      case 2:
        return const ModernChatScreen();
      case 3:
        return const ModernProfileScreen();
      default:
        return const ModernHomeFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safePadding = MediaQuery.of(context).padding;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBody: true,
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index >= 2 ? index + 1 : index;
          });
        },
        itemCount: 4, // Excluding create page
        itemBuilder: (context, index) => _buildPage(index),
      ),
      bottomNavigationBar: SlideTransition(
        position: _navSlideAnimation,
        child: _buildBottomNavigation(theme, safePadding),
      ),
    );
  }

  Widget _buildBottomNavigation(ThemeData theme, EdgeInsets safePadding) {
    return Container(
      height: ModernSpacing.bottomNavHeight + safePadding.bottom,
      padding: EdgeInsets.only(bottom: safePadding.bottom),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ModernRadius.bottomNav),
        ),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ModernRadius.bottomNav),
        ),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: _navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              
              if (item.isCenter) {
                return Expanded(
                  child: _buildCenterFAB(theme),
                );
              }
              
              return Expanded(
                child: _buildNavItem(
                  item,
                  index,
                  _currentIndex == index,
                  theme,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    NavItem item,
    int index,
    bool isActive,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () => _onNavTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: ModernSpacing.bottomNavHeight,
        child: AnimatedContainer(
          duration: ModernDuration.fast,
          curve: ModernCurves.easeOutQuart,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: ModernDuration.fast,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? ModernColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(ModernRadius.md),
                    ),
                    child: Icon(
                      isActive ? item.activeIcon : item.icon,
                      size: 24,
                      color: isActive
                          ? ModernColors.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  
                  // Notification badge
                  if (item.hasNotification)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: NotificationBadge(
                        count: item.notificationCount,
                        size: 16,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 2),
              
              AnimatedDefaultTextStyle(
                duration: ModernDuration.fast,
                style: theme.textTheme.labelSmall!.copyWith(
                  color: isActive
                      ? ModernColors.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterFAB(ThemeData theme) {
    return Container(
      height: ModernSpacing.bottomNavHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_fabScaleAnimation, _fabRotationAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _fabScaleAnimation.value,
                child: Transform.rotate(
                  angle: _fabRotationAnimation.value * 2 * 3.14159,
                  child: GestureDetector(
                    onTap: () => _onNavTap(2),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: ModernColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: ModernColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isCreating ? Icons.close : Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 2),
          
          Text(
            'Create',
            style: theme.textTheme.labelSmall?.copyWith(
              color: ModernColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool hasNotification;
  final int notificationCount;
  final bool isCenter;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.hasNotification = false,
    this.notificationCount = 0,
    this.isCenter = false,
  });
}