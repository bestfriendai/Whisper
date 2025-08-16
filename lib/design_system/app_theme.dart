import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';

/// Unified App Theme System
/// 
/// Provides consistent light and dark themes using the consolidated design tokens.
/// Replaces all previous theme files with a single, maintainable solution.
class AppTheme {
  AppTheme._();

  // ============================================================================
  // LIGHT THEME
  // ============================================================================
  
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: DesignTokens.textTheme,
    
    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: DesignTokens.primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE1BEE7),
      onPrimaryContainer: DesignTokens.primaryDark,
      
      secondary: DesignTokens.secondary,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFB2F2E6),
      onSecondaryContainer: DesignTokens.secondaryDark,
      
      tertiary: DesignTokens.accent,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFFD6E1),
      onTertiaryContainer: DesignTokens.accentDark,
      
      error: DesignTokens.error,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      
      surface: DesignTokens.surfaceLight,
      onSurface: DesignTokens.neutral900,
      surfaceVariant: DesignTokens.neutral50,
      onSurfaceVariant: DesignTokens.neutral600,
      
      background: DesignTokens.backgroundLight,
      onBackground: DesignTokens.neutral900,
      
      outline: DesignTokens.neutral300,
      outlineVariant: DesignTokens.neutral200,
      
      shadow: Colors.black12,
      scrim: Colors.black26,
    ),
    
    scaffoldBackgroundColor: DesignTokens.backgroundLight,
    
    // App Bar
    appBarTheme: AppBarTheme(
      elevation: DesignTokens.elevation0,
      centerTitle: false,
      backgroundColor: DesignTokens.backgroundLight,
      foregroundColor: DesignTokens.neutral900,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: DesignTokens.textTheme.headlineMedium?.copyWith(
        color: DesignTokens.neutral900,
        fontWeight: FontWeight.w700,
      ),
      toolbarHeight: DesignTokens.buttonHeightXLarge,
    ),
    
    // Cards
    cardTheme: CardThemeData(
      elevation: DesignTokens.elevation0,
      color: DesignTokens.surfaceLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        side: BorderSide(
          color: DesignTokens.neutral200,
          width: 0.5,
        ),
      ),
      margin: const EdgeInsets.all(DesignTokens.spacingSmall),
      shadowColor: DesignTokens.neutral900.withOpacity(0.1),
    ),
    
    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: DesignTokens.elevation0,
        backgroundColor: DesignTokens.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLarge,
          vertical: DesignTokens.spacingMedium,
        ),
        textStyle: DesignTokens.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(120, DesignTokens.buttonHeightLarge),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: DesignTokens.elevation0,
        foregroundColor: DesignTokens.primary,
        side: const BorderSide(color: DesignTokens.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLarge,
          vertical: DesignTokens.spacingMedium,
        ),
        textStyle: DesignTokens.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(120, DesignTokens.buttonHeightLarge),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DesignTokens.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMedium,
          vertical: DesignTokens.spacingSmall,
        ),
        textStyle: DesignTokens.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMedium,
        vertical: DesignTokens.spacingMedium,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(color: DesignTokens.neutral300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(color: DesignTokens.neutral300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(color: DesignTokens.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(color: DesignTokens.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(color: DesignTokens.error, width: 2),
      ),
      labelStyle: DesignTokens.textTheme.bodyMedium?.copyWith(
        color: DesignTokens.neutral600,
      ),
      hintStyle: DesignTokens.textTheme.bodyMedium?.copyWith(
        color: DesignTokens.neutral500,
      ),
    ),
    
    // Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: DesignTokens.elevation4,
      backgroundColor: DesignTokens.surfaceLight,
      selectedItemColor: DesignTokens.primary,
      unselectedItemColor: DesignTokens.neutral400,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedLabelStyle: DesignTokens.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: DesignTokens.textTheme.labelSmall,
    ),
    
    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: DesignTokens.neutral100,
      selectedColor: DesignTokens.primary.withOpacity(0.12),
      checkmarkColor: DesignTokens.primary,
      labelStyle: DesignTokens.textTheme.labelMedium?.copyWith(
        color: DesignTokens.neutral700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusRound),
        side: const BorderSide(color: DesignTokens.neutral200),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMedium,
        vertical: DesignTokens.spacingSmall,
      ),
    ),
    
    // Dividers
    dividerTheme: const DividerThemeData(
      color: DesignTokens.neutral200,
      thickness: 1,
      space: 1,
    ),
    
    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: DesignTokens.elevation4,
      highlightElevation: DesignTokens.elevation8,
      backgroundColor: DesignTokens.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXLarge),
      ),
    ),
    
    // List Tiles
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMedium,
        vertical: DesignTokens.spacingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      tileColor: Colors.transparent,
    ),
    
    // Icons
    iconTheme: const IconThemeData(
      color: DesignTokens.neutral600,
      size: DesignTokens.iconSizeLarge,
    ),
  );

  // ============================================================================
  // DARK THEME
  // ============================================================================
  
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: DesignTokens.textTheme.apply(
      bodyColor: DesignTokens.neutral100,
      displayColor: DesignTokens.neutral100,
    ),
    
    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: DesignTokens.primary,
      onPrimary: Colors.white,
      primaryContainer: DesignTokens.primaryDark,
      onPrimaryContainer: DesignTokens.neutral100,
      
      secondary: DesignTokens.secondary,
      onSecondary: Colors.white,
      secondaryContainer: DesignTokens.secondaryDark,
      onSecondaryContainer: DesignTokens.neutral100,
      
      tertiary: DesignTokens.accent,
      onTertiary: Colors.white,
      tertiaryContainer: DesignTokens.accentDark,
      onTertiaryContainer: DesignTokens.neutral100,
      
      error: DesignTokens.error,
      onError: Colors.white,
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      
      surface: DesignTokens.surfaceDark,
      onSurface: DesignTokens.neutral100,
      surfaceVariant: DesignTokens.neutral800,
      onSurfaceVariant: DesignTokens.neutral300,
      
      background: DesignTokens.backgroundDark,
      onBackground: DesignTokens.neutral100,
      
      outline: DesignTokens.neutral600,
      outlineVariant: DesignTokens.neutral700,
      
      shadow: Colors.black26,
      scrim: Colors.black54,
    ),
    
    scaffoldBackgroundColor: DesignTokens.backgroundDark,
    
    // App Bar
    appBarTheme: AppBarTheme(
      elevation: DesignTokens.elevation0,
      centerTitle: false,
      backgroundColor: DesignTokens.backgroundDark,
      foregroundColor: DesignTokens.neutral100,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: DesignTokens.textTheme.headlineMedium?.copyWith(
        color: DesignTokens.neutral100,
        fontWeight: FontWeight.w700,
      ),
      toolbarHeight: DesignTokens.buttonHeightXLarge,
    ),
    
    // Cards
    cardTheme: CardThemeData(
      elevation: DesignTokens.elevation0,
      color: DesignTokens.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        side: BorderSide(
          color: DesignTokens.neutral700.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      margin: const EdgeInsets.all(DesignTokens.spacingSmall),
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    
    // Buttons (inherit from light theme with color adjustments)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: DesignTokens.elevation0,
        backgroundColor: DesignTokens.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLarge,
          vertical: DesignTokens.spacingMedium,
        ),
        textStyle: DesignTokens.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(120, DesignTokens.buttonHeightLarge),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: DesignTokens.elevation0,
        foregroundColor: DesignTokens.neutral100,
        side: const BorderSide(color: DesignTokens.neutral600, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLarge,
          vertical: DesignTokens.spacingMedium,
        ),
        textStyle: DesignTokens.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(120, DesignTokens.buttonHeightLarge),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DesignTokens.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMedium,
          vertical: DesignTokens.spacingSmall,
        ),
        textStyle: DesignTokens.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.neutral800,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMedium,
        vertical: DesignTokens.spacingMedium,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(color: DesignTokens.neutral700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(color: DesignTokens.neutral700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(color: DesignTokens.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(color: DesignTokens.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(color: DesignTokens.error, width: 2),
      ),
      labelStyle: DesignTokens.textTheme.bodyMedium?.copyWith(
        color: DesignTokens.neutral400,
      ),
      hintStyle: DesignTokens.textTheme.bodyMedium?.copyWith(
        color: DesignTokens.neutral500,
      ),
    ),
    
    // Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: DesignTokens.elevation4,
      backgroundColor: DesignTokens.surfaceDark,
      selectedItemColor: DesignTokens.primary,
      unselectedItemColor: DesignTokens.neutral500,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedLabelStyle: DesignTokens.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: DesignTokens.textTheme.labelSmall,
    ),
    
    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: DesignTokens.neutral800,
      selectedColor: DesignTokens.primary.withOpacity(0.2),
      checkmarkColor: DesignTokens.primary,
      labelStyle: DesignTokens.textTheme.labelMedium?.copyWith(
        color: DesignTokens.neutral300,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusRound),
        side: const BorderSide(color: DesignTokens.neutral700),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMedium,
        vertical: DesignTokens.spacingSmall,
      ),
    ),
    
    // Dividers
    dividerTheme: const DividerThemeData(
      color: DesignTokens.neutral700,
      thickness: 1,
      space: 1,
    ),
    
    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: DesignTokens.elevation4,
      highlightElevation: DesignTokens.elevation8,
      backgroundColor: DesignTokens.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXLarge),
      ),
    ),
    
    // List Tiles
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMedium,
        vertical: DesignTokens.spacingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      tileColor: Colors.transparent,
    ),
    
    // Icons
    iconTheme: const IconThemeData(
      color: DesignTokens.neutral400,
      size: DesignTokens.iconSizeLarge,
    ),
  );
}