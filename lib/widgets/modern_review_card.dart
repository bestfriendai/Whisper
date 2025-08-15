import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/review.dart';
import '../theme_modern.dart';

enum ViewType { masonry, list }

class ModernReviewCard extends StatefulWidget {
  final Review review;
  final ViewType viewType;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final bool isLiked;
  final bool showUserInfo;

  const ModernReviewCard({
    super.key,
    required this.review,
    this.viewType = ViewType.masonry,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.isLiked = false,
    this.showUserInfo = true,
  });

  @override
  State<ModernReviewCard> createState() => _ModernReviewCardState();
}

class _ModernReviewCardState extends State<ModernReviewCard>
    with TickerProviderStateMixin {
  late AnimationController _likeController;
  late AnimationController _hoverController;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _hoverElevationAnimation;
  late Animation<double> _hoverScaleAnimation;
  
  bool _isHovered = false;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    
    _likeController = AnimationController(
      duration: ModernDuration.normal,
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: ModernDuration.fast,
      vsync: this,
    );
    
    _likeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _likeController,
      curve: ModernCurves.bounce,
    ));
    
    _hoverElevationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: ModernCurves.easeOutQuart,
    ));
    
    _hoverScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: ModernCurves.easeOutQuart,
    ));
  }

  @override
  void dispose() {
    _likeController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _onLikeTap() {
    setState(() {
      _isLiked = !_isLiked;
    });
    
    if (_isLiked) {
      _likeController.forward().then((_) {
        _likeController.reverse();
      });
      HapticFeedback.lightImpact();
    }
    
    widget.onLike?.call();
  }

  void _onCardHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: Listenable.merge([_hoverElevationAnimation, _hoverScaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _hoverScaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onCardHover(true),
            onExit: (_) => _onCardHover(false),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onTap?.call();
              },
              child: Container(
                margin: EdgeInsets.only(
                  bottom: widget.viewType == ViewType.list ? ModernSpacing.md : 0,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(ModernRadius.card),
                  border: Border.all(
                    color: _isHovered 
                        ? ModernColors.primary.withOpacity(0.2)
                        : theme.colorScheme.outline.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06 + (_hoverElevationAnimation.value * 0.06)),
                      blurRadius: 8 + (_hoverElevationAnimation.value * 12),
                      offset: Offset(0, 2 + (_hoverElevationAnimation.value * 6)),
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: ModernColors.primary.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ModernRadius.card),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with user info and rating
                      if (widget.showUserInfo) _buildHeader(theme),
                      
                      // Review content
                      _buildContent(theme),
                      
                      // Images if any
                      if (widget.review.imageUrls.isNotEmpty) _buildImages(theme),
                      
                      // Flags section
                      if (widget.review.greenFlags.isNotEmpty || widget.review.redFlags.isNotEmpty)
                        _buildFlags(theme),
                      
                      // Action buttons
                      _buildActions(theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(ModernSpacing.md),
      child: Row(
        children: [
          // Avatar with gradient border
          Container(
            decoration: BoxDecoration(
              gradient: ModernColors.instagramGradient,
              borderRadius: BorderRadius.circular(ModernRadius.avatar),
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(ModernRadius.avatar - 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ModernRadius.avatar - 2),
                child: Icon(
                  Icons.person,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: ModernSpacing.sm),
          
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anonymous Review',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _getTimeAgo(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Rating
          _buildRating(theme),
        ],
      ),
    );
  }

  Widget _buildRating(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ModernSpacing.sm,
        vertical: ModernSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: _getRatingGradient(),
        borderRadius: BorderRadius.circular(ModernRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 2),
          Text(
            widget.review.rating.toString(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ModernSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject info
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ModernSpacing.sm,
              vertical: ModernSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(ModernRadius.sm),
            ),
            child: Text(
              '${widget.review.subjectName}, ${widget.review.subjectAge}',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: ModernSpacing.sm),
          
          // Title
          Text(
            widget.review.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: ModernSpacing.sm),
          
          // Content preview
          Text(
            widget.review.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: widget.viewType == ViewType.list ? 3 : 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildImages(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(ModernSpacing.md),
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ModernRadius.md),
        child: Image.network(
          widget.review.imageUrls.first,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: theme.colorScheme.surfaceVariant,
              child: Icon(
                Icons.image_not_supported_outlined,
                color: theme.colorScheme.onSurfaceVariant,
                size: 40,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: theme.colorScheme.surfaceVariant,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFlags(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ModernSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green flags
          if (widget.review.greenFlags.isNotEmpty) ...[
            Wrap(
              spacing: ModernSpacing.xs,
              runSpacing: ModernSpacing.xs,
              children: widget.review.greenFlags.take(3).map((flag) {
                return _buildFlagChip(flag.name, true, theme);
              }).toList(),
            ),
            const SizedBox(height: ModernSpacing.xs),
          ],
          
          // Red flags
          if (widget.review.redFlags.isNotEmpty) ...[
            Wrap(
              spacing: ModernSpacing.xs,
              runSpacing: ModernSpacing.xs,
              children: widget.review.redFlags.take(3).map((flag) {
                return _buildFlagChip(flag.name, false, theme);
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFlagChip(String text, bool isPositive, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ModernSpacing.sm,
        vertical: ModernSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isPositive
            ? ModernColors.success.withOpacity(0.1)
            : ModernColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ModernRadius.full),
        border: Border.all(
          color: isPositive
              ? ModernColors.success.withOpacity(0.3)
              : ModernColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: isPositive ? ModernColors.success : ModernColors.error,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isPositive ? ModernColors.success : ModernColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(ModernSpacing.md),
      child: Row(
        children: [
          // Like button
          AnimatedBuilder(
            animation: _likeScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _likeScaleAnimation.value,
                child: GestureDetector(
                  onTap: _onLikeTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ModernSpacing.sm,
                      vertical: ModernSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _isLiked
                          ? ModernColors.error.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(ModernRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: _isLiked ? ModernColors.error : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.review.stats.likes + (_isLiked ? 1 : 0)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _isLiked ? ModernColors.error : theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(width: ModernSpacing.md),
          
          // Comment button
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              widget.onComment?.call();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ModernSpacing.sm,
                vertical: ModernSpacing.xs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.review.stats.comments}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // Share button
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              widget.onShare?.call();
            },
            child: Icon(
              Icons.share_outlined,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getRatingGradient() {
    if (widget.review.rating >= 4) {
      return const LinearGradient(
        colors: [ModernColors.success, ModernColors.successDark],
      );
    } else if (widget.review.rating >= 3) {
      return const LinearGradient(
        colors: [ModernColors.warning, ModernColors.warningDark],
      );
    } else {
      return const LinearGradient(
        colors: [ModernColors.error, ModernColors.errorDark],
      );
    }
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(widget.review.createdAt);
    
    if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}

// User card for profile displays
class ModernUserCard extends StatefulWidget {
  final String name;
  final int age;
  final String? location;
  final String? avatarUrl;
  final bool isVerified;
  final bool isOnline;
  final VoidCallback? onTap;
  final bool showStatus;

  const ModernUserCard({
    super.key,
    required this.name,
    required this.age,
    this.location,
    this.avatarUrl,
    this.isVerified = false,
    this.isOnline = false,
    this.onTap,
    this.showStatus = true,
  });

  @override
  State<ModernUserCard> createState() => _ModernUserCardState();
}

class _ModernUserCardState extends State<ModernUserCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: ModernDuration.fast,
      vsync: this,
    );
    
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: ModernCurves.easeOutQuart,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _hoverAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _hoverAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onTap?.call();
              },
              child: Container(
                padding: const EdgeInsets.all(ModernSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(ModernRadius.card),
                  border: Border.all(
                    color: _isHovered 
                        ? ModernColors.primary.withOpacity(0.3)
                        : theme.colorScheme.outline.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: _isHovered ? ModernShadows.medium : ModernShadows.small,
                ),
                child: Row(
                  children: [
                    // Avatar with status
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: widget.isVerified
                                ? ModernColors.instagramGradient
                                : null,
                            borderRadius: BorderRadius.circular(ModernRadius.avatar),
                          ),
                          padding: EdgeInsets.all(widget.isVerified ? 2 : 0),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(
                                ModernRadius.avatar - (widget.isVerified ? 2 : 0),
                              ),
                            ),
                            child: widget.avatarUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      ModernRadius.avatar - (widget.isVerified ? 2 : 0),
                                    ),
                                    child: Image.network(
                                      widget.avatarUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                          ),
                        ),
                        
                        // Online status
                        if (widget.showStatus && widget.isOnline)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: ModernColors.success,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: theme.colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(width: ModernSpacing.md),
                    
                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${widget.name}, ${widget.age}',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.isVerified) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: ModernColors.verified,
                                ),
                              ],
                            ],
                          ),
                          if (widget.location != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.location!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Arrow icon
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}