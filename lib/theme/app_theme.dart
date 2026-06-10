import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Default Spotify-style colors kept for compatibility with existing imports.
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

  static const List<Color> headerGradient = [
    Color(0xFF1E3A34),
    Color(0xFF121212),
  ];
}

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color primary;
  final Color background;
  final Color navBackground;
  final Color card;
  final Color elevated;
  final Color text;
  final Color mutedText;
  final Color searchFieldBackground;
  final Color searchFieldText;
  final Color playerButtonBackground;
  final Color playerButtonForeground;
  final Color progressTrack;
  final List<Color> headerGradient;
  final List<Color> nowPlayingGradient;
  final List<Color> likedSongsGradient;
  final String? wallpaperAsset;
  final Color wallpaperOverlay;
  final double wallpaperBlurSigma;
  final double glassBlurSigma;
  final Color? glassColor;
  final Color? glassBorder;

  const AppThemeColors({
    required this.primary,
    required this.background,
    required this.navBackground,
    required this.card,
    required this.elevated,
    required this.text,
    required this.mutedText,
    required this.searchFieldBackground,
    required this.searchFieldText,
    required this.playerButtonBackground,
    required this.playerButtonForeground,
    required this.progressTrack,
    required this.headerGradient,
    required this.nowPlayingGradient,
    required this.likedSongsGradient,
    this.wallpaperAsset,
    this.wallpaperOverlay = Colors.transparent,
    this.wallpaperBlurSigma = 0,
    this.glassBlurSigma = 0,
    this.glassColor,
    this.glassBorder,
  });

  bool get hasWallpaper => wallpaperAsset != null;
  Color get glassSurface => glassColor ?? card;
  Color get glassOutline => glassBorder ?? Colors.transparent;

  @override
  AppThemeColors copyWith({
    Color? primary,
    Color? background,
    Color? navBackground,
    Color? card,
    Color? elevated,
    Color? text,
    Color? mutedText,
    Color? searchFieldBackground,
    Color? searchFieldText,
    Color? playerButtonBackground,
    Color? playerButtonForeground,
    Color? progressTrack,
    List<Color>? headerGradient,
    List<Color>? nowPlayingGradient,
    List<Color>? likedSongsGradient,
    String? wallpaperAsset,
    Color? wallpaperOverlay,
    double? wallpaperBlurSigma,
    double? glassBlurSigma,
    Color? glassColor,
    Color? glassBorder,
  }) {
    return AppThemeColors(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      navBackground: navBackground ?? this.navBackground,
      card: card ?? this.card,
      elevated: elevated ?? this.elevated,
      text: text ?? this.text,
      mutedText: mutedText ?? this.mutedText,
      searchFieldBackground:
          searchFieldBackground ?? this.searchFieldBackground,
      searchFieldText: searchFieldText ?? this.searchFieldText,
      playerButtonBackground:
          playerButtonBackground ?? this.playerButtonBackground,
      playerButtonForeground:
          playerButtonForeground ?? this.playerButtonForeground,
      progressTrack: progressTrack ?? this.progressTrack,
      headerGradient: headerGradient ?? this.headerGradient,
      nowPlayingGradient: nowPlayingGradient ?? this.nowPlayingGradient,
      likedSongsGradient: likedSongsGradient ?? this.likedSongsGradient,
      wallpaperAsset: wallpaperAsset ?? this.wallpaperAsset,
      wallpaperOverlay: wallpaperOverlay ?? this.wallpaperOverlay,
      wallpaperBlurSigma: wallpaperBlurSigma ?? this.wallpaperBlurSigma,
      glassBlurSigma: glassBlurSigma ?? this.glassBlurSigma,
      glassColor: glassColor ?? this.glassColor,
      glassBorder: glassBorder ?? this.glassBorder,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      card: Color.lerp(card, other.card, t)!,
      elevated: Color.lerp(elevated, other.elevated, t)!,
      text: Color.lerp(text, other.text, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      searchFieldBackground: Color.lerp(
        searchFieldBackground,
        other.searchFieldBackground,
        t,
      )!,
      searchFieldText: Color.lerp(searchFieldText, other.searchFieldText, t)!,
      playerButtonBackground: Color.lerp(
        playerButtonBackground,
        other.playerButtonBackground,
        t,
      )!,
      playerButtonForeground: Color.lerp(
        playerButtonForeground,
        other.playerButtonForeground,
        t,
      )!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      headerGradient: _lerpColorList(headerGradient, other.headerGradient, t),
      nowPlayingGradient: _lerpColorList(
        nowPlayingGradient,
        other.nowPlayingGradient,
        t,
      ),
      likedSongsGradient: _lerpColorList(
        likedSongsGradient,
        other.likedSongsGradient,
        t,
      ),
      wallpaperAsset: t < 0.5 ? wallpaperAsset : other.wallpaperAsset,
      wallpaperOverlay:
          Color.lerp(wallpaperOverlay, other.wallpaperOverlay, t)!,
      wallpaperBlurSigma:
          wallpaperBlurSigma +
          ((other.wallpaperBlurSigma - wallpaperBlurSigma) * t),
      glassBlurSigma:
          glassBlurSigma + ((other.glassBlurSigma - glassBlurSigma) * t),
      glassColor: Color.lerp(glassSurface, other.glassSurface, t),
      glassBorder: Color.lerp(glassOutline, other.glassOutline, t),
    );
  }

  static List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    final length = a.length < b.length ? a.length : b.length;
    return List<Color>.generate(
      length,
      (index) => Color.lerp(a[index], b[index], t)!,
    );
  }
}

class AppThemeConfig {
  final String id;
  final String name;
  final AppThemeColors colors;

  const AppThemeConfig({
    required this.id,
    required this.name,
    required this.colors,
  });

  ThemeData get themeData => AppTheme.build(colors);
}

class AppTheme {
  AppTheme._();

  static const String defaultThemeId = 'default_spotify';

  static const AppThemeColors _defaultColors = AppThemeColors(
    primary: AppColors.spotifyGreen,
    background: AppColors.black,
    navBackground: AppColors.almostBlack,
    card: AppColors.cardGrey,
    elevated: AppColors.elevatedGrey,
    text: AppColors.white,
    mutedText: AppColors.lightGrey,
    searchFieldBackground: AppColors.white,
    searchFieldText: AppColors.black,
    playerButtonBackground: AppColors.white,
    playerButtonForeground: AppColors.black,
    progressTrack: Colors.white24,
    headerGradient: AppColors.headerGradient,
    nowPlayingGradient: [Color(0xFF3A3A3A), AppColors.black],
    likedSongsGradient: [Color(0xFF4100F4), Color(0xFF9BB8FF)],
  );

  static const List<AppThemeConfig> themes = [
    AppThemeConfig(
      id: defaultThemeId,
      name: 'Default Spotify Theme',
      colors: _defaultColors,
    ),
    AppThemeConfig(
      id: 'prayag',
      name: 'Prayag Theme',
      colors: AppThemeColors(
        primary: Color(0xFF2F80ED),
        background: Color(0xFFEAF6FF),
        navBackground: Color(0xCCFFFFFF),
        card: Color(0xCCFFFFFF),
        elevated: Color(0x99DCEEFF),
        text: Color(0xFF061F3D),
        mutedText: Color(0xFF496A86),
        searchFieldBackground: Color(0xDDFFFFFF),
        searchFieldText: Color(0xFF061F3D),
        playerButtonBackground: Color(0xFFFFFFFF),
        playerButtonForeground: Color(0xFF0A65C7),
        progressTrack: Color(0x553D8BFF),
        headerGradient: [Color(0x66FFFFFF), Color(0x332F80ED)],
        nowPlayingGradient: [Color(0x66FFFFFF), Color(0x552F80ED)],
        likedSongsGradient: [Color(0xDD2F80ED), Color(0xCCB9E7FF)],
        wallpaperAsset: 'assets/images/prayag_wallpaper.png',
        wallpaperOverlay: Color(0x88F6FBFF),
        wallpaperBlurSigma: 2,
        glassBlurSigma: 18,
        glassColor: Color(0xAAFFFFFF),
        glassBorder: Color(0x66FFFFFF),
      ),
    ),
    AppThemeConfig(
      id: 'sagar',
      name: 'Sagar Theme',
      colors: AppThemeColors(
        primary: Color(0xFF4DA3FF),
        background: Color(0xFF0B1020),
        navBackground: Color(0xFF050814),
        card: Color(0xFF17213A),
        elevated: Color(0xFF213154),
        text: Color(0xFFF5F8FF),
        mutedText: Color(0xFFA9B7D5),
        searchFieldBackground: Color(0xFFEAF2FF),
        searchFieldText: Color(0xFF050814),
        playerButtonBackground: Color(0xFFF5F8FF),
        playerButtonForeground: Color(0xFF050814),
        progressTrack: Color(0x334DA3FF),
        headerGradient: [Color(0xFF123C72), Color(0xFF0B1020)],
        nowPlayingGradient: [Color(0xFF244B80), Color(0xFF0B1020)],
        likedSongsGradient: [Color(0xFF1957D2), Color(0xFF80B8FF)],
      ),
    ),
    AppThemeConfig(
      id: 'vaibhav',
      name: 'Vaibhav Theme',
      colors: AppThemeColors(
        primary: Color(0xFFFFC857),
        background: Color(0xFF17120B),
        navBackground: Color(0xFF090704),
        card: Color(0xFF2A2114),
        elevated: Color(0xFF3A2F1D),
        text: Color(0xFFFFFAEF),
        mutedText: Color(0xFFD2BE93),
        searchFieldBackground: Color(0xFFFFF4D6),
        searchFieldText: Color(0xFF090704),
        playerButtonBackground: Color(0xFFFFFAEF),
        playerButtonForeground: Color(0xFF090704),
        progressTrack: Color(0x33FFC857),
        headerGradient: [Color(0xFF5C3F10), Color(0xFF17120B)],
        nowPlayingGradient: [Color(0xFF6E5220), Color(0xFF17120B)],
        likedSongsGradient: [Color(0xFFB66D00), Color(0xFFFFD982)],
      ),
    ),
    AppThemeConfig(
      id: 'shivli',
      name: 'Shivli Theme',
      colors: AppThemeColors(
        primary: Color(0xFFFF6B9A),
        background: Color(0xFF1A1018),
        navBackground: Color(0xFF0B060A),
        card: Color(0xFF2B1A28),
        elevated: Color(0xFF3C2537),
        text: Color(0xFFFFF6FB),
        mutedText: Color(0xFFD5AFC5),
        searchFieldBackground: Color(0xFFFFECF5),
        searchFieldText: Color(0xFF0B060A),
        playerButtonBackground: Color(0xFFFFF6FB),
        playerButtonForeground: Color(0xFF0B060A),
        progressTrack: Color(0x33FF6B9A),
        headerGradient: [Color(0xFF6D214C), Color(0xFF1A1018)],
        nowPlayingGradient: [Color(0xFF81345F), Color(0xFF1A1018)],
        likedSongsGradient: [Color(0xFFD63C77), Color(0xFFFFA9C7)],
      ),
    ),
    AppThemeConfig(
      id: 'monga',
      name: 'Monga Theme',
      colors: AppThemeColors(
        primary: Color(0xFFA3E635),
        background: Color(0xFF10170D),
        navBackground: Color(0xFF070B05),
        card: Color(0xFF1E2A18),
        elevated: Color(0xFF2B3B22),
        text: Color(0xFFF8FFF1),
        mutedText: Color(0xFFB7CAA8),
        searchFieldBackground: Color(0xFFF0FFE0),
        searchFieldText: Color(0xFF070B05),
        playerButtonBackground: Color(0xFFF8FFF1),
        playerButtonForeground: Color(0xFF070B05),
        progressTrack: Color(0x33A3E635),
        headerGradient: [Color(0xFF365B1A), Color(0xFF10170D)],
        nowPlayingGradient: [Color(0xFF4B6F2C), Color(0xFF10170D)],
        likedSongsGradient: [Color(0xFF5F8F1F), Color(0xFFC8F66B)],
      ),
    ),
  ];

  static ThemeData get dark => themeById(defaultThemeId).themeData;

  static AppThemeConfig themeById(String id) {
    return themes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => themes.first,
    );
  }

  static bool hasTheme(String id) => themes.any((theme) => theme.id == id);

  static ThemeData build(AppThemeColors colors) {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.montserratTextTheme(
      base.textTheme,
    ).apply(bodyColor: colors.text, displayColor: colors.text);

    return base.copyWith(
      scaffoldBackgroundColor:
          colors.hasWallpaper ? Colors.transparent : colors.background,
      canvasColor: colors.hasWallpaper ? Colors.transparent : colors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: colors.primary,
        secondary: colors.primary,
        surface: colors.background,
        onSurface: colors.text,
      ),
      extensions: [colors],
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.text,
        elevation: 0,
        centerTitle: false,
      ),
      iconTheme: IconThemeData(color: colors.text),
      listTileTheme: ListTileThemeData(
        iconColor: colors.text,
        textColor: colors.text,
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 4,
        activeTrackColor: colors.text,
        inactiveTrackColor: colors.progressTrack,
        thumbColor: colors.text,
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.navBackground,
        selectedItemColor: colors.text,
        unselectedItemColor: colors.mutedText,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}

extension AppThemeContext on BuildContext {
  AppThemeColors get appColors {
    return Theme.of(this).extension<AppThemeColors>()!;
  }
}
