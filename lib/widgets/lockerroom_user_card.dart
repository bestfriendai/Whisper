import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user.dart';
import '../theme_lockerroom.dart';

class LockerRoomUserCard extends StatefulWidget {
  final AppUser user;
  final VoidCallback? onTap;
  final VoidCallback? onFollow;
  final VoidCallback? onMessage;
  final bool isFollowing;
  final bool showStats;
  final bool isCompact;

  const LockerRoomUserCard({
    super.key,
    required this.user,
    this.onTap,
    this.onFollow,
    this.onMessage,
    this.isFollowing = false,
    this.showStats = true,
    this.isCompact = false,
  });

  @override
  State<LockerRoomUserCard> createState() => _LockerRoomUserCardState();
}

class _LockerRoomUserCardState extends State<LockerRoomUserCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _followController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _followScaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _followController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
    
    _followScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _followController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _followController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCompact ? _buildCompactCard(context) : _buildFullCard(context);
  }

  Widget _buildFullCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: _isHovered
                      ? LockerRoomColors.championshipGradient
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            isDark 
                                ? LockerRoomColors.neutral800
                                : Colors.white,
                            isDark 
                                ? LockerRoomColors.neutral700.withOpacity(0.9)
                                : Colors.white.withOpacity(0.95),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered
                        ? LockerRoomColors.championshipGold.withOpacity(0.6)
                        : isDark 
                            ? LockerRoomColors.neutral600.withOpacity(0.3)
                            : LockerRoomColors.neutral200.withOpacity(0.5),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? LockerRoomColors.shadowSpotlight
                          : LockerRoomColors.shadowStadium,
                      blurRadius: _isHovered ? 24 : 12,
                      offset: Offset(0, _isHovered ? 12 : 6),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile section with sports ring
                    _buildProfileSection(context),
                    
                    const SizedBox(height: 20),
                    
                    // User info
                    _buildUserInfo(context),
                    
                    const SizedBox(height: 16),
                    
                    // Bio section
                    if (widget.user.bio != null && widget.user.bio!.isNotEmpty) ...[
                      _buildBioSection(context),
                      const SizedBox(height: 16),
                    ],
                    
                    // Sports stats
                    if (widget.showStats) ...[
                      _buildSportsStats(context),
                      const SizedBox(height: 20),
                    ],
                    
                    // Action buttons
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: _isHovered
                    ? LockerRoomColors.teamSpiritGradient
                    : LinearGradient(
                        colors: [
                          isDark ? LockerRoomColors.neutral800 : Colors.white,
                          isDark ? LockerRoomColors.neutral800 : Colors.white,
                        ],
                      ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered
                      ? LockerRoomColors.championshipGold.withOpacity(0.5)
                      : isDark 
                          ? LockerRoomColors.neutral600
                          : LockerRoomColors.neutral200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? LockerRoomColors.shadowField
                        : LockerRoomColors.shadowStadium,
                    blurRadius: _isHovered ? 16 : 8,
                    offset: Offset(0, _isHovered ? 8 : 4),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar with ring
                  _buildAvatarWithRing(),
                  
                  const SizedBox(width: 16),
                  
                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.user.displayName ?? widget.user.username ?? 'Unknown',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: _isHovered 
                                      ? Colors.white 
                                      : theme.colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.user.isPremium) ...[
                              const SizedBox(width: 8),
                              _buildChampionBadge(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (widget.user.age != null)
                          Text(
                            '${widget.user.age} • ${widget.user.location.city}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _isHovered 
                                  ? Colors.white.withOpacity(0.8)
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 8),
                        _buildCompactStats(context),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Quick actions
                  _buildQuickActions(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Championship ring background
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LockerRoomColors.victoryGradient,
            boxShadow: [
              BoxShadow(
                color: LockerRoomColors.championshipGold.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        
        // Avatar
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: LockerRoomColors.neutral600,
            backgroundImage: widget.user.profileImageUrl != null
                ? CachedNetworkImageProvider(widget.user.profileImageUrl!)
                : null,
            child: widget.user.profileImageUrl == null
                ? Icon(
                    Icons.sports_basketball,
                    size: 32,
                    color: LockerRoomColors.championshipGold,
                  )
                : null,
          ),
        ),
        
        // Level badge
        Positioned(
          bottom: 0,
          right: 8,
          child: _buildLevelBadge(),
        ),
        
        // Premium crown
        if (widget.user.isPremium)
          Positioned(
            top: 0,
            child: _buildPremiumCrown(),
          ),
      ],
    );
  }

  Widget _buildAvatarWithRing() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Championship ring
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LockerRoomColors.championshipGradient,
          ),
        ),
        
        // Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: LockerRoomColors.neutral600,
            backgroundImage: widget.user.profileImageUrl != null
                ? CachedNetworkImageProvider(widget.user.profileImageUrl!)
                : null,
            child: widget.user.profileImageUrl == null
                ? Icon(
                    Icons.sports_basketball,
                    size: 20,
                    color: LockerRoomColors.championshipGold,
                  )
                : null,
          ),
        ),
        
        // Level indicator
        if (widget.user.stats.level > 1)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: LockerRoomColors.championshipGold,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: LockerRoomColors.shadowSpotlight,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${widget.user.stats.level}',
                style: const TextStyle(
                  color: LockerRoomColors.scoreboardBlack,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                widget.user.displayName ?? widget.user.username ?? 'Unknown',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: _isHovered 
                      ? Colors.white 
                      : theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.user.isPremium) ...[
              const SizedBox(width: 8),
              _buildChampionBadge(),
            ],
          ],
        ),
        
        const SizedBox(height: 8),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.user.age != null) ...[
              _buildInfoChip(
                '${widget.user.age}',
                Icons.cake_outlined,
                LockerRoomColors.info,
              ),
              const SizedBox(width: 8),
            ],
            _buildInfoChip(
              widget.user.location.city,
              Icons.location_on_outlined,
              LockerRoomColors.athleticGreen,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBioSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isHovered
            ? Colors.white.withOpacity(0.1)
            : LockerRoomColors.neutral700.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isHovered
              ? Colors.white.withOpacity(0.2)
              : LockerRoomColors.neutral600.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        widget.user.bio!,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: _isHovered 
              ? Colors.white.withOpacity(0.9)
              : theme.colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSportsStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          '${widget.user.stats.reviewsPosted}',
          'Reviews',
          Icons.rate_review_outlined,
          LockerRoomColors.basketballOrange,
        ),
        _buildStatDivider(),
        _buildStatItem(
          '${widget.user.stats.likesReceived}',
          'Likes',
          Icons.favorite_outline,
          LockerRoomColors.defeat,
        ),
        _buildStatDivider(),
        _buildStatItem(
          '${widget.user.stats.reputation.toInt()}',
          'Rep',
          Icons.sports_esports,
          LockerRoomColors.championshipGold,
        ),
      ],
    );
  }

  Widget _buildCompactStats(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        _buildMiniStat(
          '${widget.user.stats.reviewsPosted}',
          Icons.rate_review_outlined,
          LockerRoomColors.basketballOrange,
        ),
        const SizedBox(width: 12),
        _buildMiniStat(
          '${widget.user.stats.likesReceived}',
          Icons.favorite_outline,
          LockerRoomColors.defeat,
        ),
        const SizedBox(width: 12),
        _buildMiniStat(
          '${widget.user.stats.reputation.toInt()}',
          Icons.sports_esports,
          LockerRoomColors.championshipGold,
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: _isHovered 
                ? Colors.white 
                : theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: _isHovered 
                ? Colors.white.withOpacity(0.8)
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String value, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: _isHovered
          ? Colors.white.withOpacity(0.3)
          : LockerRoomColors.neutral600.withOpacity(0.3),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            'Follow',
            widget.isFollowing ? Icons.person_remove : Icons.person_add,
            widget.isFollowing 
                ? LockerRoomColors.neutral600
                : LockerRoomColors.athleticGreen,
            widget.onFollow,
            isPrimary: !widget.isFollowing,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            'Message',
            Icons.chat_bubble_outline,
            LockerRoomColors.info,
            widget.onMessage,
            isPrimary: false,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _followController,
          builder: (context, child) {
            return Transform.scale(
              scale: _followScaleAnimation.value,
              child: _buildIconButton(
                widget.isFollowing ? Icons.person_remove : Icons.person_add,
                widget.isFollowing 
                    ? LockerRoomColors.neutral600
                    : LockerRoomColors.athleticGreen,
                () => _handleFollow(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildIconButton(
          Icons.chat_bubble_outline,
          LockerRoomColors.info,
          widget.onMessage,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback? onPressed,
    {bool isPrimary = true}
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isPrimary ? LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ) : null,
          color: isPrimary ? null : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary ? Colors.transparent : color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: isPrimary ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary ? Colors.white : color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isPrimary ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LockerRoomColors.victoryGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: LockerRoomColors.championshipGold.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'LV ${widget.user.stats.level}',
        style: const TextStyle(
          color: LockerRoomColors.scoreboardBlack,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPremiumCrown() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: LockerRoomColors.victoryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: LockerRoomColors.championshipGold.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.military_tech,
        size: 16,
        color: LockerRoomColors.scoreboardBlack,
      ),
    );
  }

  Widget _buildChampionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LockerRoomColors.victoryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: LockerRoomColors.championshipGold.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            size: 12,
            color: LockerRoomColors.scoreboardBlack,
          ),
          const SizedBox(width: 4),
          Text(
            'PRO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: LockerRoomColors.scoreboardBlack,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _onHover(bool isHovered) {
    if (isHovered != _isHovered) {
      setState(() {
        _isHovered = isHovered;
      });
      
      if (isHovered) {
        _hoverController.forward();
      } else {
        _hoverController.reverse();
      }
    }
  }

  void _handleFollow() {
    _followController.forward().then((_) {
      _followController.reverse();
    });
    widget.onFollow?.call();
  }
}