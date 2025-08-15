import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme_modern.dart';

// Modern Primary Button with Gradient and Micro-interactions
class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final ModernButtonSize size;
  final ModernButtonStyle style;
  final IconData? icon;
  final bool iconAtEnd;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.size = ModernButtonSize.large,
    this.style = ModernButtonStyle.primary,
    this.icon,
    this.iconAtEnd = false,
    this.width,
    this.padding,
    this.borderRadius,
    this.shadows,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: ModernDuration.fast,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: ModernCurves.easeOutQuart,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
      widget.onPressed?.call();
      _startPulse();
    }
  }

  void _onTapCancel() {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _startPulse() {
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = widget.enabled && widget.onPressed != null && !widget.isLoading;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _pulseAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedContainer(
              duration: ModernDuration.fast,
              width: widget.width ?? double.infinity,
              height: widget.size.height,
              padding: widget.padding ?? widget.size.padding,
              decoration: BoxDecoration(
                gradient: _getGradient(isEnabled),
                borderRadius: widget.borderRadius ?? 
                    BorderRadius.circular(ModernRadius.button),
                boxShadow: widget.shadows ?? _getShadows(isEnabled),
                border: widget.style == ModernButtonStyle.outlined
                    ? Border.all(
                        color: isEnabled 
                            ? ModernColors.primary 
                            : ModernColors.gray300,
                        width: 1.5,
                      )
                    : null,
              ),
              child: AnimatedOpacity(
                duration: ModernDuration.fast,
                opacity: isEnabled ? 1.0 : 0.6,
                child: _buildContent(theme, isEnabled),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ThemeData theme, bool isEnabled) {
    final textColor = _getTextColor(isEnabled);
    final iconSize = widget.size.iconSize;
    
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      );
    }
    
    if (widget.icon != null) {
      final children = [
        Icon(
          widget.icon,
          color: textColor,
          size: iconSize,
        ),
        const SizedBox(width: ModernSpacing.sm),
        Flexible(
          child: Text(
            widget.text,
            style: widget.size.textStyle.copyWith(color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ];
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: widget.iconAtEnd ? children.reversed.toList() : children,
      );
    }
    
    return Center(
      child: Text(
        widget.text,
        style: widget.size.textStyle.copyWith(color: textColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Gradient? _getGradient(bool isEnabled) {
    if (!isEnabled) return null;
    
    switch (widget.style) {
      case ModernButtonStyle.primary:
        return ModernColors.primaryGradient;
      case ModernButtonStyle.secondary:
        return ModernColors.secondaryGradient;
      case ModernButtonStyle.accent:
        return ModernColors.accentGradient;
      case ModernButtonStyle.outlined:
      case ModernButtonStyle.text:
        return null;
      case ModernButtonStyle.surface:
        return ModernColors.surfaceGradient;
    }
  }

  Color _getTextColor(bool isEnabled) {
    if (!isEnabled) return ModernColors.gray400;
    
    switch (widget.style) {
      case ModernButtonStyle.primary:
      case ModernButtonStyle.secondary:
      case ModernButtonStyle.accent:
        return ModernColors.white;
      case ModernButtonStyle.outlined:
      case ModernButtonStyle.text:
        return ModernColors.primary;
      case ModernButtonStyle.surface:
        return ModernColors.gray700;
    }
  }

  List<BoxShadow> _getShadows(bool isEnabled) {
    if (!isEnabled) return [];
    
    switch (widget.style) {
      case ModernButtonStyle.primary:
        return _isPressed ? [] : ModernShadows.primary;
      case ModernButtonStyle.secondary:
        return _isPressed ? [] : ModernShadows.secondary;
      case ModernButtonStyle.accent:
      case ModernButtonStyle.surface:
        return _isPressed ? [] : ModernShadows.medium;
      case ModernButtonStyle.outlined:
      case ModernButtonStyle.text:
        return [];
    }
  }
}

// Social Login Button (Google, Apple, etc.)
class ModernSocialButton extends StatefulWidget {
  final String text;
  final String iconPath;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ModernSocialProvider provider;

  const ModernSocialButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.onPressed,
    this.isLoading = false,
    required this.provider,
  });

  @override
  State<ModernSocialButton> createState() => _ModernSocialButtonState();
}

class _ModernSocialButtonState extends State<ModernSocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: ModernDuration.fast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: ModernCurves.easeOutQuart,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (isEnabled) {
                _controller.forward();
                HapticFeedback.selectionClick();
              }
            },
            onTapUp: (_) {
              if (isEnabled) {
                _controller.reverse();
                widget.onPressed?.call();
              }
            },
            onTapCancel: () {
              if (isEnabled) {
                _controller.reverse();
              }
            },
            child: Container(
              width: double.infinity,
              height: ModernSpacing.buttonHeight,
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(ModernRadius.button),
                border: Border.all(
                  color: _getBorderColor(theme),
                  width: 1.5,
                ),
                boxShadow: isEnabled ? ModernShadows.small : [],
              ),
              child: AnimatedOpacity(
                duration: ModernDuration.fast,
                opacity: isEnabled ? 1.0 : 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isLoading)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getTextColor(theme),
                          ),
                        ),
                      )
                    else
                      Image.network(
                        widget.iconPath,
                        width: 20,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            _getDefaultIcon(),
                            size: 20,
                            color: _getTextColor(theme),
                          );
                        },
                      ),
                    const SizedBox(width: ModernSpacing.md),
                    Text(
                      widget.text,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: _getTextColor(theme),
                        fontWeight: FontWeight.w600,
                      ),
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

  Color _getBackgroundColor() {
    switch (widget.provider) {
      case ModernSocialProvider.google:
        return ModernColors.white;
      case ModernSocialProvider.apple:
        return ModernColors.black;
      case ModernSocialProvider.facebook:
        return const Color(0xFF1877F2);
      case ModernSocialProvider.twitter:
        return const Color(0xFF1DA1F2);
    }
  }

  Color _getBorderColor(ThemeData theme) {
    switch (widget.provider) {
      case ModernSocialProvider.google:
        return ModernColors.gray200;
      case ModernSocialProvider.apple:
        return ModernColors.black;
      case ModernSocialProvider.facebook:
      case ModernSocialProvider.twitter:
        return Colors.transparent;
    }
  }

  Color _getTextColor(ThemeData theme) {
    switch (widget.provider) {
      case ModernSocialProvider.google:
        return ModernColors.gray700;
      case ModernSocialProvider.apple:
      case ModernSocialProvider.facebook:
      case ModernSocialProvider.twitter:
        return ModernColors.white;
    }
  }

  IconData _getDefaultIcon() {
    switch (widget.provider) {
      case ModernSocialProvider.google:
        return Icons.login;
      case ModernSocialProvider.apple:
        return Icons.apple;
      case ModernSocialProvider.facebook:
        return Icons.facebook;
      case ModernSocialProvider.twitter:
        return Icons.alternate_email;
    }
  }
}

// Floating Action Button with modern design
class ModernFab extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final bool mini;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ModernFab({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.mini = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<ModernFab> createState() => _ModernFabState();
}

class _ModernFabState extends State<ModernFab>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: ModernDuration.fast,
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: ModernDuration.normal,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: ModernCurves.easeOutQuart,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: ModernCurves.spring,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _onPressed() {
    if (widget.onPressed != null) {
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
      
      _rotationController.forward().then((_) {
        _rotationController.reverse();
      });
      
      HapticFeedback.mediumImpact();
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.mini ? 48.0 : 56.0;
    final iconSize = widget.mini ? 20.0 : 24.0;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: ModernColors.primaryGradient,
                borderRadius: BorderRadius.circular(size / 2),
                boxShadow: ModernShadows.large,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(size / 2),
                child: InkWell(
                  borderRadius: BorderRadius.circular(size / 2),
                  onTap: _onPressed,
                  child: Center(
                    child: Icon(
                      widget.icon,
                      size: iconSize,
                      color: widget.foregroundColor ?? ModernColors.white,
                    ),
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

// Button Enums and Styles
enum ModernButtonSize {
  small(
    height: 40.0,
    iconSize: 16.0,
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: ModernTheme.primaryFont,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: ModernSpacing.lg,
      vertical: ModernSpacing.sm,
    ),
  ),
  medium(
    height: 48.0,
    iconSize: 18.0,
    textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontFamily: ModernTheme.primaryFont,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: ModernSpacing.xl,
      vertical: ModernSpacing.md,
    ),
  ),
  large(
    height: 56.0,
    iconSize: 20.0,
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: ModernTheme.primaryFont,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: ModernSpacing.xl,
      vertical: ModernSpacing.lg,
    ),
  );

  const ModernButtonSize({
    required this.height,
    required this.iconSize,
    required this.textStyle,
    required this.padding,
  });

  final double height;
  final double iconSize;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
}

enum ModernButtonStyle {
  primary,
  secondary,
  accent,
  outlined,
  text,
  surface,
}

enum ModernSocialProvider {
  google,
  apple,
  facebook,
  twitter,
}

// Helper widgets for common button patterns
class ModernButtonGroup extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final double spacing;

  const ModernButtonGroup({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.spacing = ModernSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      children: children
          .map((child) => Expanded(child: child))
          .toList()
          .fold<List<Widget>>(
            [],
            (prev, curr) => prev.isEmpty
                ? [curr]
                : [
                    ...prev,
                    SizedBox(
                      width: direction == Axis.horizontal ? spacing : 0,
                      height: direction == Axis.vertical ? spacing : 0,
                    ),
                    curr,
                  ],
          ),
    );
  }
}