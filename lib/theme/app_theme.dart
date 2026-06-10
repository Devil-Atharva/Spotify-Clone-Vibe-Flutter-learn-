import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ThemePersonality { defaultSpotify, prayag, sagar, vaibhav, shivli, monga }

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
  final ThemePersonality personality;
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
    this.personality = ThemePersonality.defaultSpotify,
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
    ThemePersonality? personality,
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
      personality: personality ?? this.personality,
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
      personality: t < 0.5 ? personality : other.personality,
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
    personality: ThemePersonality.defaultSpotify,
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
        personality: ThemePersonality.prayag,
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
        wallpaperAsset: 'assets/wallpapers/prayag.jpg',
        wallpaperOverlay: Color(0x66EDF8FF),
        wallpaperBlurSigma: 3,
        glassBlurSigma: 18,
        glassColor: Color(0xAAFFFFFF),
        glassBorder: Color(0x88FFFFFF),
        systemOverlayIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        navigationBarIconBrightness: Brightness.dark,
      ),
    ),
    AppThemeConfig(
      id: 'sagar',
      name: 'Sagar Theme',
      colors: AppThemeColors(
        personality: ThemePersonality.sagar,
        primary: Color(0xFFC6CCD7),
        background: Color(0xFF06070A),
        navBackground: Color(0xF20B0C10),
        card: Color(0xE6141519),
        elevated: Color(0xF01A1C21),
        text: Color(0xFFF5F5F3),
        mutedText: Color(0xFF9A9EA8),
        searchFieldBackground: Color(0xFFF1F2F4),
        searchFieldText: Color(0xFF06101B),
        playerButtonBackground: Color(0xFFC6CCD7),
        playerButtonForeground: Color(0xFF06101B),
        progressTrack: Color(0x33585F6B),
        headerGradient: [Color(0xD8090A0E), Color(0xFF06070A)],
        nowPlayingGradient: [Color(0xE013151A), Color(0xFF06070A)],
        likedSongsGradient: [Color(0xFF6D7480), Color(0xFFC8CDD4)],
        wallpaperAsset: 'assets/wallpapers/sagar.jpg',
        wallpaperOverlay: Color(0xCC040507),
        wallpaperBlurSigma: 0,
        glassBlurSigma: 4,
        glassColor: Color(0xE6101115),
        glassBorder: Color(0x44E1E6ED),
        systemOverlayIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        navigationBarIconBrightness: Brightness.light,
      ),
    ),
    AppThemeConfig(
      id: 'vaibhav',
      name: 'Vaibhav Theme',
      colors: AppThemeColors(
        personality: ThemePersonality.vaibhav,
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
        wallpaperAsset: 'assets/wallpapers/vaibhav.jpg',
        wallpaperOverlay: Color(0x7F091425),
        wallpaperBlurSigma: 1,
        glassBlurSigma: 8,
        glassColor: Color(0xCC0E1722),
        glassBorder: Color(0x66A5D7FF),
        systemOverlayIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        navigationBarIconBrightness: Brightness.light,
      ),
    ),
    AppThemeConfig(
      id: 'shivli',
      name: 'Shivli Theme',
      colors: AppThemeColors(
        personality: ThemePersonality.shivli,
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
        wallpaperAsset: 'assets/wallpapers/shivli.jpg',
        wallpaperOverlay: Color(0xA60B160E),
        wallpaperBlurSigma: 2,
        glassBlurSigma: 10,
        glassColor: Color(0xC6142518),
        glassBorder: Color(0x337FE36B),
        systemOverlayIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        navigationBarIconBrightness: Brightness.light,
      ),
    ),
    AppThemeConfig(
      id: 'monga',
      name: 'Monga Theme',
      colors: AppThemeColors(
        personality: ThemePersonality.monga,
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
        progressGradient: [Color(0xFFFF3FD8), Color(0xFFFF8A00), Color(0xFF6BFFEA)],
        wallpaperAsset: 'assets/wallpapers/monga.jpg',
        wallpaperOverlay: Color(0x7A120315),
        wallpaperBlurSigma: 1,
        glassBlurSigma: 12,
        glassColor: Color(0xCC250E2E),
        glassBorder: Color(0x55FF8AF3),
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
    final textTheme = _textThemeFor(colors, base.textTheme).apply(
      bodyColor: colors.text,
      displayColor: colors.text,
    );
    final inputRadius = switch (colors.personality) {
      ThemePersonality.prayag => 20.0,
      ThemePersonality.sagar => 10.0,
      ThemePersonality.vaibhav => 12.0,
      ThemePersonality.shivli => 22.0,
      ThemePersonality.monga => 18.0,
      ThemePersonality.defaultSpotify => 14.0,
    };
    final sliderTrackHeight = switch (colors.personality) {
      ThemePersonality.vaibhav => 6.0,
      ThemePersonality.monga => 5.0,
      ThemePersonality.sagar => 3.0,
      _ => 4.0,
    };

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
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide(color: colors.glassOutline),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: sliderTrackHeight,
        activeTrackColor: colors.text,
        inactiveTrackColor: colors.progressTrack,
        thumbColor: colors.text,
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        trackShape: ThemeGradientSliderTrackShape(colors: colors),
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

  static TextTheme _textThemeFor(AppThemeColors colors, TextTheme base) {
    return switch (colors.personality) {
      ThemePersonality.prayag => GoogleFonts.plusJakartaSansTextTheme(base),
      ThemePersonality.sagar => GoogleFonts.dmSansTextTheme(base),
      ThemePersonality.vaibhav => GoogleFonts.spaceGroteskTextTheme(base),
      ThemePersonality.shivli => GoogleFonts.nunitoTextTheme(base),
      ThemePersonality.monga => GoogleFonts.lexendTextTheme(base),
      ThemePersonality.defaultSpotify => GoogleFonts.montserratTextTheme(base),
    };
  }
}

class ThemeGradientSliderTrackShape extends RoundedRectSliderTrackShape {
  final AppThemeColors colors;

  const ThemeGradientSliderTrackShape({required this.colors});

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    double additionalActiveTrackHeight = 2,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final radius = Radius.circular(trackRect.height / 2);
    final activeRect = Rect.fromLTRB(
      textDirection == TextDirection.ltr ? trackRect.left : thumbCenter.dx,
      trackRect.top,
      textDirection == TextDirection.ltr ? thumbCenter.dx : trackRect.right,
      trackRect.bottom,
    );

    final inactivePaint = Paint()..color = colors.progressTrack;
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, radius),
      inactivePaint,
    );

    if (activeRect.width <= 0) return;

    final activePaint = Paint();
    final gradient = colors.progressGradient;
    if (gradient != null && gradient.length > 1) {
      activePaint.shader = LinearGradient(colors: gradient).createShader(
        activeRect,
      );
    } else {
      activePaint.color = sliderTheme.activeTrackColor ?? colors.text;
    }

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeRect, radius),
      activePaint,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppThemeColors get appColors {
    return Theme.of(this).extension<AppThemeColors>()!;
  }
}
