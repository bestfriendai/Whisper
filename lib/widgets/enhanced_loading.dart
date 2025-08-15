import 'package:flutter/material.dart';
import 'package:lockerroomtalk/theme.dart';

class EnhancedLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final bool showBackground;
  final String? message;

  const EnhancedLoadingIndicator({
    super.key,
    this.size = 40.0,
    this.color,
    this.strokeWidth = 4.0,
    this.showBackground = false,
    this.message,
  });

  @override
  State<EnhancedLoadingIndicator> createState() => _EnhancedLoadingIndicatorState();
}

class _EnhancedLoadingIndicatorState extends State<EnhancedLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget indicator = AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationController.value * 2 * 3.14159,
            child: Container(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: widget.strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.color ?? theme.colorScheme.primary,
                ),
                backgroundColor: widget.color?.withValues(alpha: 0.2) ??
                    theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
          ),
        );
      },
    );

    if (widget.message != null) {
      indicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (widget.showBackground) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: indicator,
      );
    }

    return indicator;
  }
}

// Skeleton loading for cards
class EnhancedSkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const EnhancedSkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<EnhancedSkeletonLoader> createState() => _EnhancedSkeletonLoaderState();
}

class _EnhancedSkeletonLoaderState extends State<EnhancedSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _animation.value, 0.0),
              end: Alignment(-0.5 + _animation.value, 0.0),
              colors: [
                theme.colorScheme.surfaceVariant.withValues(alpha: 0.6),
                theme.colorScheme.surfaceVariant.withValues(alpha: 0.9),
                theme.colorScheme.surfaceVariant.withValues(alpha: 0.6),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Enhanced shimmer loading for review cards
class EnhancedShimmerCard extends StatelessWidget {
  final bool isCompact;

  const EnhancedShimmerCard({
    super.key,
    this.isCompact = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const EnhancedSkeletonLoader(
                    width: 60,
                    height: 24,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  const EnhancedSkeletonLoader(
                    width: 20,
                    height: 20,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Title
              const EnhancedSkeletonLoader(
                width: double.infinity,
                height: 20,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              
              const SizedBox(height: 8),
              
              // Content lines
              const EnhancedSkeletonLoader(
                width: double.infinity,
                height: 16,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              
              const SizedBox(height: 4),
              
              const EnhancedSkeletonLoader(
                width: 200,
                height: 16,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                children: [
                  const EnhancedSkeletonLoader(
                    width: 40,
                    height: 20,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  const SizedBox(width: 16),
                  const EnhancedSkeletonLoader(
                    width: 40,
                    height: 20,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  const Spacer(),
                  const EnhancedSkeletonLoader(
                    width: 60,
                    height: 16,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          const EnhancedSkeletonLoader(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating
                const EnhancedSkeletonLoader(
                  width: 60,
                  height: 24,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                
                const SizedBox(height: 12),
                
                // Title
                const EnhancedSkeletonLoader(
                  width: double.infinity,
                  height: 18,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                
                const SizedBox(height: 8),
                
                // Content
                const EnhancedSkeletonLoader(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                
                const SizedBox(height: 4),
                
                const EnhancedSkeletonLoader(
                  width: 150,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                
                const SizedBox(height: 16),
                
                // Stats
                Row(
                  children: [
                    const EnhancedSkeletonLoader(
                      width: 30,
                      height: 16,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    const SizedBox(width: 16),
                    const EnhancedSkeletonLoader(
                      width: 30,
                      height: 16,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    const Spacer(),
                    const EnhancedSkeletonLoader(
                      width: 40,
                      height: 12,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Loading overlay
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? overlayColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: EnhancedLoadingIndicator(
                size: 60,
                showBackground: true,
                message: message,
              ),
            ),
          ),
      ],
    );
  }
}