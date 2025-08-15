import 'package:flutter/material.dart';
import 'package:whisperdate/theme.dart';

class UltraModernFAB extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final bool isExtended;
  final String? label;

  const UltraModernFAB({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.isExtended = false,
    this.label,
  });

  @override
  State<UltraModernFAB> createState() => _UltraModernFABState();
}

class _UltraModernFABState extends State<UltraModernFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _shadowAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              onTap: widget.onPressed,
              child: Container(
                width: widget.isExtended ? null : 64,
                height: 64,
                padding: widget.isExtended 
                    ? const EdgeInsets.symmetric(horizontal: 24, vertical: 18)
                    : null,
                decoration: BoxDecoration(
                  gradient: AppColors.meshGradient1,
                  borderRadius: BorderRadius.circular(widget.isExtended ? 32 : 32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4 * _shadowAnimation.value),
                      blurRadius: 24 * _shadowAnimation.value,
                      offset: Offset(0, 8 * _shadowAnimation.value),
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2 * _shadowAnimation.value),
                      blurRadius: 48 * _shadowAnimation.value,
                      offset: Offset(0, 16 * _shadowAnimation.value),
                      spreadRadius: -8,
                    ),
                    BoxShadow(
                      color: AppColors.neonGlassBg.withValues(alpha: _shadowAnimation.value * 0.8),
                      blurRadius: 80 * _shadowAnimation.value,
                      offset: Offset(0, 4 * _shadowAnimation.value),
                      spreadRadius: -12,
                    ),
                  ],
                ),
                child: widget.isExtended
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                          if (widget.label != null) ...[
                            const SizedBox(width: 12),
                            Text(
                              widget.label!,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ],
                      )
                    : Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 28,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}