import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

class ThemedBackground extends StatelessWidget {
  final Widget child;

  const ThemedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: colors.systemOverlayIconBrightness,
        statusBarBrightness: colors.statusBarBrightness,
        systemNavigationBarColor: colors.navBackground,
        systemNavigationBarIconBrightness: colors.navigationBarIconBrightness,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
      child: ColoredBox(
        color: colors.background,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (colors.wallpaperAsset != null)
              RepaintBoundary(
                child: Image.asset(colors.wallpaperAsset!, fit: BoxFit.cover),
              ),
            if (colors.wallpaperAsset != null)
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: colors.wallpaperBlurSigma,
                  sigmaY: colors.wallpaperBlurSigma,
                ),
                child: ColoredBox(color: colors.wallpaperOverlay),
              ),
            child,
          ],
        ),
      ),
    );
  }
}

class AppGlassContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Border? border;

  const AppGlassContainer({
    super.key,
    required this.child,
    this.radius = 8,
    this.padding,
    this.margin,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final borderRadius = BorderRadius.circular(radius);

    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? colors.glassSurface,
        borderRadius: borderRadius,
        border: border ?? Border.all(color: colors.glassOutline),
      ),
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );

    final clippedSurface = ClipRRect(
      borderRadius: borderRadius,
      child: colors.glassBlurSigma > 0
          ? BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: colors.glassBlurSigma,
                sigmaY: colors.glassBlurSigma,
              ),
              child: surface,
            )
          : surface,
    );

    if (margin == null) return clippedSurface;

    return Padding(padding: margin!, child: clippedSurface);
  }
}
