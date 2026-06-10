import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralised Spotify-style dark theme.
class AppColors {
  AppColors._();

  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color black = Color(0xFF121212);
  static const Color almostBlack = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF181818);
  static const Color cardGrey = Color(0xFF282828);
  static const Color elevatedGrey = Color(0xFF1F1F1F);
  static const Color lightGrey = Color(0xFFB3B3B3);
  static const Color white = Color(0xFFFFFFFF);

  /// Gradient used behind the home header.
  static const List<Color> headerGradient = [
    Color(0xFF1E3A34),
    Color(0xFF121212),
  ];
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.montserratTextTheme(base.textTheme).apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.black,
      canvasColor: AppColors.black,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.spotifyGreen,
        secondary: AppColors.spotifyGreen,
        surface: AppColors.black,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
      sliderTheme: SliderThemeData(
        trackHeight: 4,
        activeTrackColor: AppColors.white,
        inactiveTrackColor: Colors.white24,
        thumbColor: AppColors.white,
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.almostBlack,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.lightGrey,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
