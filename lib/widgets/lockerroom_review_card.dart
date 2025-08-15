import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../screens/reviews/review_detail_screen.dart';
import '../theme_lockerroom.dart';

class LockerRoomReviewCard extends StatefulWidget {
  final Review review;
  final AppUser? author;
  final ViewType viewType;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onUserTap;

  const LockerRoomReviewCard({
    super.key,
    required this.review,
    this.author,
    required this.viewType,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onUserTap,
  });

  @override
  State<LockerRoomReviewCard> createState() => _LockerRoomReviewCardState();
}

class _LockerRoomReviewCardState extends State<LockerRoomReviewCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _likeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _likeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.viewType == ViewType.masonry || widget.viewType == ViewType.grid
        ? _buildCompactCard(context)
        : _buildListCard(context);
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
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap ?? () => _showReviewDetails(context),
              child: Container(
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
                                ? LockerRoomColors.neutral700.withOpacity(0.8)
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
                    // Primary shadow with sports field glow
                    BoxShadow(
                      color: _isHovered
                          ? LockerRoomColors.championshipGold.withOpacity(0.3)
                          : LockerRoomColors.shadowStadium,
                      blurRadius: _isHovered ? 20 : 12,
                      offset: Offset(0, _isHovered ? 8 : 4),
                      spreadRadius: _isHovered ? 0 : -2,
                    ),
                    // Stadium lighting effect
                    if (_isHovered)
                      BoxShadow(
                        color: LockerRoomColors.shadowSpotlight,
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                        spreadRadius: -10,
                      ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image section with sports overlay
                    if (widget.review.imageUrls.isNotEmpty)
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: _getRandomAspectRatio(widget.review.id),
                            child: CachedNetworkImage(
                              imageUrl: widget.review.imageUrls.first,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  gradient: LockerRoomColors.fieldGradient,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.sports_basketball,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 32,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  gradient: LockerRoomColors.courtGradient,
                                ),
                                child: Icon(
                                  Icons.sports_volleyball,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          // Championship rating badge
                          Positioned(
                            top: 16,
                            right: 16,
                            child: _buildChampionshipRatingBadge(),
                          ),
                          // Activity type tag
                          Positioned(
                            top: 16,
                            left: 16,
                            child: _buildActivityTag(),
                          ),
                          // Image count indicator
                          if (widget.review.imageUrls.length > 1)
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: _buildImageCountIndicator(),
                            ),
                        ],
                      ),
                    
                    // Content section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User info row
                          _buildUserInfoRow(context),
                          
                          const SizedBox(height: 16),
                          
                          // Title with sports styling
                          Text(
                            widget.review.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: _isHovered 
                                  ? Colors.white 
                                  : theme.colorScheme.onSurface,
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Content preview
                          Text(
                            widget.review.content,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _isHovered 
                                  ? Colors.white.withOpacity(0.9)
                                  : theme.colorScheme.onSurfaceVariant,
                              height: 1.4,
                              letterSpacing: 0.1,
                            ),
                            maxLines: _getContentLines(widget.review.content),
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Sports flags section
                          if (widget.review.greenFlags.isNotEmpty || widget.review.redFlags.isNotEmpty)
                            _buildFlagsSection(),
                          
                          const SizedBox(height: 16),
                          
                          // Action buttons with sports icons
                          _buildSportsActionRow(context),
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

  Widget _buildListCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient: _isHovered
                  ? LockerRoomColors.teamSpiritGradient
                  : LinearGradient(
                      colors: [
                        isDark ? LockerRoomColors.neutral800 : Colors.white,
                        isDark ? LockerRoomColors.neutral800 : Colors.white,
                      ],
                    ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered
                    ? LockerRoomColors.championshipGold.withOpacity(0.6)
                    : isDark 
                        ? LockerRoomColors.neutral600
                        : LockerRoomColors.neutral200,
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? LockerRoomColors.shadowSpotlight
                      : LockerRoomColors.shadowStadium,
                  blurRadius: _isHovered ? 24 : 8,
                  offset: Offset(0, _isHovered ? 12 : 4),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: InkWell(
              onTap: widget.onTap ?? () => _showReviewDetails(context),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with user info and stats
                    Row(
                      children: [
                        _buildUserInfoRow(context),
                        const Spacer(),
                        _buildChampionshipRatingBadge(),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Title
                    Text(
                      widget.review.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: _isHovered 
                            ? Colors.white 
                            : theme.colorScheme.onSurface,
                        letterSpacing: -0.6,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Activity and time info
                    Row(
                      children: [
                        _buildActivityTag(),
                        const SizedBox(width: 12),
                        _buildTimeLocationBadge(context),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Content
                    Text(
                      widget.review.content,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: _isHovered 
                            ? Colors.white.withOpacity(0.9)
                            : theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Sports flags
                    if (widget.review.greenFlags.isNotEmpty || widget.review.redFlags.isNotEmpty)
                      _buildFlagsSection(),
                    
                    const SizedBox(height: 20),
                    
                    // Image carousel preview
                    if (widget.review.imageUrls.isNotEmpty) ...[
                      _buildImageCarouselPreview(),
                      const SizedBox(height: 20),
                    ],
                    
                    // Action bar
                    _buildSportsActionRow(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoRow(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: widget.onUserTap,
      child: Row(
        children: [
          // Avatar with sports ring
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LockerRoomColors.championshipGradient,
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: LockerRoomColors.neutral600,
              backgroundImage: widget.author?.profileImageUrl != null
                  ? CachedNetworkImageProvider(widget.author!.profileImageUrl!)
                  : null,
              child: widget.author?.profileImageUrl == null
                  ? Icon(
                      Icons.sports_basketball,
                      size: 18,
                      color: LockerRoomColors.championshipGold,
                    )
                  : null,
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.author?.displayName ?? widget.author?.username ?? 'Anonymous',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _isHovered 
                            ? Colors.white 
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    if (widget.author?.isPremium == true) ...[
                      const SizedBox(width: 6),
                      _buildVerificationBadge(),
                    ],
                  ],
                ),
                Text(
                  _formatTimeAgo(widget.review.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _isHovered 
                        ? Colors.white.withOpacity(0.8)
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChampionshipRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LockerRoomColors.victoryGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: LockerRoomColors.championshipGold.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getRatingIcon(widget.review.rating),
            size: 16,
            color: LockerRoomColors.scoreboardBlack,
          ),
          const SizedBox(width: 6),
          Text(
            '${widget.review.rating}.0',
            style: const TextStyle(
              color: LockerRoomColors.scoreboardBlack,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTag() {
    final activityColors = _getActivityColors(widget.review.relationshipType);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: activityColors['color']!.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: activityColors['color']!.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            activityColors['icon'] as IconData,
            size: 14,
            color: activityColors['color'] as Color,
          ),
          const SizedBox(width: 6),
          Text(
            _getActivityLabel(widget.review.relationshipType),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: activityColors['color'] as Color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLocationBadge(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: LockerRoomColors.neutral600.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 12,
            color: _isHovered 
                ? Colors.white.withOpacity(0.8)
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.review.location.city} • ${_formatTimeAgo(widget.review.createdAt)}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _isHovered 
                  ? Colors.white.withOpacity(0.8)
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: LockerRoomColors.verified,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        size: 10,
        color: Colors.white,
      ),
    );
  }

  Widget _buildImageCountIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.photo_library_outlined,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.review.imageUrls.length}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.review.greenFlags.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.review.greenFlags.take(3).map((flag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: LockerRoomColors.victory.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: LockerRoomColors.victory.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      flag.emoji,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      flag.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: LockerRoomColors.victory,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
        if (widget.review.redFlags.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.review.redFlags.take(2).map((flag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: LockerRoomColors.defeat.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: LockerRoomColors.defeat.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      flag.emoji,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      flag.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: LockerRoomColors.defeat,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildImageCarouselPreview() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.review.imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: index < widget.review.imageUrls.length - 1 ? 12 : 0),
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: LockerRoomColors.shadowField,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.review.imageUrls[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    gradient: LockerRoomColors.fieldGradient,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.sports_basketball,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSportsActionRow(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        _buildSportsActionButton(
          context,
          Icons.favorite_border_rounded,
          '${widget.review.stats.likes}',
          LockerRoomColors.defeat,
          () => _handleLike(),
        ),
        const SizedBox(width: 16),
        _buildSportsActionButton(
          context,
          Icons.chat_bubble_outline_rounded,
          '${widget.review.stats.comments}',
          LockerRoomColors.info,
          widget.onComment,
        ),
        const SizedBox(width: 16),
        _buildSportsActionButton(
          context,
          Icons.share_outlined,
          'Share',
          LockerRoomColors.athleticGreen,
          widget.onShare,
        ),
        const Spacer(),
        if (widget.review.wouldRecommend)
          _buildRecommendBadge(),
      ],
    );
  }

  Widget _buildSportsActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback? onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
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
      ),
    );
  }

  Widget _buildRecommendBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LockerRoomColors.victoryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: LockerRoomColors.victory.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.thumb_up,
            size: 14,
            color: LockerRoomColors.scoreboardBlack,
          ),
          const SizedBox(width: 6),
          Text(
            'MVP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
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

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    
    if (_isLiked) {
      _likeController.forward().then((_) {
        _likeController.reverse();
      });
    }
    
    widget.onLike?.call();
  }

  IconData _getRatingIcon(int rating) {
    switch (rating) {
      case 5:
        return Icons.sports_basketball;
      case 4:
        return Icons.sports_soccer;
      case 3:
        return Icons.sports_tennis;
      case 2:
        return Icons.sports_volleyball;
      case 1:
        return Icons.sports_football;
      default:
        return Icons.star;
    }
  }

  Map<String, dynamic> _getActivityColors(RelationshipType type) {
    switch (type) {
      case RelationshipType.workout:
        return {
          'color': LockerRoomColors.trackRed,
          'icon': Icons.fitness_center,
        };
      case RelationshipType.training:
        return {
          'color': LockerRoomColors.athleticGreen,
          'icon': Icons.sports_martial_arts,
        };
      case RelationshipType.game:
        return {
          'color': LockerRoomColors.basketballOrange,
          'icon': Icons.sports_basketball,
        };
      case RelationshipType.casual:
        return {
          'color': LockerRoomColors.swimBlue,
          'icon': Icons.sports_tennis,
        };
    }
  }

  String _getActivityLabel(RelationshipType type) {
    switch (type) {
      case RelationshipType.workout:
        return 'WORKOUT';
      case RelationshipType.training:
        return 'TRAINING';
      case RelationshipType.game:
        return 'GAME';
      case RelationshipType.casual:
        return 'CASUAL';
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 7) {
      return DateFormat('MMM d').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  double _getRandomAspectRatio(String reviewId) {
    final hash = reviewId.hashCode.abs();
    final ratios = [0.8, 1.0, 1.2, 1.3, 1.5];
    return ratios[hash % ratios.length];
  }

  int _getContentLines(String content) {
    if (content.length < 80) return 2;
    if (content.length < 160) return 3;
    return 4;
  }

  void _showReviewDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewDetailScreen(review: widget.review),
      ),
    );
  }
}