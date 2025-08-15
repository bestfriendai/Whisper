import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Modern 2025 color system inspired by successful dating apps
// Using warm, approachable colors with a minimalist approach
class ModernColors {
  // Primary - Warm coral/salmon inspired by human connection
  static const Color primary = Color(0xFFFF6B6B);
  static const Color primaryLight = Color(0xFFFF8787);
  static const Color primaryDark = Color(0xFFEE5A5A);
  
  // Secondary - Deep charcoal for contrast
  static const Color secondary = Color(0xFF2B2D42);
  static const Color secondaryLight = Color(0xFF3D3F54);
  static const Color secondaryDark = Color(0xFF1A1B2E);
  
  // Accent - Soft mint green for positive actions
  static const Color accent = Color(0xFF4ECDC4);
  static const Color accentLight = Color(0xFF6FD8D0);
  static const Color accentDark = Color(0xFF3DB5AC);
  
  // Neutral palette - Natural grays
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
  
  // Semantic colors
  static const Color success = Color(0xFF52C41A);
  static const Color warning = Color(0xFFFFA940);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF1890FF);
  
  // Surface colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F9FA);
  static const Color background = Color(0xFFFCFCFC);
  
  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textTertiary = Color(0xFF99A1A8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Special colors
  static const Color online = Color(0xFF52C41A);
  static const Color offline = Color(0xFFBDBDBD);
  static const Color like = Color(0xFFFF6B6B);
  static const Color superLike = Color(0xFF4ECDC4);
  static const Color match = Color(0xFFFFD700);
  
  // Gradients - Subtle and modern
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient neutralGradient = LinearGradient(
    colors: [neutral100, Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class ModernTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: ModernColors.primary,
        primaryContainer: ModernColors.primaryLight,
        secondary: ModernColors.secondary,
        secondaryContainer: ModernColors.secondaryLight,
        tertiary: ModernColors.accent,
        tertiaryContainer: ModernColors.accentLight,
        surface: ModernColors.surface,
        surfaceVariant: ModernColors.surfaceVariant,
        background: ModernColors.background,
        error: ModernColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: ModernColors.textPrimary,
        onBackground: ModernColors.textPrimary,
        onError: Colors.white,
        outline: ModernColors.neutral300,
        shadow: Color(0x1A000000),
      ),
      
      // Typography - Clean and modern
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        // Display
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          height: 1.3,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.3,
        ),
        
        // Headline
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.4,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
          height: 1.4,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          height: 1.5,
        ),
        
        // Title
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.5,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.5,
        ),
        
        // Body
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
          height: 1.5,
        ),
        
        // Label
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.4,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          height: 1.4,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          height: 1.4,
        ),
      ),
      
      // Components
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: ModernColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(
          color: ModernColors.textPrimary,
          size: 24,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ModernColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ModernColors.primary,
          side: const BorderSide(color: ModernColors.neutral300, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ModernColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ModernColors.neutral200, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ModernColors.neutral50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ModernColors.neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ModernColors.neutral200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ModernColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ModernColors.error),
        ),
        hintStyle: const TextStyle(
          color: ModernColors.textTertiary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: ModernColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: ModernColors.neutral100,
        selectedColor: ModernColors.primary.withOpacity(0.1),
        secondarySelectedColor: ModernColors.primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ModernColors.textPrimary,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ModernColors.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: ModernColors.primary,
        unselectedItemColor: ModernColors.neutral500,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      dividerTheme: const DividerThemeData(
        color: ModernColors.neutral200,
        thickness: 1,
        space: 0,
      ),
      
      scaffoldBackgroundColor: ModernColors.background,
    );
  }
  
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Dark mode color scheme
      colorScheme: ColorScheme.dark(
        primary: ModernColors.primary,
        primaryContainer: ModernColors.primaryDark,
        secondary: ModernColors.accent,
        secondaryContainer: ModernColors.accentDark,
        tertiary: ModernColors.secondary,
        tertiaryContainer: ModernColors.secondaryDark,
        surface: const Color(0xFF1A1A1A),
        surfaceVariant: const Color(0xFF252525),
        background: const Color(0xFF121212),
        error: ModernColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: Colors.white.withOpacity(0.95),
        onBackground: Colors.white.withOpacity(0.95),
        onError: Colors.white,
        outline: Colors.white.withOpacity(0.12),
        shadow: Colors.black.withOpacity(0.3),
      ),
      
      // Use the same typography
      fontFamily: 'Inter',
      
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}

// Extension for easy gradient access
extension GradientExtension on LinearGradient {
  LinearGradient scale(double factor) {
    return LinearGradient(
      colors: colors.map((c) => Color.lerp(c, Colors.white, 1 - factor)!).toList(),
      begin: begin,
      end: end,
      stops: stops,
    );
  }
}