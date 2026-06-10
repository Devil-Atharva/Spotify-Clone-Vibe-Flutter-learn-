import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/song_tile.dart';
import '../widgets/themed_surfaces.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final liked = library.liked;
    final recent = library.recent;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Your Library',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _likedSongsHeader(context, liked)),
          if (liked.isEmpty && recent.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyLibrary(),
            )
          else ...[
            if (liked.isNotEmpty)
              const SliverToBoxAdapter(child: _SectionLabel('Liked Songs')),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => SongTile(song: liked[i], queue: liked),
                childCount: liked.length,
              ),
            ),
            if (recent.isNotEmpty)
              const SliverToBoxAdapter(child: _SectionLabel('Recently Played')),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => SongTile(song: recent[i], queue: recent),
                childCount: recent.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
      ),
    );
  }

  /// A featured "Liked Songs" playlist card (Spotify-style purple gradient).
  Widget _likedSongsHeader(BuildContext context, List<Song> liked) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: AppGlassContainer(
        radius: 24,
        color: Color.alphaBlend(
          colors.likedSongsGradient.first.withAlpha(96),
          colors.glassSurface,
        ),
        child: InkWell(
          onTap: liked.isEmpty
              ? null
              : () {
                  context.read<PlayerProvider>().playSong(
                    liked.first,
                    queue: liked,
                  );
                  context.read<LibraryProvider>().addRecent(liked.first);
                },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors.likedSongsGradient,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.favorite, color: colors.text, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Liked Songs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.text,
                      ),
                    ),
                    Text(
                      '${liked.length} song${liked.length == 1 ? '' : 's'}',
                      style: TextStyle(fontSize: 12, color: colors.mutedText),
                    ),
                  ],
                ),
                const Spacer(),
                if (liked.isNotEmpty)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.playerButtonBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: colors.playerButtonForeground,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: AppGlassContainer(
          radius: 28,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.library_music_outlined,
                size: 56,
                color: colors.mutedText,
              ),
              const SizedBox(height: 16),
              Text(
                'Songs you like will appear here',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.mutedText),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the heart on any song to save it.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.mutedText, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
