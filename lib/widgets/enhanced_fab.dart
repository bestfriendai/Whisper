import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnhancedFloatingActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? tooltip;
  final bool mini;
  final String? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final List<Color>? gradientColors;
  final bool showPulse;
  final IconData? icon;
  final String? label;

  const EnhancedFloatingActionButton({
    super.key,
    this.onPressed,
    this.child,
    this.tooltip,
    this.mini = false,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.gradientColors,
    this.showPulse = false,
    this.icon,
    this.label,
  });

  @override
  State<EnhancedFloatingActionButton> createState() => _EnhancedFloatingActionButtonState();
}

class _EnhancedFloatingActionButtonState extends State<EnhancedFloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOut,
    ));

    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = widget.mini ? 48.0 : 64.0;
    
    Widget fabContent = widget.child ?? 
        (widget.icon != null 
            ? Icon(
                widget.icon,
                color: widget.foregroundColor ?? theme.colorScheme.onPrimary,
                size: widget.mini ? 20 : 28,
              )
            : const Icon(Icons.add));

    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * (widget.showPulse ? _pulseAnimation.value : 1.0),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: widget.gradientColors != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.gradientColors!,
                    )
                  : null,
              color: widget.gradientColors == null 
                  ? (widget.backgroundColor ?? theme.colorScheme.primary)
                  : null,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (widget.backgroundColor ?? theme.colorScheme.primary)
                      .withValues(alpha: 0.3),
                  blurRadius: widget.showPulse ? 20 : 12,
                  spreadRadius: widget.showPulse ? 4 : 2,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: Container(
                  width: size,
                  height: size,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Center(child: fabContent),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Extended FAB with label
class EnhancedExtendedFab extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final List<Color>? gradientColors;

  const EnhancedExtendedFab({
    super.key,
    this.onPressed,
    required this.icon,
    required this.label,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.gradientColors,
  });

  @override
  State<EnhancedExtendedFab> createState() => _EnhancedExtendedFabState();
}

class _EnhancedExtendedFabState extends State<EnhancedExtendedFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: widget.gradientColors != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.gradientColors!,
                    )
                  : null,
              color: widget.gradientColors == null 
                  ? (widget.backgroundColor ?? theme.colorScheme.primary)
                  : null,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: (widget.backgroundColor ?? theme.colorScheme.primary)
                      .withValues(alpha: 0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(32),
              child: InkWell(
                borderRadius: BorderRadius.circular(32),
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.icon,
                      const SizedBox(width: 12),
                      widget.label,
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
}