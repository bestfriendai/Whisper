import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../design_tokens.dart';

/// Unified Loading States Components
/// 
/// Provides consistent loading, empty, and error states across the app.
/// Eliminates the need for multiple custom loading implementations.

/// Primary loading indicator
class AppLoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final String? message;

  const AppLoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size ?? 32,
          height: size ?? 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? DesignTokens.primary,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: DesignTokens.spacingMedium),
          Text(
            message!,
            style: DesignTokens.textTheme.bodyMedium?.copyWith(
              color: DesignTokens.neutral600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Shimmer loading placeholder for lists
class ShimmerLoading extends StatelessWidget {
  final Widget child;

  const ShimmerLoading({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: DesignTokens.neutral200,
      highlightColor: DesignTokens.neutral100,
      child: child,
    );
  }
}

/// Card shimmer placeholder
class CardShimmer extends StatelessWidget {
  final double height;
  final bool showImage;

  const CardShimmer({
    super.key,
    this.height = 200,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        margin: const EdgeInsets.all(DesignTokens.spacingSmall),
        padding: const EdgeInsets.all(DesignTokens.spacingMedium),
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showImage) ...[
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingMedium),
            ],
            
            Row(
              children: [
                Container(
                  width: DesignTokens.avatarSizeMedium,
                  height: DesignTokens.avatarSizeMedium,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingXSmall),
                      Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: DesignTokens.spacingMedium),
            
            Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingSmall),
            
            Container(
              height: 14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingXSmall),
            
            Container(
              height: 14,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// List shimmer placeholder
class ListShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ListShimmer({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerLoading(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMedium,
              vertical: DesignTokens.spacingSmall,
            ),
            height: itemHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            ),
          ),
        );
      },
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: DesignTokens.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: DesignTokens.iconSizeXLarge,
                color: DesignTokens.primary,
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingLarge),
            
            Text(
              title,
              style: DesignTokens.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: DesignTokens.neutral800,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: DesignTokens.spacingMedium),
            
            Text(
              message,
              style: DesignTokens.textTheme.bodyLarge?.copyWith(
                color: DesignTokens.neutral600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: DesignTokens.spacingXLarge),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingXLarge,
                    vertical: DesignTokens.spacingMedium,
                  ),
                ),
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state widget
class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onRetry;
  final bool showIcon;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.actionText = 'Try again',
    this.onRetry,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: DesignTokens.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: DesignTokens.iconSizeXLarge,
                  color: DesignTokens.error,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingLarge),
            ],
            
            Text(
              title,
              style: DesignTokens.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: DesignTokens.neutral800,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: DesignTokens.spacingMedium),
            
            Text(
              message,
              style: DesignTokens.textTheme.bodyLarge?.copyWith(
                color: DesignTokens.neutral600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (actionText != null && onRetry != null) ...[
              const SizedBox(height: DesignTokens.spacingXLarge),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingXLarge,
                    vertical: DesignTokens.spacingMedium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading overlay for full screen states
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.spacingXLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
                  boxShadow: DesignTokens.shadowLarge,
                ),
                child: AppLoadingIndicator(
                  size: 40,
                  message: message,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Skeleton loader for specific content types
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusSmall),
        ),
      ),
    );
  }
}

/// Grid shimmer for masonry layouts
class GridShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const GridShimmer({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: DesignTokens.spacingMedium,
        crossAxisSpacing: DesignTokens.spacingMedium,
        childAspectRatio: 0.7,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return CardShimmer(
          height: 250 + (index % 2 == 0 ? 50 : 0),
          showImage: true,
        );
      },
    );
  }
}