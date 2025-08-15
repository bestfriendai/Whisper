import 'package:flutter/material.dart';

class ProfileStatsCard extends StatefulWidget {
  final int reviewsPosted;
  final int commentsPosted;
  final int likesReceived;
  final double reputation;
  final int level;

  const ProfileStatsCard({
    super.key,
    this.reviewsPosted = 0,
    this.commentsPosted = 0,
    this.likesReceived = 0,
    this.reputation = 0.0,
    this.level = 1,
  });

  @override
  State<ProfileStatsCard> createState() => _ProfileStatsCardState();
}

class _ProfileStatsCardState extends State<ProfileStatsCard>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(5, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 500 + (index * 100)),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    // Start animations with delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Your Stats',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: _animations[0],
                  builder: (context, child) => Transform.scale(
                    scale: _animations[0].value,
                    child: _buildStatItem(
                      context,
                      Icons.rate_review_outlined,
                      widget.reviewsPosted.toString(),
                      'Reviews',
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _animations[1],
                  builder: (context, child) => Transform.scale(
                    scale: _animations[1].value,
                    child: _buildStatItem(
                      context,
                      Icons.chat_bubble_outline,
                      widget.commentsPosted.toString(),
                      'Comments',
                      theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _animations[2],
                  builder: (context, child) => Transform.scale(
                    scale: _animations[2].value,
                    child: _buildStatItem(
                      context,
                      Icons.favorite_outline,
                      widget.likesReceived.toString(),
                      'Likes',
                      theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: _animations[3],
                  builder: (context, child) => Transform.scale(
                    scale: _animations[3].value,
                    child: _buildStatItem(
                      context,
                      Icons.star_outline,
                      widget.reputation.toStringAsFixed(1),
                      'Rating',
                      Colors.amber,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _animations[4],
                  builder: (context, child) => Transform.scale(
                    scale: _animations[4].value,
                    child: _buildStatItem(
                      context,
                      Icons.trending_up,
                      'Level ${widget.level}',
                      'Contributor',
                      theme.colorScheme.tertiary ?? theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label, Color color) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressRingIndicator extends StatefulWidget {
  final double value;
  final Color color;
  final double size;
  final double strokeWidth;
  final Widget? child;

  const ProgressRingIndicator({
    super.key,
    required this.value,
    required this.color,
    this.size = 120,
    this.strokeWidth = 8,
    this.child,
  });

  @override
  State<ProgressRingIndicator> createState() => _ProgressRingIndicatorState();
}

class _ProgressRingIndicatorState extends State<ProgressRingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: widget.strokeWidth,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              
              // Progress circle
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: widget.strokeWidth,
                  color: widget.color,
                  strokeCap: StrokeCap.round,
                ),
              ),
              
              // Center content
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }
}