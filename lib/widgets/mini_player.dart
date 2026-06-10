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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Artwork(url: song.artworkUrl, size: 44, radius: 4),
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
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  height: 2,
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
