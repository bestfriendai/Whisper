import 'package:flutter/material.dart';
import '../design_tokens.dart';

/// Unified Button Components
/// 
/// Provides consistent button styles across the app using design tokens.
/// Eliminates the need for multiple custom button implementations.

/// Primary button for main actions
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonSize size;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _getButtonHeight(),
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(),
        label: _buildLabel(),
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: Colors.white,
          elevation: DesignTokens.elevation0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(),
            vertical: DesignTokens.spacingMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    
    if (icon != null) {
      return Icon(icon, size: _getIconSize());
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildLabel() {
    return Text(
      text,
      style: _getTextStyle(),
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.buttonHeightSmall;
      case ButtonSize.medium:
        return DesignTokens.buttonHeightMedium;
      case ButtonSize.large:
        return DesignTokens.buttonHeightLarge;
      case ButtonSize.xLarge:
        return DesignTokens.buttonHeightXLarge;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.spacingMedium;
      case ButtonSize.medium:
        return DesignTokens.spacingLarge;
      case ButtonSize.large:
        return DesignTokens.spacingXLarge;
      case ButtonSize.xLarge:
        return DesignTokens.spacingXXLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.iconSizeSmall;
      case ButtonSize.medium:
        return DesignTokens.iconSizeMedium;
      case ButtonSize.large:
        return DesignTokens.iconSizeLarge;
      case ButtonSize.xLarge:
        return DesignTokens.iconSizeXLarge;
    }
  }

  TextStyle? _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.textTheme.labelSmall;
      case ButtonSize.medium:
        return DesignTokens.textTheme.labelMedium;
      case ButtonSize.large:
        return DesignTokens.textTheme.labelLarge;
      case ButtonSize.xLarge:
        return DesignTokens.textTheme.titleMedium;
    }
  }
}

/// Secondary button for less important actions
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonSize size;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _getButtonHeight(),
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(),
        label: _buildLabel(),
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignTokens.primary,
          side: const BorderSide(color: DesignTokens.primary, width: 1.5),
          elevation: DesignTokens.elevation0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(),
            vertical: DesignTokens.spacingMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(DesignTokens.primary),
        ),
      );
    }
    
    if (icon != null) {
      return Icon(icon, size: _getIconSize());
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildLabel() {
    return Text(
      text,
      style: _getTextStyle(),
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.buttonHeightSmall;
      case ButtonSize.medium:
        return DesignTokens.buttonHeightMedium;
      case ButtonSize.large:
        return DesignTokens.buttonHeightLarge;
      case ButtonSize.xLarge:
        return DesignTokens.buttonHeightXLarge;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.spacingMedium;
      case ButtonSize.medium:
        return DesignTokens.spacingLarge;
      case ButtonSize.large:
        return DesignTokens.spacingXLarge;
      case ButtonSize.xLarge:
        return DesignTokens.spacingXXLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.iconSizeSmall;
      case ButtonSize.medium:
        return DesignTokens.iconSizeMedium;
      case ButtonSize.large:
        return DesignTokens.iconSizeLarge;
      case ButtonSize.xLarge:
        return DesignTokens.iconSizeXLarge;
    }
  }

  TextStyle? _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.textTheme.labelSmall;
      case ButtonSize.medium:
        return DesignTokens.textTheme.labelMedium;
      case ButtonSize.large:
        return DesignTokens.textTheme.labelLarge;
      case ButtonSize.xLarge:
        return DesignTokens.textTheme.titleMedium;
    }
  }
}

/// Ghost button for subtle actions
class GhostButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonSize size;

  const GhostButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _getButtonHeight(),
      child: TextButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(),
        label: _buildLabel(),
        style: TextButton.styleFrom(
          foregroundColor: DesignTokens.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(),
            vertical: DesignTokens.spacingMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(DesignTokens.primary),
        ),
      );
    }
    
    if (icon != null) {
      return Icon(icon, size: _getIconSize());
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildLabel() {
    return Text(
      text,
      style: _getTextStyle(),
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.buttonHeightSmall;
      case ButtonSize.medium:
        return DesignTokens.buttonHeightMedium;
      case ButtonSize.large:
        return DesignTokens.buttonHeightLarge;
      case ButtonSize.xLarge:
        return DesignTokens.buttonHeightXLarge;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.spacingMedium;
      case ButtonSize.medium:
        return DesignTokens.spacingLarge;
      case ButtonSize.large:
        return DesignTokens.spacingXLarge;
      case ButtonSize.xLarge:
        return DesignTokens.spacingXXLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.iconSizeSmall;
      case ButtonSize.medium:
        return DesignTokens.iconSizeMedium;
      case ButtonSize.large:
        return DesignTokens.iconSizeLarge;
      case ButtonSize.xLarge:
        return DesignTokens.iconSizeXLarge;
    }
  }

  TextStyle? _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.textTheme.labelSmall;
      case ButtonSize.medium:
        return DesignTokens.textTheme.labelMedium;
      case ButtonSize.large:
        return DesignTokens.textTheme.labelLarge;
      case ButtonSize.xLarge:
        return DesignTokens.textTheme.titleMedium;
    }
  }
}

/// Gradient button for special actions
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonSize size;
  final Gradient? gradient;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = ButtonSize.medium,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _getButtonHeight(),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? DesignTokens.primaryGradient,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          boxShadow: DesignTokens.shadowMedium,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _getHorizontalPadding(),
                vertical: DesignTokens.spacingMedium,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIcon(),
                  if (icon != null && !isLoading) 
                    const SizedBox(width: DesignTokens.spacingSmall),
                  _buildLabel(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    
    if (icon != null) {
      return Icon(
        icon, 
        size: _getIconSize(),
        color: Colors.white,
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildLabel() {
    return Text(
      text,
      style: _getTextStyle()?.copyWith(color: Colors.white),
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.buttonHeightSmall;
      case ButtonSize.medium:
        return DesignTokens.buttonHeightMedium;
      case ButtonSize.large:
        return DesignTokens.buttonHeightLarge;
      case ButtonSize.xLarge:
        return DesignTokens.buttonHeightXLarge;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.spacingMedium;
      case ButtonSize.medium:
        return DesignTokens.spacingLarge;
      case ButtonSize.large:
        return DesignTokens.spacingXLarge;
      case ButtonSize.xLarge:
        return DesignTokens.spacingXXLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.iconSizeSmall;
      case ButtonSize.medium:
        return DesignTokens.iconSizeMedium;
      case ButtonSize.large:
        return DesignTokens.iconSizeLarge;
      case ButtonSize.xLarge:
        return DesignTokens.iconSizeXLarge;
    }
  }

  TextStyle? _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return DesignTokens.textTheme.labelSmall;
      case ButtonSize.medium:
        return DesignTokens.textTheme.labelMedium;
      case ButtonSize.large:
        return DesignTokens.textTheme.labelLarge;
      case ButtonSize.xLarge:
        return DesignTokens.textTheme.titleMedium;
    }
  }
}

/// Button size enumeration
enum ButtonSize {
  small,
  medium,
  large,
  xLarge,
}