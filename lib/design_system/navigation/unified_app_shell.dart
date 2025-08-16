import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../components/components.dart';
import '../../providers/app_state_provider.dart';
import '../../screens/home/optimized_home_feed.dart';
import '../../screens/explore/explore_screen.dart';
import '../../screens/create/create_review_screen_modern.dart';
import '../../screens/chat/chat_list_screen.dart';
import '../../screens/profile/profile_screen_modern.dart';
import '../../screens/auth/modern_auth_screen.dart';

/// Unified App Shell with Consistent Navigation
/// 
/// Provides a clean, accessible navigation experience using the design system.
/// Replaces multiple inconsistent app shell implementations.
class UnifiedAppShell extends StatefulWidget {
  const UnifiedAppShell({super.key});

  @override
  State<UnifiedAppShell> createState() => _UnifiedAppShellState();
}

class _UnifiedAppShellState extends State<UnifiedAppShell> 
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _tabAnimationController;
  late Animation<double> _tabAnimation;

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore_rounded),
      label: 'Explore',
    ),
    NavigationDestination(
      icon: Icon(Icons.add_circle_outline),
      selectedIcon: Icon(Icons.add_circle_rounded),
      label: 'Create',
    ),
    NavigationDestination(
      icon: Icon(Icons.chat_bubble_outline),
      selectedIcon: Icon(Icons.chat_bubble_rounded),
      label: 'Chats',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'Profile',
    ),
  ];

  final List<Widget> _screens = const [
    OptimizedHomeFeed(),
    ExploreScreen(),
    CreateReviewScreenModern(),
    ChatListScreen(),
    ProfileScreenModern(),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _tabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _tabAnimation = CurvedAnimation(
      parent: _tabAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _tabAnimationController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    final appState = context.read<AppStateProvider>();
    
    // Check guest restrictions for create and chat features
    if (appState.isGuest && _isRestrictedFeature(index)) {
      _showGuestUpgradeModal();
      return;
    }

    // Provide haptic feedback
    HapticFeedback.lightImpact();
    
    // Animate tab change
    _tabAnimationController.forward().then((_) {
      _tabAnimationController.reverse();
    });
    
    setState(() {
      _currentIndex = index;
    });
  }

  bool _isRestrictedFeature(int index) {
    // Create (index 2) and Chat (index 3) require authentication
    return index == 2 || index == 3;
  }

  void _showGuestUpgradeModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildGuestUpgradeModal(),
    );
  }

  Widget _buildGuestUpgradeModal() {
    return Container(
      padding: EdgeInsets.only(
        left: DS.lg,
        right: DS.lg,
        top: DS.xl,
        bottom: DS.xl + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(DS.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: DS.neutral300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          SizedBox(height: DS.xl),
          
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: DesignTokens.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          SizedBox(height: DS.lg),
          
          // Title
          Text(
            'Join Locker Room Talk',
            style: DesignTokens.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: DS.md),
          
          // Description
          Text(
            'Create reviews, join conversations, and connect with the community. It\'s free and takes less than a minute.',
            style: DesignTokens.textTheme.bodyLarge?.copyWith(
              color: DS.neutral600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: DS.xl),
          
          // Benefits list
          _buildBenefitItem(Icons.edit_rounded, 'Write and share reviews'),
          SizedBox(height: DS.md),
          _buildBenefitItem(Icons.chat_rounded, 'Join community discussions'),
          SizedBox(height: DS.md),
          _buildBenefitItem(Icons.notifications_rounded, 'Get personalized updates'),
          
          SizedBox(height: DS.xl),
          
          // Action buttons
          PrimaryButton(
            text: 'Sign Up Free',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ModernAuthScreen(),
                ),
                (route) => false,
              );
            },
            size: ButtonSize.large,
          ),
          
          SizedBox(height: DS.md),
          
          GhostButton(
            text: 'Maybe later',
            onPressed: () => Navigator.pop(context),
            size: ButtonSize.medium,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: DS.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 14,
            color: DS.success,
          ),
        ),
        SizedBox(width: DS.md),
        Expanded(
          child: Text(
            text,
            style: DesignTokens.textTheme.bodyMedium?.copyWith(
              color: DS.neutral700,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _tabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_tabAnimation.value * 0.02),
            child: _screens[_currentIndex],
          );
        },
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    final appState = context.watch<AppStateProvider>();
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onDestinationSelected,
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: DS.primary.withOpacity(0.1),
          destinations: _destinations.asMap().entries.map((entry) {
            final index = entry.key;
            final destination = entry.value;
            final isRestricted = appState.isGuest && _isRestrictedFeature(index);
            
            return NavigationDestination(
              icon: Stack(
                children: [
                  destination.icon,
                  if (isRestricted)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: DS.warning,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock,
                          size: 8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  // Chat notification badge
                  if (index == 3 && !appState.isGuest)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: DS.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '3',
                          style: DesignTokens.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              selectedIcon: destination.selectedIcon,
              label: destination.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Navigation helper for managing routes and deep linking
class NavigationHelper {
  static const String homeRoute = '/home';
  static const String exploreRoute = '/explore';
  static const String createRoute = '/create';
  static const String chatRoute = '/chat';
  static const String profileRoute = '/profile';
  
  static int getIndexFromRoute(String route) {
    switch (route) {
      case homeRoute:
        return 0;
      case exploreRoute:
        return 1;
      case createRoute:
        return 2;
      case chatRoute:
        return 3;
      case profileRoute:
        return 4;
      default:
        return 0;
    }
  }
  
  static String getRouteFromIndex(int index) {
    switch (index) {
      case 0:
        return homeRoute;
      case 1:
        return exploreRoute;
      case 2:
        return createRoute;
      case 3:
        return chatRoute;
      case 4:
        return profileRoute;
      default:
        return homeRoute;
    }
  }
}