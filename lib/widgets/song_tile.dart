import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import 'artwork.dart';

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
    final isCurrent = player.currentSong?.id == song.id;
    final liked = library.isLiked(song);

    return InkWell(
      onTap: () {
        context.read<PlayerProvider>().playSong(song, queue: queue);
        context.read<LibraryProvider>().addRecent(song);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Artwork(url: song.artworkUrl, size: 52),
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
                      fontWeight: FontWeight.w500,
                      color: isCurrent ? AppColors.spotifyGreen : AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (!song.isPlayable)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.block, size: 18, color: AppColors.lightGrey),
              ),
            if (showLike)
              IconButton(
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? AppColors.spotifyGreen : AppColors.lightGrey,
                  size: 20,
                ),
                onPressed: () => context.read<LibraryProvider>().toggleLike(song),
              ),
          ],
        ),
      ),
    );
  }
}
