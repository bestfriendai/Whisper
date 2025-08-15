import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/user.dart';
import '../../models/review.dart';
import '../../theme_modern.dart';
import '../../widgets/modern_review_card.dart';
import '../../services/auth_service.dart';
import '../../services/review_service.dart';
import '../settings/settings_screen.dart';

class ModernProfileScreen extends StatefulWidget {
  final String? userId;
  
  const ModernProfileScreen({
    super.key,
    this.userId,
  });

  @override
  State<ModernProfileScreen> createState() => _ModernProfileScreenState();
}

class _ModernProfileScreenState extends State<ModernProfileScreen>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final ReviewService _reviewService = ReviewService();
  
  late TabController _tabController;
  late AnimationController _headerController;
  late AnimationController _statsController;
  late Animation<double> _headerAnimation;
  late Animation<double> _statsAnimation;
  
  AppUser? _user;
  List<Review> _userReviews = [];
  bool _isLoading = true;
  bool _isOwnProfile = true;
  bool _isFollowing = false;
  
  final List<String> _tabLabels = ['Posts', 'Reviews', 'About'];

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 3, vsync: this);
    
    _headerController = AnimationController(
      duration: ModernDuration.normal,
      vsync: this,
    );
    
    _statsController = AnimationController(
      duration: ModernDuration.slow,
      vsync: this,
    );
    
    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: ModernCurves.easeOutQuart,
    ));
    
    _statsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _statsController,
      curve: ModernCurves.spring,
    ));
    
    _loadProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _headerController.dispose();
    _statsController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      final isOwn = widget.userId == null || widget.userId == currentUser?.id;
      
      AppUser? user;
      if (isOwn && currentUser != null) {
        user = currentUser;
      } else if (widget.userId != null) {
        // Load other user's profile
        // user = await _userService.getUserById(widget.userId!);
      }
      
      List<Review> reviews = [];
      if (user != null) {
        reviews = await _reviewService.getUserReviews(user.id);
      }
      
      if (mounted) {
        setState(() {
          _user = user;
          _userReviews = reviews;
          _isOwnProfile = isOwn;
          _isLoading = false;
        });
        
        _headerController.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          _statsController.forward();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onFollowTap() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    HapticFeedback.lightImpact();
  }

  void _onEditProfile() {
    HapticFeedback.selectionClick();
    // Navigate to edit profile
  }

  void _onSettings() {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safePadding = MediaQuery.of(context).padding;
    
    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_user == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: const Center(
          child: Text('User not found'),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildAppBar(theme, safePadding),
            _buildProfileHeader(theme),
            _buildStatsRow(theme),
            _buildActionButtons(theme),
            _buildTabBar(theme),
          ];
        },
        body: _buildTabContent(theme),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme, EdgeInsets safePadding) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.background.withOpacity(0.95),
      surfaceTintColor: Colors.transparent,
      title: AnimatedBuilder(
        animation: _headerAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _headerAnimation.value,
            child: Text(
              _user?.displayName ?? _user?.username ?? 'Profile',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        },
      ),
      actions: [
        if (_isOwnProfile)
          IconButton(
            onPressed: _onSettings,
            icon: Icon(
              Icons.settings_outlined,
              color: theme.colorScheme.onBackground,
            ),
          )
        else
          IconButton(
            onPressed: () {
              // More options
            },
            icon: Icon(
              Icons.more_vert,
              color: theme.colorScheme.onBackground,
            ),
          ),
      ],
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _headerAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _headerAnimation.value)),
            child: Opacity(
              opacity: _headerAnimation.value,
              child: Padding(
                padding: const EdgeInsets.all(ModernSpacing.lg),
                child: Row(
                  children: [
                    // Profile picture
                    Container(
                      decoration: BoxDecoration(
                        gradient: _user!.isPremium
                            ? ModernColors.instagramGradient
                            : null,
                        borderRadius: BorderRadius.circular(50),
                        border: !_user!.isPremium
                            ? Border.all(
                                color: theme.colorScheme.outline.withOpacity(0.2),
                                width: 2,
                              )
                            : null,
                      ),
                      padding: EdgeInsets.all(_user!.isPremium ? 3 : 0),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(
                            _user!.isPremium ? 47 : 44,
                          ),
                          border: _user!.isPremium
                              ? Border.all(
                                  color: theme.colorScheme.surface,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            _user!.isPremium ? 44 : 44,
                          ),
                          child: _user!.profileImageUrl != null
                              ? Image.network(
                                  _user!.profileImageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.person,
                                  size: 40,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: ModernSpacing.lg),
                    
                    // Name and info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _user!.displayName ?? _user!.username ?? 'User',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (_user!.isPremium) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: ModernColors.instagramGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'PRO',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          
                          if (_user!.username != null &&
                              _user!.username != _user!.displayName) ...[
                            const SizedBox(height: 2),
                            Text(
                              '@${_user!.username}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          
                          if (_user!.bio != null) ...[
                            const SizedBox(height: ModernSpacing.sm),
                            Text(
                              _user!.bio!,
                              style: theme.textTheme.bodyMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          
                          const SizedBox(height: ModernSpacing.xs),
                          
                          // Location
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_user!.location.city}, ${_user!.location.state}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _statsAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 30 * (1 - _statsAnimation.value)),
            child: Opacity(
              opacity: _statsAnimation.value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: ModernSpacing.lg),
                padding: const EdgeInsets.all(ModernSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(ModernRadius.card),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                  boxShadow: ModernShadows.small,
                ),
                child: Row(
                  children: [
                    _buildStatItem(
                      'Reviews',
                      _user!.stats.reviewsPosted.toString(),
                      theme,
                    ),
                    _buildStatDivider(theme),
                    _buildStatItem(
                      'Likes',
                      _user!.stats.likesReceived.toString(),
                      theme,
                    ),
                    _buildStatDivider(theme),
                    _buildStatItem(
                      'Level',
                      _user!.stats.level.toString(),
                      theme,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, ThemeData theme) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider(ThemeData theme) {
    return Container(
      width: 1,
      height: 40,
      color: theme.colorScheme.outline.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: ModernSpacing.sm),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(ModernSpacing.lg),
        child: Row(
          children: [
            if (_isOwnProfile) ...[
              Expanded(
                child: _buildButton(
                  'Edit Profile',
                  isPrimary: false,
                  onTap: _onEditProfile,
                  theme: theme,
                ),
              ),
            ] else ...[
              Expanded(
                child: _buildButton(
                  _isFollowing ? 'Following' : 'Follow',
                  isPrimary: !_isFollowing,
                  onTap: _onFollowTap,
                  theme: theme,
                ),
              ),
              const SizedBox(width: ModernSpacing.sm),
              _buildIconButton(
                Icons.message_outlined,
                onTap: () {
                  // Navigate to chat
                },
                theme: theme,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    String text, {
    required bool isPrimary,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          gradient: isPrimary ? ModernColors.primaryGradient : null,
          color: isPrimary ? null : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(ModernRadius.button),
          border: isPrimary
              ? null
              : Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isPrimary
                  ? Colors.white
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon, {
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(ModernRadius.button),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        child: Container(
          color: theme.colorScheme.background,
          child: TabBar(
            controller: _tabController,
            indicatorColor: ModernColors.primary,
            indicatorWeight: 3,
            labelColor: ModernColors.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            labelStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(ThemeData theme) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildPostsTab(theme),
        _buildReviewsTab(theme),
        _buildAboutTab(theme),
      ],
    );
  }

  Widget _buildPostsTab(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(ModernSpacing.md),
      itemCount: _userReviews.length,
      itemBuilder: (context, index) {
        final review = _userReviews[index];
        return Container(
          margin: const EdgeInsets.only(bottom: ModernSpacing.md),
          child: ModernReviewCard(
            review: review,
            viewType: ViewType.list,
            showUserInfo: false,
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.all(ModernSpacing.sm),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: ModernSpacing.sm,
        mainAxisSpacing: ModernSpacing.sm,
      ),
      itemCount: _userReviews.length,
      itemBuilder: (context, index) {
        final review = _userReviews[index];
        return ModernReviewCard(
          review: review,
          viewType: ViewType.masonry,
          showUserInfo: false,
        );
      },
    );
  }

  Widget _buildAboutTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(ModernSpacing.lg),
      children: [
        _buildInfoSection(
          'Account Info',
          [
            _buildInfoRow('Username', '@${_user!.username}', theme),
            _buildInfoRow('Member since', 'January 2024', theme),
            _buildInfoRow('Location', '${_user!.location.city}, ${_user!.location.state}', theme),
          ],
          theme,
        ),
        
        const SizedBox(height: ModernSpacing.lg),
        
        _buildInfoSection(
          'Preferences',
          [
            _buildInfoRow('Looking for', _user!.datingPreference.join(', '), theme),
            _buildInfoRow('Age range', '${_user!.age ?? 'Unknown'}', theme),
          ],
          theme,
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(ModernSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(ModernRadius.card),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: ModernSpacing.md),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ModernSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom delegate for pinned tab bar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}