import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Ultra-Modern Design System inspired by Instagram, Tinder, and Bumble
// Premium $100M app aesthetics with glass morphism, subtle gradients, and micro-interactions

class ModernColors {
  // Primary Brand Colors - Dating App Optimized
  static const primary = Color(0xFFE91E63); // Deep Pink - Passionate Love
  static const primaryLight = Color(0xFFF8BBD9); // Soft Pink
  static const primaryDark = Color(0xFFAD1457); // Rich Pink
  
  // Secondary Colors - Trustworthy & Calming
  static const secondary = Color(0xFF6C63FF); // Purple - Premium Feel
  static const secondaryLight = Color(0xFFB8B5FF); // Light Purple
  static const secondaryDark = Color(0xFF4338CA); // Deep Purple
  
  // Accent Colors - Warmth & Energy
  static const accent = Color(0xFFFF6B35); // Orange - Energy & Warmth
  static const accentLight = Color(0xFFFFB59A); // Soft Orange
  static const accentDark = Color(0xFFE55100); // Deep Orange
  
  // Neutral Palette - Clean & Contemporary (Instagram-inspired)
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  
  // Light Theme Neutrals
  static const gray50 = Color(0xFFFAFAFA); // Background
  static const gray100 = Color(0xFFF5F5F5); // Light surfaces
  static const gray200 = Color(0xFFEEEEEE); // Borders
  static const gray300 = Color(0xFFE0E0E0); // Disabled
  static const gray400 = Color(0xFFBDBDBD); // Placeholder
  static const gray500 = Color(0xFF9E9E9E); // Secondary text
  static const gray600 = Color(0xFF757575); // Primary text light
  static const gray700 = Color(0xFF616161); // Primary text
  static const gray800 = Color(0xFF424242); // Headers
  static const gray900 = Color(0xFF212121); // Strong text
  
  // Dark Theme Neutrals
  static const dark50 = Color(0xFF1A1A1A); // Background
  static const dark100 = Color(0xFF2D2D2D); // Surfaces
  static const dark200 = Color(0xFF404040); // Borders
  static const dark300 = Color(0xFF525252); // Disabled
  static const dark400 = Color(0xFF737373); // Placeholder
  static const dark500 = Color(0xFF9CA3AF); // Secondary text
  static const dark600 = Color(0xFFD1D5DB); // Primary text
  static const dark700 = Color(0xFFE5E7EB); // Headers
  static const dark800 = Color(0xFFF3F4F6); // Strong text
  static const dark900 = Color(0xFFFFFFFF); // Strongest text
  
  // Semantic Colors
  static const success = Color(0xFF10B981); // Green
  static const successLight = Color(0xFF6EE7B7);
  static const successDark = Color(0xFF047857);
  
  static const warning = Color(0xFFF59E0B); // Amber
  static const warningLight = Color(0xFFFDE68A);
  static const warningDark = Color(0xFFD97706);
  
  static const error = Color(0xFFEF4444); // Red
  static const errorLight = Color(0xFFFCA5A5);
  static const errorDark = Color(0xFFDC2626);
  
  static const info = Color(0xFF3B82F6); // Blue
  static const infoLight = Color(0xFF93C5FD);
  static const infoDark = Color(0xFF1D4ED8);
  
  // Dating App Specific Colors
  static const like = Color(0xFF00C896); // Green Heart
  static const pass = Color(0xFFFF4458); // Red X
  static const superLike = Color(0xFF1EC71E); // Star
  static const boost = Color(0xFFFF6B35); // Boost
  static const gold = Color(0xFFFFD700); // Premium Gold
  static const verified = Color(0xFF2196F3); // Verification Blue
  
  // Modern Gradients - Instagram/Tinder Style
  static const instagramGradient = LinearGradient(
    colors: [
      Color(0xFF833AB4), // Purple
      Color(0xFFFD1D1D), // Red
      Color(0xFFFCB045), // Orange
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const primaryGradient = LinearGradient(
    colors: [
      Color(0xFFE91E63),
      Color(0xFFAD1457),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const secondaryGradient = LinearGradient(
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF4338CA),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const accentGradient = LinearGradient(
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFE55100),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Glass Morphism Gradients
  static const glassGradient = LinearGradient(
    colors: [
      Color(0x40FFFFFF),
      Color(0x10FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const glassGradientDark = LinearGradient(
    colors: [
      Color(0x20FFFFFF),
      Color(0x05FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Subtle Surface Gradients
  static const surfaceGradient = LinearGradient(
    colors: [
      Color(0xFFFFFBFE),
      Color(0xFFFAFAFA),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const surfaceGradientDark = LinearGradient(
    colors: [
      Color(0xFF1F1F1F),
      Color(0xFF1A1A1A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Special Effect Colors
  static const shimmer = Color(0xFFE3E3E3);
  static const shimmerDark = Color(0xFF404040);
  static const divider = Color(0xFFE0E0E0);
  static const dividerDark = Color(0xFF404040);
  
  // Shadow Colors
  static const shadowLight = Color(0x1A000000);
  static const shadowMedium = Color(0x33000000);
  static const shadowHeavy = Color(0x4D000000);
  static const shadowPrimary = Color(0x33E91E63);
  static const shadowSecondary = Color(0x336C63FF);
}

class ModernSpacing {
  // Modern spacing system (8px base)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
  
  // Component specific spacing
  static const double cardPadding = 20.0;
  static const double screenPadding = 24.0;
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double bottomNavHeight = 80.0;
  static const double appBarHeight = 60.0;
}

class ModernRadius {
  // Modern border radius system
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double full = 9999.0;
  
  // Component specific radius
  static const double button = 28.0; // Pill shaped buttons
  static const double card = 24.0; // Instagram-style cards
  static const double bottomNav = 28.0; // Modern bottom nav
  static const double input = 16.0; // Input fields
  static const double avatar = 50.0; // Profile avatars
}

class ModernElevation {
  // Modern elevation system
  static const double none = 0.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
}

class ModernShadows {
  // Custom shadow presets for modern design
  static List<BoxShadow> get small => [
    BoxShadow(
      color: ModernColors.shadowLight,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get medium => [
    BoxShadow(
      color: ModernColors.shadowLight,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: ModernColors.shadowLight.withOpacity(0.06),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> get large => [
    BoxShadow(
      color: ModernColors.shadowMedium,
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: ModernColors.shadowLight,
      blurRadius: 6,
      offset: const Offset(0, 3),
    ),
  ];
  
  static List<BoxShadow> get primary => [
    BoxShadow(
      color: ModernColors.shadowPrimary,
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get secondary => [
    BoxShadow(
      color: ModernColors.shadowSecondary,
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
  
  // Glass morphism shadows
  static List<BoxShadow> get glass => [
    BoxShadow(
      color: Colors.white.withOpacity(0.25),
      blurRadius: 20,
      offset: const Offset(-5, -5),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(5, 5),
    ),
  ];
}

class ModernTheme {
  // Custom font families (ensure these are added to pubspec.yaml)
  static const String primaryFont = 'SF Pro Display'; // iOS style
  static const String secondaryFont = 'SF Pro Text'; // For body text
  static const String headingFont = 'SF Pro Display'; // For headings
  
  // Typography Scale - Modern & Clean (Based on Material 3 + Custom)
  static TextTheme get _textTheme => const TextTheme(
    // Display Styles - Hero text
    displayLarge: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w800,
      height: 1.1,
      letterSpacing: -1.0,
      fontFamily: headingFont,
    ),
    displayMedium: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.5,
      fontFamily: headingFont,
    ),
    displaySmall: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.25,
      fontFamily: headingFont,
    ),
    
    // Headline Styles - Section headers
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: -0.25,
      fontFamily: headingFont,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: 0,
      fontFamily: headingFont,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: 0,
      fontFamily: headingFont,
    ),
    
    // Title Styles - Card titles, button text
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0,
      fontFamily: primaryFont,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0.1,
      fontFamily: primaryFont,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.1,
      fontFamily: primaryFont,
    ),
    
    // Body Styles - Main content
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.15,
      fontFamily: secondaryFont,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
      fontFamily: secondaryFont,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: 0.4,
      fontFamily: secondaryFont,
    ),
    
    // Label Styles - Buttons, chips, etc.
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.43,
      letterSpacing: 0.1,
      fontFamily: primaryFont,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.33,
      letterSpacing: 0.5,
      fontFamily: primaryFont,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.5,
      fontFamily: primaryFont,
    ),
  );

  // Light Theme - Primary Design (Instagram-inspired)
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: primaryFont,
    textTheme: _textTheme,
    
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: ModernColors.primary,
      onPrimary: ModernColors.white,
      primaryContainer: ModernColors.primaryLight,
      onPrimaryContainer: ModernColors.primaryDark,
      
      secondary: ModernColors.secondary,
      onSecondary: ModernColors.white,
      secondaryContainer: ModernColors.secondaryLight,
      onSecondaryContainer: ModernColors.secondaryDark,
      
      tertiary: ModernColors.accent,
      onTertiary: ModernColors.white,
      tertiaryContainer: ModernColors.accentLight,
      onTertiaryContainer: ModernColors.accentDark,
      
      error: ModernColors.error,
      onError: ModernColors.white,
      errorContainer: ModernColors.errorLight,
      onErrorContainer: ModernColors.errorDark,
      
      surface: ModernColors.white,
      onSurface: ModernColors.gray900,
      surfaceVariant: ModernColors.gray50,
      onSurfaceVariant: ModernColors.gray600,
      
      background: ModernColors.gray50,
      onBackground: ModernColors.gray900,
      
      outline: ModernColors.gray300,
      outlineVariant: ModernColors.gray200,
      
      inverseSurface: ModernColors.gray900,
      onInverseSurface: ModernColors.white,
      inversePrimary: ModernColors.primaryLight,
      
      shadow: ModernColors.shadowMedium,
      scrim: ModernColors.shadowHeavy,
      
      surfaceTint: ModernColors.primary,
    ),
    
    scaffoldBackgroundColor: ModernColors.gray50,
    dividerColor: ModernColors.divider,
    
    // App Bar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: ModernColors.gray900,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: _textTheme.titleLarge?.copyWith(
        color: ModernColors.gray900,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(
        color: ModernColors.gray700,
        size: 24,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: ModernColors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: ModernColors.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ModernRadius.card),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: ModernSpacing.md,
        vertical: ModernSpacing.sm,
      ),
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: ModernColors.primary,
        foregroundColor: ModernColors.white,
        disabledBackgroundColor: ModernColors.gray300,
        disabledForegroundColor: ModernColors.gray500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModernRadius.button),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ModernSpacing.xl,
          vertical: ModernSpacing.md,
        ),
        minimumSize: const Size(double.infinity, ModernSpacing.buttonHeight),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        shadowColor: ModernColors.shadowPrimary,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: ModernColors.primary,
        backgroundColor: Colors.transparent,
        disabledForegroundColor: ModernColors.gray400,
        side: const BorderSide(
          color: ModernColors.primary,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModernRadius.button),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ModernSpacing.xl,
          vertical: ModernSpacing.md,
        ),
        minimumSize: const Size(double.infinity, ModernSpacing.buttonHeight),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ModernColors.primary,
        disabledForegroundColor: ModernColors.gray400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ModernSpacing.lg,
          vertical: ModernSpacing.sm,
        ),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Input Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ModernColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ModernRadius.input),
        borderSide: const BorderSide(
          color: ModernColors.gray200,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ModernRadius.input),
        borderSide: const BorderSide(
          color: ModernColors.gray200,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ModernRadius.input),
        borderSide: const BorderSide(
          color: ModernColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ModernRadius.input),
        borderSide: const BorderSide(
          color: ModernColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ModernRadius.input),
        borderSide: const BorderSide(
          color: ModernColors.error,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ModernSpacing.lg,
        vertical: ModernSpacing.md,
      ),
      hintStyle: _textTheme.bodyMedium?.copyWith(
        color: ModernColors.gray400,
      ),
      labelStyle: _textTheme.bodyMedium?.copyWith(
        color: ModernColors.gray600,
      ),
      errorStyle: _textTheme.bodySmall?.copyWith(
        color: ModernColors.error,
      ),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.transparent,
      selectedItemColor: ModernColors.primary,
      unselectedItemColor: ModernColors.gray400,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: primaryFont,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: primaryFont,
      ),
    ),
    
    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: ModernColors.gray100,
      selectedColor: ModernColors.primaryLight,
      disabledColor: ModernColors.gray200,
      labelStyle: _textTheme.labelMedium?.copyWith(
        color: ModernColors.gray700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ModernRadius.full),
      ),
      side: const BorderSide(
        color: ModernColors.gray200,
        width: 1,
      ),
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: ModernColors.primary,
      foregroundColor: ModernColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(ModernRadius.button)),
      ),
    ),
    
    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ModernColors.primary,
      linearTrackColor: ModernColors.gray200,
      circularTrackColor: ModernColors.gray200,
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: ModernColors.divider,
      thickness: 1,
      space: 1,
    ),
  );

  // Dark Theme - Secondary Design (Modern dark mode)
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: primaryFont,
    textTheme: _textTheme,
    
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: ModernColors.primary,
      onPrimary: ModernColors.white,
      primaryContainer: ModernColors.primaryDark,
      onPrimaryContainer: ModernColors.primaryLight,
      
      secondary: ModernColors.secondary,
      onSecondary: ModernColors.white,
      secondaryContainer: ModernColors.secondaryDark,
      onSecondaryContainer: ModernColors.secondaryLight,
      
      tertiary: ModernColors.accent,
      onTertiary: ModernColors.white,
      tertiaryContainer: ModernColors.accentDark,
      onTertiaryContainer: ModernColors.accentLight,
      
      error: ModernColors.error,
      onError: ModernColors.white,
      errorContainer: ModernColors.errorDark,
      onErrorContainer: ModernColors.errorLight,
      
      surface: ModernColors.dark100,
      onSurface: ModernColors.dark800,
      surfaceVariant: ModernColors.dark50,
      onSurfaceVariant: ModernColors.dark600,
      
      background: ModernColors.dark50,
      onBackground: ModernColors.dark800,
      
      outline: ModernColors.dark200,
      outlineVariant: ModernColors.dark100,
      
      inverseSurface: ModernColors.gray100,
      onInverseSurface: ModernColors.gray900,
      inversePrimary: ModernColors.primaryDark,
      
      shadow: ModernColors.black,
      scrim: ModernColors.black,
      
      surfaceTint: ModernColors.primary,
    ),
    
    scaffoldBackgroundColor: ModernColors.dark50,
    dividerColor: ModernColors.dividerDark,
    
    // Dark mode specific configurations follow same pattern as light theme
    // but with dark colors...
    
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: ModernColors.dark800,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: _textTheme.titleLarge?.copyWith(
        color: ModernColors.dark800,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(
        color: ModernColors.dark600,
        size: 24,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 0,
      color: ModernColors.dark100,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ModernRadius.card),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: ModernSpacing.md,
        vertical: ModernSpacing.sm,
      ),
    ),
    
    // Continue with other dark theme configurations...
    // (Following same pattern as light theme but with dark variants)
  );
}

// Animation Curves for Modern Feel
class ModernCurves {
  static const Curve easeInOutQuart = Cubic(0.77, 0, 0.175, 1);
  static const Curve easeOutQuart = Cubic(0.25, 1, 0.5, 1);
  static const Curve easeInQuart = Cubic(0.5, 0, 0.75, 0);
  static const Curve spring = Cubic(0.34, 1.56, 0.64, 1);
  static const Curve bounce = Cubic(0.68, -0.55, 0.265, 1.55);
}

// Animation Durations for Consistency
class ModernDuration {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
}

// Helper Extensions
extension ModernThemeExtensions on ThemeData {
  bool get isLight => brightness == Brightness.light;
  bool get isDark => brightness == Brightness.dark;
  
  Color get glassSurface => isLight 
    ? ModernColors.white.withOpacity(0.7)
    : ModernColors.dark100.withOpacity(0.7);
    
  List<BoxShadow> get modernShadow => isLight 
    ? ModernShadows.medium 
    : ModernShadows.glass;
}