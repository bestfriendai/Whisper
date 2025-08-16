/// Unified Design System Components Export
/// 
/// This file provides easy access to all design system components.
/// Import this single file instead of individual component files.

// Core design system
export 'buttons.dart';
export 'cards.dart';
export 'loading_states.dart';

// Design tokens
export '../design_tokens.dart';

// Commonly used Flutter packages
export 'package:cached_network_image/cached_network_image.dart';
export 'package:shimmer/shimmer.dart';

/// Quick access to common design system components
class DS {
  DS._();
  
  // Spacing shortcuts
  static const double xs = DesignTokens.spacingXSmall;
  static const double sm = DesignTokens.spacingSmall;
  static const double md = DesignTokens.spacingMedium;
  static const double lg = DesignTokens.spacingLarge;
  static const double xl = DesignTokens.spacingXLarge;
  static const double xxl = DesignTokens.spacingXXLarge;
  
  // Radius shortcuts
  static const double radiusSm = DesignTokens.radiusSmall;
  static const double radiusMd = DesignTokens.radiusMedium;
  static const double radiusLg = DesignTokens.radiusLarge;
  static const double radiusXl = DesignTokens.radiusXLarge;
  static const double radiusRound = DesignTokens.radiusRound;
  
  // Color shortcuts
  static const primary = DesignTokens.primary;
  static const secondary = DesignTokens.secondary;
  static const accent = DesignTokens.accent;
  static const success = DesignTokens.success;
  static const warning = DesignTokens.warning;
  static const error = DesignTokens.error;
  static const info = DesignTokens.info;
  
  // Neutral colors
  static const neutral50 = DesignTokens.neutral50;
  static const neutral100 = DesignTokens.neutral100;
  static const neutral200 = DesignTokens.neutral200;
  static const neutral300 = DesignTokens.neutral300;
  static const neutral400 = DesignTokens.neutral400;
  static const neutral500 = DesignTokens.neutral500;
  static const neutral600 = DesignTokens.neutral600;
  static const neutral700 = DesignTokens.neutral700;
  static const neutral800 = DesignTokens.neutral800;
  static const neutral900 = DesignTokens.neutral900;
}