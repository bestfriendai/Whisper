import 'package:flutter/material.dart';
import '../theme.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final bool outlined;

  const GradientButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null && !isLoading;
    final isDark = theme.brightness == Brightness.dark;
    
    final buttonColor = enabled 
        ? (backgroundColor ?? AppColors.primary)
        : (isDark ? AppColors.neutral700 : AppColors.neutral300);
    
    final textColor = outlined
        ? (enabled ? AppColors.primary : AppColors.neutral400)
        : Colors.white;
    
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : buttonColor,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: outlined 
            ? Border.all(
                color: enabled ? AppColors.primary : AppColors.neutral400,
                width: 2,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: (borderRadius ?? BorderRadius.circular(16)) as BorderRadius,
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : DefaultTextStyle(
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                      child: child,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}