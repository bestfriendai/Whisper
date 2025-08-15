import 'package:flutter/material.dart';
import 'package:whisperdate/theme.dart';

class UltraModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showGradient;
  final VoidCallback? onBack;
  final double elevation;
  final bool isFloating;

  const UltraModernAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showGradient = true,
    this.onBack,
    this.elevation = 0,
    this.isFloating = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: isFloating 
          ? const EdgeInsets.fromLTRB(20, 20, 20, 0)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: showGradient
            ? LinearGradient(
                colors: [
                  theme.colorScheme.surface.withValues(alpha: 0.98),
                  theme.colorScheme.surface.withValues(alpha: 0.95),
                  theme.colorScheme.surface.withValues(alpha: 0.90),
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        color: !showGradient ? theme.colorScheme.surface : null,
        borderRadius: isFloating ? BorderRadius.circular(24) : null,
        border: isFloating 
            ? Border.all(
                color: isDark 
                    ? AppColors.ultraGlassStroke.withValues(alpha: 0.4)
                    : AppColors.glassStroke.withValues(alpha: 0.3),
                width: 1.2,
              )
            : null,
        boxShadow: isFloating 
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.9),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => showGradient
              ? AppColors.meshGradient1.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                )
              : LinearGradient(
                  colors: [theme.colorScheme.onSurface, theme.colorScheme.onSurface],
                ).createShader(bounds),
          child: Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.8,
            ),
          ),
        ),
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: leading ?? (Navigator.canPop(context)
            ? _buildBackButton(context)
            : null),
        actions: actions?.map((action) => _enhanceAction(context, action)).toList(),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onBack ?? () => Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceVariant.withValues(alpha: 0.8),
              theme.colorScheme.surfaceVariant.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.ultraGlassStroke.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: -1,
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }

  Widget _enhanceAction(BuildContext context, Widget action) {
    final theme = Theme.of(context);
    
    if (action is IconButton) {
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceVariant.withValues(alpha: 0.8),
              theme.colorScheme.surfaceVariant.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.ultraGlassStroke.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: -1,
            ),
          ],
        ),
        child: IconButton(
          onPressed: action.onPressed,
          icon: action.icon,
          iconSize: 20,
          padding: const EdgeInsets.all(8),
        ),
      );
    }
    
    return action;
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (isFloating ? 20 : 0),
  );
}