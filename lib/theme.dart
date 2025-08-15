import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Ultra-Modern Extensions for Enhanced UI
extension GradientExtensions on LinearGradient {
  LinearGradient scale(double opacity) {
    return LinearGradient(
      colors: colors.map((color) => color.withValues(alpha: opacity)).toList(),
      stops: stops,
      begin: begin,
      end: end,
    );
  }
}

// FAANG-Level Modern Design System Colors
class AppColors {
  // Premium Brand Colors - Dating App Optimized
  static const primary = Color(0xFFFF6B6B); // Passionate Coral - love & connection
  static const primaryDark = Color(0xFFE55555);
  static const secondary = Color(0xFF4ECDC4); // Calming Teal - trust & harmony
  static const accent = Color(0xFFFFE66D); // Warm Gold - premium & warmth
  
  // Neutral Palette - Clean & Contemporary
  static const neutral900 = Color(0xFF111827); // Dark backgrounds
  static const neutral800 = Color(0xFF1F2937);
  static const neutral700 = Color(0xFF374151);
  static const neutral600 = Color(0xFF4B5563);
  static const neutral500 = Color(0xFF6B7280);
  static const neutral400 = Color(0xFF9CA3AF);
  static const neutral300 = Color(0xFFD1D5DB);
  static const neutral200 = Color(0xFFE5E7EB);
  static const neutral100 = Color(0xFFF3F4F6);
  static const neutral50 = Color(0xFFF9FAFB);
  
  // Semantic Colors
  static const success = Color(0xFF059669);
  static const warning = Color(0xFFD97706);
  static const error = Color(0xFFDC2626);
  static const info = Color(0xFF2563EB);
  
  // Dating App Specific - Enhanced
  static const like = Color(0xFFFF6B9D); // Romantic Pink
  static const superlike = Color(0xFF6366F1); // Premium Purple  
  static const match = Color(0xFF4ECDC4); // Success Teal
  static const online = Color(0xFF00D4AA); // Active Green
  static const verified = Color(0xFFFFD93D); // Gold Verification
  
  // Ultra-Premium Gradients - Enhanced Depth & Vibrancy
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF4757), Color(0xFFFF8E8E)],
    stops: [0.0, 0.6, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFF4ECDC4), Color(0xFF2ED5C5), Color(0xFF7FDBDA)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft, 
    end: Alignment.bottomRight,
  );
  
  static const accentGradient = LinearGradient(
    colors: [Color(0xFFFFE66D), Color(0xFFFFD93D), Color(0xFFFFEB95)],
    stops: [0.0, 0.4, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Ultra-Modern 3D Gradients
  static const neuralGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF7B7B), Color(0xFFFF9068), Color(0xFFFFB347)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const oceanGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF64B5F6), Color(0xFF4FC3F7)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Sophisticated Mesh Gradients
  static const meshGradient1 = LinearGradient(
    colors: [
      Color(0xFFFF6B9D),
      Color(0xFFC44569),
      Color(0xFF9C88FF),
      Color(0xFF6C5CE7),
    ],
    stops: [0.0, 0.33, 0.66, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const meshGradient2 = LinearGradient(
    colors: [
      Color(0xFF4ECDC4),
      Color(0xFF45B7AF),
      Color(0xFF0DD5BC),
      Color(0xFF00CEC9),
    ],
    stops: [0.0, 0.33, 0.66, 1.0],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
  
  // Ultra-Premium Glass Morphism System
  static const glassBg = Color(0x1AFFFFFF);
  static const glassStroke = Color(0x33FFFFFF);
  static const glassBgDark = Color(0x1A000000);
  static const glassStrokeDark = Color(0x33000000);
  
  // Advanced Blur Effects
  static const ultraGlassBg = Color(0x0FFFFFFF);
  static const ultraGlassStroke = Color(0x22FFFFFF);
  static const neonGlassBg = Color(0x15FF6B6B);
  static const neonGlassStroke = Color(0x44FF6B6B);
  
  // Premium Shadow System
  static const shadowPrimary = Color(0x1AFF6B6B);
  static const shadowSecondary = Color(0x1A4ECDC4);
  static const shadowNeutral = Color(0x0A000000);
  static const shadowElevated = Color(0x15000000);
  
  // Surface Variations
  static const surfaceElevated = Color(0xFFFFFBFE);
  static const surfaceElevatedDark = Color(0xFF1C1B20);
  static const cardSurface = Color(0xFFFAFAFA);
  static const cardSurfaceDark = Color(0xFF2A2930);
}

class AppTheme {
  // Typography Scale - Modern & Clean
  static const _fontFamily = 'SF Pro Display';
  
  static TextTheme get _textTheme => const TextTheme(
    // Display Styles - Bold & Impactful
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w800,
      height: 1.12,
      letterSpacing: -0.25,
      fontFamily: _fontFamily,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      height: 1.16,
      fontFamily: _fontFamily,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      height: 1.22,
      fontFamily: _fontFamily,
    ),
    
    // Headline Styles
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: -0.5,
      fontFamily: _fontFamily,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.29,
      fontFamily: _fontFamily,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.33,
      fontFamily: _fontFamily,
    ),
    
    // Title Styles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.27,
      fontFamily: _fontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0.15,
      fontFamily: _fontFamily,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.43,
      letterSpacing: 0.1,
      fontFamily: _fontFamily,
    ),
    
    // Label Styles
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.1,
      fontFamily: _fontFamily,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.33,
      letterSpacing: 0.5,
      fontFamily: _fontFamily,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.45,
      letterSpacing: 0.5,
      fontFamily: _fontFamily,
    ),
    
    // Body Styles
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.15,
      fontFamily: _fontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
      fontFamily: _fontFamily,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: 0.4,
      fontFamily: _fontFamily,
    ),
  );

  // Dark Theme - Primary Design
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: _fontFamily,
    textTheme: _textTheme,
    
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.neutral100,
      
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.neutral800,
      onSecondaryContainer: AppColors.neutral100,
      
      tertiary: AppColors.like,
      onTertiary: Colors.white,
      
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      
      surface: AppColors.neutral900,
      onSurface: AppColors.neutral100,
      surfaceVariant: AppColors.neutral800,
      onSurfaceVariant: AppColors.neutral300,
      
      background: AppColors.neutral900,
      onBackground: AppColors.neutral100,
      
      outline: AppColors.neutral600,
      outlineVariant: AppColors.neutral700,
      
      inverseSurface: AppColors.neutral100,
      onInverseSurface: AppColors.neutral900,
      inversePrimary: AppColors.primaryDark,
      
      shadow: Colors.black26,
      scrim: Colors.black54,
    ),
    
    scaffoldBackgroundColor: AppColors.neutral900,
    
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.neutral900,
      foregroundColor: AppColors.neutral100,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: _textTheme.headlineSmall?.copyWith(
        color: AppColors.neutral100,
        fontWeight: FontWeight.w700,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.cardSurfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: AppColors.neutral700.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(120, 56),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.neutral100,
        side: const BorderSide(color: AppColors.neutral600, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(120, 56),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutral800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.neutral700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.neutral700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: _textTheme.bodyMedium?.copyWith(
        color: AppColors.neutral400,
      ),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: AppColors.neutral900,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.neutral500,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.neutral800,
      selectedColor: AppColors.primary,
      labelStyle: _textTheme.labelMedium?.copyWith(
        color: AppColors.neutral300,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.neutral700),
      ),
    ),
    
    dividerTheme: const DividerThemeData(
      color: AppColors.neutral700,
      thickness: 1,
      space: 1,
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      highlightElevation: 4,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
    ),
    
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Colors.transparent,
    ),
  );

  // Light Theme - Secondary Design
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: _fontFamily,
    textTheme: _textTheme,
    
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE0E7FF),
      onPrimaryContainer: AppColors.primaryDark,
      
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFD1FAE5),
      onSecondaryContainer: Color(0xFF064E3B),
      
      tertiary: AppColors.like,
      onTertiary: Colors.white,
      
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      
      surface: Colors.white,
      onSurface: AppColors.neutral900,
      surfaceVariant: AppColors.neutral50,
      onSurfaceVariant: AppColors.neutral600,
      
      background: AppColors.neutral50,
      onBackground: AppColors.neutral900,
      
      outline: AppColors.neutral300,
      outlineVariant: AppColors.neutral200,
      
      inverseSurface: AppColors.neutral800,
      onInverseSurface: AppColors.neutral100,
      inversePrimary: Color(0xFFBBC3FF),
      
      shadow: Colors.black12,
      scrim: Colors.black26,
    ),
    
    scaffoldBackgroundColor: AppColors.neutral50,
    
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.neutral50,
      foregroundColor: AppColors.neutral900,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: _textTheme.headlineSmall?.copyWith(
        color: AppColors.neutral900,
        fontWeight: FontWeight.w700,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.cardSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: AppColors.neutral200.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(120, 56),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.neutral900,
        side: const BorderSide(color: AppColors.neutral300, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(120, 56),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.neutral300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.neutral300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: _textTheme.bodyMedium?.copyWith(
        color: AppColors.neutral500,
      ),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.neutral400,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.neutral100,
      selectedColor: AppColors.primary,
      labelStyle: _textTheme.labelMedium?.copyWith(
        color: AppColors.neutral700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.neutral200),
      ),
    ),
    
    dividerTheme: const DividerThemeData(
      color: AppColors.neutral200,
      thickness: 1,
      space: 1,
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      highlightElevation: 4,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
    ),
    
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Colors.transparent,
    ),
  );
}