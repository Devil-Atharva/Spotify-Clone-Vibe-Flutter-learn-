import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../screens/now_playing_screen.dart';
import '../theme/app_theme.dart';
import 'artwork.dart';
import 'themed_surfaces.dart';

/// Compact player docked above the bottom nav bar.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;
    if (song == null) return const SizedBox.shrink();

    final library = context.watch<LibraryProvider>();
    final colors = context.appColors;
    final liked = library.isLiked(song);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, _, _) => const NowPlayingScreen(),
          transitionsBuilder: (_, anim, _, child) => SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        ),
      ),
      child: AppGlassContainer(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        radius: switch (colors.personality) {
          ThemePersonality.prayag => 22,
          ThemePersonality.sagar => 10,
          ThemePersonality.vaibhav => 12,
          ThemePersonality.shivli => 24,
          ThemePersonality.monga => 18,
          ThemePersonality.defaultSpotify => 8,
        },
        gradient: switch (colors.personality) {
          ThemePersonality.monga => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.card, colors.primary.withAlpha(76)],
          ),
          ThemePersonality.vaibhav => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [colors.card, colors.elevated],
          ),
          _ => null,
        },
        shadows: switch (colors.personality) {
          ThemePersonality.prayag => [
            BoxShadow(
              color: colors.primary.withAlpha(24),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
          ThemePersonality.sagar => const [
            BoxShadow(
              color: Color(0x88000000),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
          ThemePersonality.monga => [
            BoxShadow(
              color: colors.primary.withAlpha(34),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          _ => null,
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Artwork(
                    url: song.artworkUrl,
                    size: 44,
                    radius: switch (colors.personality) {
                      ThemePersonality.prayag => 14,
                      ThemePersonality.sagar => 4,
                      ThemePersonality.vaibhav => 6,
                      ThemePersonality.shivli => 16,
                      ThemePersonality.monga => 10,
                      ThemePersonality.defaultSpotify => 4,
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.text,
                        ),
                      ),
                      Text(
                        song.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: colors.mutedText),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? colors.primary : colors.text,
                  ),
                  onPressed: () =>
                      context.read<LibraryProvider>().toggleLike(song),
                ),
                IconButton(
                  icon: player.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.text,
                          ),
                        )
                      : Icon(
                          player.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: colors.text,
                          size: 28,
                        ),
                  onPressed: () =>
                      context.read<PlayerProvider>().togglePlayPause(),
                ),
                const SizedBox(width: 4),
              ],
            ),
            // Thin progress bar.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  colors.personality == ThemePersonality.sagar ? 1 : 4,
                ),
                child: SizedBox(
                  height: switch (colors.personality) {
                    ThemePersonality.vaibhav => 4,
                    ThemePersonality.monga => 5,
                    ThemePersonality.sagar => 2,
                    _ => 3,
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(color: colors.progressTrack),
                      if (colors.progressGradient != null)
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: player.progress,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: colors.progressGradient!,
                              ),
                            ),
                          ),
                        )
                      else
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: player.progress,
                          child: ColoredBox(color: colors.text),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
