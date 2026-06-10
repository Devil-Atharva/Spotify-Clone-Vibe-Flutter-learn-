import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import 'artwork.dart';
import 'themed_surfaces.dart';

/// A horizontal row representing a single song in a list.
class SongTile extends StatelessWidget {
  final Song song;

  /// The list this song belongs to; becomes the play queue when tapped.
  final List<Song> queue;
  final bool showLike;

  const SongTile({
    super.key,
    required this.song,
    required this.queue,
    this.showLike = true,
  });

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final library = context.watch<LibraryProvider>();
    final colors = context.appColors;
    final isCurrent = player.currentSong?.id == song.id;
    final liked = library.isLiked(song);

    final radius = switch (colors.personality) {
      ThemePersonality.prayag => 20.0,
      ThemePersonality.sagar => 8.0,
      ThemePersonality.vaibhav => 10.0,
      ThemePersonality.shivli => 22.0,
      ThemePersonality.monga => 16.0,
      ThemePersonality.defaultSpotify => 8.0,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: AppGlassContainer(
        radius: radius,
        color: isCurrent ? colors.elevated : null,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: () {
            context.read<PlayerProvider>().playSong(song, queue: queue);
            context.read<LibraryProvider>().addRecent(song);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Artwork(
                  url: song.artworkUrl,
                  size: 52,
                  radius: switch (colors.personality) {
                    ThemePersonality.prayag => 16,
                    ThemePersonality.sagar => 4,
                    ThemePersonality.vaibhav => 6,
                    ThemePersonality.shivli => 18,
                    ThemePersonality.monga => 10,
                    ThemePersonality.defaultSpotify => 8,
                  },
                ),
                const SizedBox(width: 12),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isCurrent ? colors.primary : colors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        song.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!song.isPlayable)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.block,
                      size: 18,
                      color: colors.mutedText,
                    ),
                  ),
                if (showLike)
                  IconButton(
                    icon: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      color: liked ? colors.primary : colors.mutedText,
                      size: 20,
                    ),
                    onPressed: () =>
                        context.read<LibraryProvider>().toggleLike(song),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
