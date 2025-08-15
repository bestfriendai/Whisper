import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// LockerRoom Talk - Sports Theme System
class LockerRoomColors {
  // Primary Sports Colors
  static const navyBlue = Color(0xFF1B2951); // Deep Navy - Trust & Leadership
  static const athleticGreen = Color(0xFF2E7D32); // Energy & Vitality
  static const championshipGold = Color(0xFFFFB300); // Achievement & Premium
  
  // Sports Accent Colors
  static const basketballOrange = Color(0xFFFF6B35);
  static const footballBrown = Color(0xFF8B4513);
  static const soccerGreen = Color(0xFF228B22);
  static const baseballRed = Color(0xFFDC143C);
  static const hockeyBlue = Color(0xFF0047AB);
  static const tennisYellow = Color(0xFFFFD700);
  static const trackRed = Color(0xFFE53935);
  static const swimBlue = Color(0xFF00ACC1);
  
  // UI System Colors
  static const fieldGreen = Color(0xFF4CAF50);
  static const courtBlue = Color(0xFF2196F3);
  static const stadiumGray = Color(0xFF607D8B);
  static const scoreboardBlack = Color(0xFF212121);
  
  // Neutral Palette - Stadium Inspired
  static const neutral900 = Color(0xFF0D1117); // Night game black
  static const neutral800 = Color(0xFF161B22); // Locker room dark
  static const neutral700 = Color(0xFF21262D); // Equipment gray
  static const neutral600 = Color(0xFF30363D); // Jersey gray
  static const neutral500 = Color(0xFF484F58); // Stadium concrete
  static const neutral400 = Color(0xFF6E7681); // Scoreboard text
  static const neutral300 = Color(0xFF8B949E); // Field lines
  static const neutral200 = Color(0xFFC9D1D9); // Light chalk
  static const neutral100 = Color(0xFFF0F6FC); // Clean white
  static const neutral50 = Color(0xFFFAFBFC); // Stadium lights
  
  // Semantic Colors
  static const victory = Color(0xFF10B981); // Win green
  static const defeat = Color(0xFFEF4444); // Loss red
  static const warning = Color(0xFFF59E0B); // Penalty yellow
  static const info = Color(0xFF3B82F6); // Stats blue
  
  // Feature Colors
  static const mvp = Color(0xFFFFD700); // Gold star
  static const rookie = Color(0xFF00BCD4); // Fresh talent
  static const veteran = Color(0xFF9C27B0); // Experience purple
  static const allStar = Color(0xFFFF5722); // All-star orange
  static const verified = Color(0xFF22C55E); // Verified checkmark
  
  // Premium Gradients - Sports Themed
  static const championshipGradient = LinearGradient(
    colors: [navyBlue, Color(0xFF2C3E7E), championshipGold],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const fieldGradient = LinearGradient(
    colors: [Color(0xFF1B5E20), athleticGreen, Color(0xFF4CAF50)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const courtGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF1976D2), Color(0xFF42A5F5)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const victoryGradient = LinearGradient(
    colors: [championshipGold, Color(0xFFFFCA28), Color(0xFFFFE082)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const teamSpiritGradient = LinearGradient(
    colors: [navyBlue, athleticGreen, championshipGold],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const energyGradient = LinearGradient(
    colors: [basketballOrange, trackRed, tennisYellow],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Glass Morphism - Trophy Case Style
  static const trophyGlass = Color(0x1AFFD700);
  static const trophyGlassStroke = Color(0x33FFD700);
  static const lockerGlass = Color(0x1A1B2951);
  static const lockerGlassStroke = Color(0x331B2951);
  
  // Shadow System - Stadium Lighting
  static const shadowField = Color(0x1A2E7D32);
  static const shadowCourt = Color(0x1A2196F3);
  static const shadowStadium = Color(0x15000000);
  static const shadowSpotlight = Color(0x25FFD700);
}

class LockerRoomTheme {
  // Typography - Bold Athletic Style
  static const _fontFamily = 'SF Pro Display';
  
  static TextTheme get _textTheme => const TextTheme(
    // Display - Stadium Announcer Style
    displayLarge: TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.w900,
      height: 1.1,
      letterSpacing: -1.5,
      fontFamily: _fontFamily,
    ),
    displayMedium: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      height: 1.15,
      letterSpacing: -0.5,
      fontFamily: _fontFamily,
    ),
    displaySmall: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.2,
      fontFamily: _fontFamily,
    ),
    
    // Headlines - Scoreboard Style
    headlineLarge: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      height: 1.22,
      letterSpacing: -0.5,
      fontFamily: _fontFamily,
    ),
    headlineMedium: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      height: 1.26,
      fontFamily: _fontFamily,
    ),
    headlineSmall: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      height: 1.3,
      fontFamily: _fontFamily,
    ),
    
    // Titles - Jersey Numbers
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.25,
      fontFamily: _fontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.15,
      fontFamily: _fontFamily,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.38,
      letterSpacing: 0.1,
      fontFamily: _fontFamily,
    ),
    
    // Labels - Team Stats
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.1,
      fontFamily: _fontFamily,
    ),
    labelMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      height: 1.38,
      letterSpacing: 0.5,
      fontFamily: _fontFamily,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.42,
      letterSpacing: 0.5,
      fontFamily: _fontFamily,
    ),
    
    // Body - Play-by-Play
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.47,
      letterSpacing: 0.15,
      fontFamily: _fontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.4,
      letterSpacing: 0.25,
      fontFamily: _fontFamily,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.38,
      letterSpacing: 0.4,
      fontFamily: _fontFamily,
    ),
  );

  // Dark Theme - Locker Room Style
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: _fontFamily,
    textTheme: _textTheme,
    
    colorScheme: const ColorScheme.dark(
      primary: LockerRoomColors.navyBlue,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF2C3E7E),
      onPrimaryContainer: LockerRoomColors.neutral100,
      
      secondary: LockerRoomColors.athleticGreen,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF1B5E20),
      onSecondaryContainer: LockerRoomColors.neutral100,
      
      tertiary: LockerRoomColors.championshipGold,
      onTertiary: LockerRoomColors.scoreboardBlack,
      
      error: LockerRoomColors.defeat,
      onError: Colors.white,
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFEE2E2),
      
      surface: LockerRoomColors.neutral900,
      onSurface: LockerRoomColors.neutral100,
      surfaceContainerHighest: LockerRoomColors.neutral800,
      onSurfaceVariant: LockerRoomColors.neutral300,
      
      outline: LockerRoomColors.neutral600,
      outlineVariant: LockerRoomColors.neutral700,
      
      inverseSurface: LockerRoomColors.neutral100,
      onInverseSurface: LockerRoomColors.neutral900,
      inversePrimary: LockerRoomColors.navyBlue,
      
      shadow: Colors.black38,
      scrim: Colors.black54,
    ),
    
    scaffoldBackgroundColor: LockerRoomColors.neutral900,
    
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: LockerRoomColors.neutral900,
      foregroundColor: LockerRoomColors.neutral100,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: _textTheme.headlineSmall?.copyWith(
        color: LockerRoomColors.neutral100,
        fontWeight: FontWeight.w800,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 0,
      color: LockerRoomColors.neutral800,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: LockerRoomColors.neutral700.withOpacity(0.5),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: LockerRoomColors.navyBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        minimumSize: const Size(120, 56),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: LockerRoomColors.neutral100,
        side: const BorderSide(color: LockerRoomColors.neutral600, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        minimumSize: const Size(120, 56),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: LockerRoomColors.athleticGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LockerRoomColors.neutral800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LockerRoomColors.neutral700, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LockerRoomColors.neutral700, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LockerRoomColors.athleticGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LockerRoomColors.defeat, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: _textTheme.bodyMedium?.copyWith(
        color: LockerRoomColors.neutral400,
      ),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: LockerRoomColors.neutral900,
      selectedItemColor: LockerRoomColors.athleticGreen,
      unselectedItemColor: LockerRoomColors.neutral500,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    
    chipTheme: ChipThemeData(
      backgroundColor: LockerRoomColors.neutral800,
      selectedColor: LockerRoomColors.navyBlue,
      labelStyle: _textTheme.labelMedium?.copyWith(
        color: LockerRoomColors.neutral300,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: LockerRoomColors.neutral700, width: 1),
      ),
    ),
    
    dividerTheme: const DividerThemeData(
      color: LockerRoomColors.neutral700,
      thickness: 1,
      space: 1,
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
      highlightElevation: 6,
      backgroundColor: LockerRoomColors.athleticGreen,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
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

  // Light Theme - Stadium Day Game
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: _fontFamily,
    textTheme: _textTheme,
    
    colorScheme: const ColorScheme.light(
      primary: LockerRoomColors.navyBlue,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE3F2FD),
      onPrimaryContainer: LockerRoomColors.navyBlue,
      
      secondary: LockerRoomColors.athleticGreen,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFE8F5E9),
      onSecondaryContainer: Color(0xFF1B5E20),
      
      tertiary: LockerRoomColors.championshipGold,
      onTertiary: LockerRoomColors.scoreboardBlack,
      
      error: LockerRoomColors.defeat,
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF7F1D1D),
      
      surface: Colors.white,
      onSurface: LockerRoomColors.neutral900,
      surfaceContainerHighest: LockerRoomColors.neutral50,
      onSurfaceVariant: LockerRoomColors.neutral600,
      
      outline: LockerRoomColors.neutral300,
      outlineVariant: LockerRoomColors.neutral200,
      
      inverseSurface: LockerRoomColors.neutral800,
      onInverseSurface: LockerRoomColors.neutral100,
      inversePrimary: Color(0xFF90CAF9),
      
      shadow: Colors.black12,
      scrim: Colors.black26,
    ),
    
    scaffoldBackgroundColor: LockerRoomColors.neutral50,
    
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: LockerRoomColors.neutral50,
      foregroundColor: LockerRoomColors.neutral900,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: _textTheme.headlineSmall?.copyWith(
        color: LockerRoomColors.neutral900,
        fontWeight: FontWeight.w800,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: LockerRoomColors.neutral200.withOpacity(0.8),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: LockerRoomColors.navyBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        minimumSize: const Size(120, 56),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: LockerRoomColors.navyBlue,
        side: const BorderSide(color: LockerRoomColors.navyBlue, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        minimumSize: const Size(120, 56),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: LockerRoomColors.navyBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LockerRoomColors.neutral300, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LockerRoomColors.neutral300, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LockerRoomColors.navyBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LockerRoomColors.defeat, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: _textTheme.bodyMedium?.copyWith(
        color: LockerRoomColors.neutral500,
      ),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.white,
      selectedItemColor: LockerRoomColors.navyBlue,
      unselectedItemColor: LockerRoomColors.neutral400,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    
    chipTheme: ChipThemeData(
      backgroundColor: LockerRoomColors.neutral100,
      selectedColor: LockerRoomColors.navyBlue,
      labelStyle: _textTheme.labelMedium?.copyWith(
        color: LockerRoomColors.neutral700,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: LockerRoomColors.neutral200, width: 1),
      ),
    ),
    
    dividerTheme: const DividerThemeData(
      color: LockerRoomColors.neutral200,
      thickness: 1,
      space: 1,
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
      highlightElevation: 6,
      backgroundColor: LockerRoomColors.navyBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
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