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
  final List<Color>? progressGradient;
  final String? wallpaperAsset;
  final Color wallpaperOverlay;
  final double wallpaperBlurSigma;
  final double glassBlurSigma;
  final Color? glassColor;
  final Color? glassBorder;
  final Brightness systemOverlayIconBrightness;
  final Brightness statusBarBrightness;
  final Brightness navigationBarIconBrightness;

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
    this.progressGradient,
    this.wallpaperAsset,
    this.wallpaperOverlay = Colors.transparent,
    this.wallpaperBlurSigma = 0,
    this.glassBlurSigma = 0,
    this.glassColor,
    this.glassBorder,
    this.systemOverlayIconBrightness = Brightness.light,
    this.statusBarBrightness = Brightness.dark,
    this.navigationBarIconBrightness = Brightness.light,
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
    List<Color>? progressGradient,
    String? wallpaperAsset,
    Color? wallpaperOverlay,
    double? wallpaperBlurSigma,
    double? glassBlurSigma,
    Color? glassColor,
    Color? glassBorder,
    Brightness? systemOverlayIconBrightness,
    Brightness? statusBarBrightness,
    Brightness? navigationBarIconBrightness,
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
      progressGradient: progressGradient ?? this.progressGradient,
      wallpaperAsset: wallpaperAsset ?? this.wallpaperAsset,
      wallpaperOverlay: wallpaperOverlay ?? this.wallpaperOverlay,
      wallpaperBlurSigma: wallpaperBlurSigma ?? this.wallpaperBlurSigma,
      glassBlurSigma: glassBlurSigma ?? this.glassBlurSigma,
      glassColor: glassColor ?? this.glassColor,
      glassBorder: glassBorder ?? this.glassBorder,
      systemOverlayIconBrightness:
          systemOverlayIconBrightness ?? this.systemOverlayIconBrightness,
      statusBarBrightness: statusBarBrightness ?? this.statusBarBrightness,
      navigationBarIconBrightness:
          navigationBarIconBrightness ?? this.navigationBarIconBrightness,
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
      progressGradient: _lerpColorListOrNull(
        progressGradient,
        other.progressGradient,
        t,
      ),
      wallpaperAsset: t < 0.5 ? wallpaperAsset : other.wallpaperAsset,
      wallpaperOverlay: Color.lerp(
        wallpaperOverlay,
        other.wallpaperOverlay,
        t,
      )!,
      wallpaperBlurSigma:
          wallpaperBlurSigma +
          ((other.wallpaperBlurSigma - wallpaperBlurSigma) * t),
      glassBlurSigma:
          glassBlurSigma + ((other.glassBlurSigma - glassBlurSigma) * t),
      glassColor: Color.lerp(glassSurface, other.glassSurface, t),
      glassBorder: Color.lerp(glassOutline, other.glassOutline, t),
      systemOverlayIconBrightness: t < 0.5
          ? systemOverlayIconBrightness
          : other.systemOverlayIconBrightness,
      statusBarBrightness: t < 0.5
          ? statusBarBrightness
          : other.statusBarBrightness,
      navigationBarIconBrightness: t < 0.5
          ? navigationBarIconBrightness
          : other.navigationBarIconBrightness,
    );
  }

  static List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    final length = a.length < b.length ? a.length : b.length;
    return List<Color>.generate(
      length,
      (index) => Color.lerp(a[index], b[index], t)!,
    );
  }

  static List<Color>? _lerpColorListOrNull(
    List<Color>? a,
    List<Color>? b,
    double t,
  ) {
    if (a == null || b == null) return t < 0.5 ? a : b;
    return _lerpColorList(a, b, t);
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
        progressGradient: [Color(0xFF3D8BFF), Color(0xFF72F1FF)],
        wallpaperAsset: 'assets/images/prayag_wallpaper.png',
        wallpaperOverlay: Color(0x88F6FBFF),
        wallpaperBlurSigma: 2,
        glassBlurSigma: 18,
        glassColor: Color(0xAAFFFFFF),
        glassBorder: Color(0x66FFFFFF),
        systemOverlayIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        navigationBarIconBrightness: Brightness.dark,
      ),
    ),
    AppThemeConfig(
      id: 'sagar',
      name: 'Sagar Theme',
      colors: AppThemeColors(
        primary: Color(0xFF6AE8FF),
        background: Color(0xFF06070A),
        navBackground: Color(0xCC0B0E14),
        card: Color(0x22162231),
        elevated: Color(0x331D2A3A),
        text: Color(0xFFF4FAFF),
        mutedText: Color(0xFF9FB2C7),
        searchFieldBackground: Color(0xE8F3F8FF),
        searchFieldText: Color(0xFF06101B),
        playerButtonBackground: Color(0xFFF2FBFF),
        playerButtonForeground: Color(0xFF06101B),
        progressTrack: Color(0x332E425C),
        headerGradient: [Color(0xFF0D1622), Color(0xFF06070A)],
        nowPlayingGradient: [Color(0xFF122238), Color(0xFF06070A)],
        likedSongsGradient: [Color(0xFF143F63), Color(0xFF57B7FF)],
        wallpaperAsset: 'assets/images/sagar_wallpaper.png',
        wallpaperOverlay: Color(0xB3070A10),
        wallpaperBlurSigma: 2,
        glassBlurSigma: 22,
        glassColor: Color(0x1AFFFFFF),
        glassBorder: Color(0x26DDF5FF),
        systemOverlayIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        navigationBarIconBrightness: Brightness.light,
      ),
    ),
    AppThemeConfig(
      id: 'vaibhav',
      name: 'Vaibhav Theme',
      colors: AppThemeColors(
        primary: Color(0xFFFFC857),
        background: Color(0xFF0B1324),
        navBackground: Color(0xCC0E172C),
        card: Color(0xFF1D2336),
        elevated: Color(0xFF27304A),
        text: Color(0xFFFFFBF3),
        mutedText: Color(0xFFC9D6E8),
        searchFieldBackground: Color(0xFFF7EED8),
        searchFieldText: Color(0xFF0B1324),
        playerButtonBackground: Color(0xFFFFFBF3),
        playerButtonForeground: Color(0xFF0B1324),
        progressTrack: Color(0x334C74B8),
        headerGradient: [Color(0xFF16253D), Color(0xFF0B1324)],
        nowPlayingGradient: [Color(0xFF20365A), Color(0xFF0B1324)],
        likedSongsGradient: [Color(0xFFB67B1A), Color(0xFFFFD879)],
        progressGradient: [
          Color(0xFFFF4D4D),
          Color(0xFFFF9F43),
          Color(0xFFFFF176),
          Color(0xFF4DFF88),
          Color(0xFF4DC4FF),
          Color(0xFF8C6BFF),
        ],
        wallpaperAsset: 'assets/images/vaibhav_wallpaper.png',
        wallpaperOverlay: Color(0x80253A57),
        wallpaperBlurSigma: 2,
        glassBlurSigma: 20,
        glassColor: Color(0x18FFFFFF),
        glassBorder: Color(0x28FFE7AA),
        systemOverlayIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        navigationBarIconBrightness: Brightness.light,
      ),
    ),
    AppThemeConfig(
      id: 'shivli',
      name: 'Shivli Theme',
      colors: AppThemeColors(
        primary: Color(0xFF7FE36B),
        background: Color(0xFF07110A),
        navBackground: Color(0xCC09160D),
        card: Color(0xFF15241A),
        elevated: Color(0xFF223525),
        text: Color(0xFFF4FFF0),
        mutedText: Color(0xFFB4D2B0),
        searchFieldBackground: Color(0xFFE8F7E2),
        searchFieldText: Color(0xFF07110A),
        playerButtonBackground: Color(0xFFF4FFF0),
        playerButtonForeground: Color(0xFF07110A),
        progressTrack: Color(0x334CCB6A),
        headerGradient: [Color(0xFF203A26), Color(0xFF07110A)],
        nowPlayingGradient: [Color(0xFF2D5232), Color(0xFF07110A)],
        likedSongsGradient: [Color(0xFF3E8D3D), Color(0xFFA8F06B)],
        wallpaperAsset: 'assets/images/shivli_wallpaper.png',
        wallpaperOverlay: Color(0xAA08130B),
        wallpaperBlurSigma: 3,
        glassBlurSigma: 18,
        glassColor: Color(0x1A0D1F11),
        glassBorder: Color(0x2C8DEB8A),
        systemOverlayIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        navigationBarIconBrightness: Brightness.light,
      ),
    ),
    AppThemeConfig(
      id: 'monga',
      name: 'Monga Theme',
      colors: AppThemeColors(
        primary: Color(0xFFFF3FD8),
        background: Color(0xFF08050D),
        navBackground: Color(0xCC12051A),
        card: Color(0xFF201226),
        elevated: Color(0xFF33183D),
        text: Color(0xFFFFF8FF),
        mutedText: Color(0xFFF1B6E8),
        searchFieldBackground: Color(0xFFFFE9FD),
        searchFieldText: Color(0xFF12051A),
        playerButtonBackground: Color(0xFFFFF8FF),
        playerButtonForeground: Color(0xFF12051A),
        progressTrack: Color(0x33FF3FD8),
        headerGradient: [Color(0xFF2A0833), Color(0xFF08050D)],
        nowPlayingGradient: [Color(0xFF3A0F47), Color(0xFF08050D)],
        likedSongsGradient: [Color(0xFFFF3FD8), Color(0xFF6BFFEA)],
        wallpaperAsset: 'assets/images/monga_wallpaper.png',
        wallpaperOverlay: Color(0x8A1A0823),
        wallpaperBlurSigma: 2,
        glassBlurSigma: 18,
        glassColor: Color(0x1AEAE1FF),
        glassBorder: Color(0x33FF8AF3),
        systemOverlayIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        navigationBarIconBrightness: Brightness.light,
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
      scaffoldBackgroundColor: colors.hasWallpaper
          ? Colors.transparent
          : colors.background,
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
        surfaceTintColor: Colors.transparent,
      ),
      iconTheme: IconThemeData(color: colors.text),
      cardTheme: CardThemeData(
        color: colors.glassSurface,
        surfaceTintColor: Colors.transparent,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.text,
        textColor: colors.text,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.searchFieldBackground,
        hintStyle: TextStyle(color: colors.mutedText),
        prefixIconColor: colors.searchFieldText,
        suffixIconColor: colors.searchFieldText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.glassOutline),
        ),
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
