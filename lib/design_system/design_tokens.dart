import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Unified Design System for Locker Room Talk
/// 
/// This file consolidates all design tokens, colors, typography, spacing,
/// and component definitions into a single source of truth.
/// 
/// Based on Material Design 3 principles with custom dating app optimizations.
class DesignTokens {
  DesignTokens._();

  // ============================================================================
  // COLOR SYSTEM
  // ============================================================================
  
  /// Primary Brand Colors - Optimized for dating app psychology
  static const Color primary = Color(0xFF7B2CBF); // Sophisticated purple - trust & intimacy
  static const Color primaryLight = Color(0xFF9966CC); 
  static const Color primaryDark = Color(0xFF5A1A8B);
  
  /// Secondary Colors - Modern & approachable
  static const Color secondary = Color(0xFF06D6A0); // Fresh teal - growth & harmony
  static const Color secondaryLight = Color(0xFF4FFFDA);
  static const Color secondaryDark = Color(0xFF00A676);
  
  /// Accent Colors - Energy & emotion
  static const Color accent = Color(0xFFFF6B9D); // Warm pink - love & passion
  static const Color accentLight = Color(0xFFFF9AC1);
  static const Color accentDark = Color(0xFFE54370);
  
  /// Neutral Palette - Clean & modern
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);
  
  /// Semantic Colors
  static const Color success = Color(0xFF00C896);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF3366);
  static const Color info = Color(0xFF0099FF);
  
  /// Dating App Specific Colors
  static const Color like = Color(0xFF00E676);
  static const Color superlike = Color(0xFF2196F3);
  static const Color match = Color(0xFFFF6B9D);
  static const Color online = Color(0xFF00E676);
  static const Color verified = Color(0xFFFFD700);
  
  /// Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF000000);
  
  // ============================================================================
  // GRADIENT SYSTEM
  // ============================================================================
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );
  
  // ============================================================================
  // TYPOGRAPHY SYSTEM
  // ============================================================================
  
  static TextTheme get textTheme => TextTheme(
    // Display styles - for hero content
    displayLarge: GoogleFonts.poppins(
      fontSize: 40,
      fontWeight: FontWeight.w800,
      height: 1.1,
      letterSpacing: -1.5,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
    
    // Headlines - for section headers
    headlineLarge: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.35,
    ),
    
    // Titles - for card headers and navigation
    titleLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.45,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    
    // Body text - for content
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.45,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    
    // Labels - for buttons and form labels
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: 0.5,
    ),
  );
  
  // ============================================================================
  // SPACING SYSTEM
  // ============================================================================
  
  /// 4pt grid system for consistent spacing
  static const double space0 = 0;
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space56 = 56;
  static const double space64 = 64;
  
  /// Semantic spacing
  static const double spacingXSmall = space4;
  static const double spacingSmall = space8;
  static const double spacingMedium = space16;
  static const double spacingLarge = space24;
  static const double spacingXLarge = space32;
  static const double spacingXXLarge = space48;
  
  // ============================================================================
  // BORDER RADIUS SYSTEM
  // ============================================================================
  
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 20;
  static const double radiusXXLarge = 24;
  static const double radiusRound = 50;
  
  // ============================================================================
  // ELEVATION SYSTEM
  // ============================================================================
  
  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation4 = 4;
  static const double elevation8 = 8;
  static const double elevation12 = 12;
  static const double elevation16 = 16;
  static const double elevation24 = 24;
  
  // ============================================================================
  // SHADOW SYSTEM
  // ============================================================================
  
  static List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: neutral900.withOpacity(0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: neutral900.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get shadowLarge => [
    BoxShadow(
      color: neutral900.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get shadowXLarge => [
    BoxShadow(
      color: neutral900.withOpacity(0.16),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
  
  // ============================================================================
  // COMPONENT-SPECIFIC TOKENS
  // ============================================================================
  
  /// Button dimensions
  static const double buttonHeightSmall = 32;
  static const double buttonHeightMedium = 40;
  static const double buttonHeightLarge = 48;
  static const double buttonHeightXLarge = 56;
  
  /// Icon sizes
  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 20;
  static const double iconSizeLarge = 24;
  static const double iconSizeXLarge = 32;
  
  /// Avatar sizes
  static const double avatarSizeSmall = 32;
  static const double avatarSizeMedium = 40;
  static const double avatarSizeLarge = 48;
  static const double avatarSizeXLarge = 64;
  static const double avatarSizeXXLarge = 80;
  
  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  
  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  /// Get responsive spacing based on screen size
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return baseSpacing;
    if (screenWidth < 900) return baseSpacing * 1.2;
    return baseSpacing * 1.5;
  }
  
  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return baseFontSize;
    if (screenWidth < 900) return baseFontSize * 1.1;
    return baseFontSize * 1.2;
  }
}