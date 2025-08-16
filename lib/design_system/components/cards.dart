import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../design_tokens.dart';
import '../../models/review.dart';

/// Unified Card Components
/// 
/// Provides consistent card styles across the app using design tokens.
/// Replaces multiple inconsistent card implementations.

/// Base card component for consistent styling
class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const BaseCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.boxShadow,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin ?? const EdgeInsets.all(DesignTokens.spacingSmall),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusLarge),
        boxShadow: boxShadow ?? DesignTokens.shadowSmall,
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusLarge),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(DesignTokens.spacingMedium),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Optimized review card for feed displays
class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onTap;
  final bool showImage;
  final CardStyle style;

  const ReviewCard({
    super.key,
    required this.review,
    this.onTap,
    this.showImage = true,
    this.style = CardStyle.standard,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case CardStyle.compact:
        return _buildCompactCard(context);
      case CardStyle.feature:
        return _buildFeatureCard(context);
      case CardStyle.standard:
      default:
        return _buildStandardCard(context);
    }
  }

  Widget _buildStandardCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return BaseCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showImage && review.imageUrls.isNotEmpty)
            _buildImage(context),
          
          const SizedBox(height: DesignTokens.spacingMedium),
          
          // Header with avatar and name
          Row(
            children: [
              _buildAvatar(context),
              const SizedBox(width: DesignTokens.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.isAnonymous ? 'Anonymous' : review.subjectName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${review.location.city} • ${_getTimeAgo(review.createdAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (review.wouldRecommend)
                _buildRecommendBadge(context),
            ],
          ),
          
          const SizedBox(height: DesignTokens.spacingMedium),
          
          // Title
          Text(
            review.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: DesignTokens.spacingSmall),
          
          // Content
          Text(
            review.content,
            style: theme.textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: DesignTokens.spacingMedium),
          
          // Footer with rating and stats
          Row(
            children: [
              _buildRatingDisplay(context),
              const Spacer(),
              _buildStats(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return BaseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(DesignTokens.spacingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showImage && review.imageUrls.isNotEmpty)
            _buildCompactImage(context),
          
          const SizedBox(width: DesignTokens.spacingMedium),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildAvatar(context, size: DesignTokens.avatarSizeSmall),
                    const SizedBox(width: DesignTokens.spacingSmall),
                    Expanded(
                      child: Text(
                        review.isAnonymous ? 'Anonymous' : review.subjectName,
                        style: theme.textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _getTimeAgo(review.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: DesignTokens.spacingSmall),
                
                Text(
                  review.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: DesignTokens.spacingXSmall),
                
                Text(
                  review.content,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: DesignTokens.spacingSmall),
                
                Row(
                  children: [
                    _buildRatingDisplay(context, compact: true),
                    const Spacer(),
                    _buildStats(context, compact: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return BaseCard(
      onTap: onTap,
      boxShadow: DesignTokens.shadowLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showImage && review.imageUrls.isNotEmpty)
            _buildFeatureImage(context),
          
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildAvatar(context, size: DesignTokens.avatarSizeLarge),
                    const SizedBox(width: DesignTokens.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.isAnonymous ? 'Anonymous' : review.subjectName,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${review.location.city} • ${_getTimeAgo(review.createdAt)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (review.wouldRecommend)
                      _buildRecommendBadge(context),
                  ],
                ),
                
                const SizedBox(height: DesignTokens.spacingLarge),
                
                Text(
                  review.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                
                const SizedBox(height: DesignTokens.spacingMedium),
                
                Text(
                  review.content,
                  style: theme.textTheme.bodyLarge,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: DesignTokens.spacingLarge),
                
                Row(
                  children: [
                    _buildRatingDisplay(context),
                    const Spacer(),
                    _buildStats(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: OptimizedNetworkImage(
          imageUrl: review.imageUrls.first,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCompactImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      child: SizedBox(
        width: 60,
        height: 60,
        child: OptimizedNetworkImage(
          imageUrl: review.imageUrls.first,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFeatureImage(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(DesignTokens.radiusLarge),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: OptimizedNetworkImage(
          imageUrl: review.imageUrls.first,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, {double? size}) {
    final avatarSize = size ?? DesignTokens.avatarSizeMedium;
    
    return CircleAvatar(
      radius: avatarSize / 2,
      backgroundColor: DesignTokens.primary,
      child: Text(
        review.isAnonymous ? 'A' : review.subjectName[0].toUpperCase(),
        style: DesignTokens.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: avatarSize * 0.4,
        ),
      ),
    );
  }

  Widget _buildRecommendBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSmall,
        vertical: DesignTokens.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            size: DesignTokens.iconSizeSmall,
            color: DesignTokens.success,
          ),
          const SizedBox(width: DesignTokens.spacingXSmall),
          Text(
            'Recommended',
            style: DesignTokens.textTheme.labelSmall?.copyWith(
              color: DesignTokens.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDisplay(BuildContext context, {bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? DesignTokens.spacingSmall : DesignTokens.spacingMedium,
        vertical: DesignTokens.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: _getRatingColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag,
            size: compact ? DesignTokens.iconSizeSmall : DesignTokens.iconSizeMedium,
            color: _getRatingColor(),
          ),
          const SizedBox(width: DesignTokens.spacingXSmall),
          Text(
            _getRatingText(),
            style: (compact ? DesignTokens.textTheme.labelSmall : DesignTokens.textTheme.labelMedium)?.copyWith(
              color: _getRatingColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, {bool compact = false}) {
    final iconSize = compact ? DesignTokens.iconSizeSmall : DesignTokens.iconSizeMedium;
    final textStyle = compact ? DesignTokens.textTheme.labelSmall : DesignTokens.textTheme.labelMedium;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.favorite_outline, size: iconSize, color: DesignTokens.neutral500),
        const SizedBox(width: DesignTokens.spacingXSmall),
        Text(
          '${review.stats.likes}',
          style: textStyle?.copyWith(color: DesignTokens.neutral600),
        ),
        const SizedBox(width: DesignTokens.spacingMedium),
        Icon(Icons.comment_outlined, size: iconSize, color: DesignTokens.neutral500),
        const SizedBox(width: DesignTokens.spacingXSmall),
        Text(
          '${review.stats.comments}',
          style: textStyle?.copyWith(color: DesignTokens.neutral600),
        ),
      ],
    );
  }

  Color _getRatingColor() {
    if (review.rating >= 4) return DesignTokens.success;
    if (review.rating <= 2) return DesignTokens.error;
    return DesignTokens.warning;
  }

  String _getRatingText() {
    if (review.rating >= 4) return '+${review.rating - 2}';
    if (review.rating <= 2) return '-${3 - review.rating}';
    return 'Mixed';
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w';
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
}

/// Optimized network image with consistent loading and error states
class OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: DesignTokens.shimmerGradient,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(DesignTokens.primary),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: DesignTokens.neutral200,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
        ),
        child: Icon(
          Icons.image_not_supported_outlined,
          color: DesignTokens.neutral500,
          size: (width != null && height != null) ? 
            (width! < height! ? width! * 0.3 : height! * 0.3) : 
            DesignTokens.iconSizeLarge,
        ),
      ),
      memCacheWidth: width?.round(),
      memCacheHeight: height?.round(),
    );
  }
}

/// Card style enumeration
enum CardStyle {
  standard,
  compact,
  feature,
}