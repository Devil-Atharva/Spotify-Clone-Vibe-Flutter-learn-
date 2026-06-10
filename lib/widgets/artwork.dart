import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Square album artwork with graceful loading + error fallbacks.
class Artwork extends StatelessWidget {
  final String url;
  final double size;
  final double radius;

  const Artwork({
    super.key,
    required this.url,
    this.size = 56,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.isEmpty
          ? _placeholder(context)
          : CachedNetworkImage(
              imageUrl: url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              placeholder: (_, _) => _placeholder(context),
              errorWidget: (_, _, _) => _placeholder(context),
            ),
    );
  }

  Widget _placeholder(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: size,
      height: size,
      color: colors.card,
      child: Icon(
        Icons.music_note_rounded,
        color: colors.mutedText,
        size: size * 0.4,
      ),
    );
  }
}
