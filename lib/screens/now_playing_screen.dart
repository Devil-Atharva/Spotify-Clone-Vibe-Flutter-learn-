import 'package:flutter/material.dart' hide RepeatMode;
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/artwork.dart';
import '../widgets/themed_surfaces.dart';

/// Full-screen "Now Playing" view with full transport controls.
class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;
    final colors = context.appColors;

    if (song == null) {
      return const Scaffold(body: Center(child: Text('Nothing playing')));
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors.nowPlayingGradient,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _topBar(context, song),
                const Spacer(),
                // Album art.
                Hero(
                  tag: 'now-playing-art',
                  child: Artwork(
                    url: song.artworkHighRes(),
                    size: MediaQuery.of(context).size.width - 48,
                    radius: 10,
                  ),
                ),
                const Spacer(),
                _titleRow(context, song),
                const SizedBox(height: 16),
                _seekBar(context, player),
                _controls(context, player),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, Song song) {
    final colors = context.appColors;

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              'PLAYING FROM PREVIEW',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.2,
                color: colors.mutedText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              song.album.isNotEmpty ? song.album : song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const Spacer(),
        const IconButton(icon: Icon(Icons.more_vert), onPressed: null),
      ],
    );
  }

  Widget _titleRow(BuildContext context, Song song) {
    final library = context.watch<LibraryProvider>();
    final colors = context.appColors;
    final liked = library.isLiked(song);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                song.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                song.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, color: colors.mutedText),
              ),
            ],
          ),
        ),
        IconButton(
          iconSize: 30,
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: liked ? colors.primary : colors.text,
          ),
          onPressed: () => context.read<LibraryProvider>().toggleLike(song),
        ),
      ],
    );
  }

  Widget _seekBar(BuildContext context, PlayerProvider player) {
    final colors = context.appColors;
    final total = player.duration;
    final pos = player.position > total ? total : player.position;
    return Column(
      children: [
        Slider(
          value: pos.inMilliseconds.toDouble().clamp(
            0,
            total.inMilliseconds.toDouble(),
          ),
          max: total.inMilliseconds.toDouble().clamp(1, double.infinity),
          onChanged: (v) => context.read<PlayerProvider>().seek(
            Duration(milliseconds: v.toInt()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _fmt(pos),
                style: TextStyle(fontSize: 11, color: colors.mutedText),
              ),
              Text(
                _fmt(total),
                style: TextStyle(fontSize: 11, color: colors.mutedText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _controls(BuildContext context, PlayerProvider player) {
    final read = context.read<PlayerProvider>();
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AppGlassContainer(
        radius: 28,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              iconSize: 26,
              icon: Icon(
                Icons.shuffle,
                color: player.shuffle ? colors.primary : colors.mutedText,
              ),
              onPressed: read.toggleShuffle,
            ),
            IconButton(
              iconSize: 40,
              icon: const Icon(Icons.skip_previous),
              onPressed: read.previous,
            ),
            // Play / pause big button.
            GestureDetector(
              onTap: read.togglePlayPause,
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: colors.playerButtonBackground,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withAlpha(70),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: player.isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(22),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: colors.playerButtonForeground,
                        ),
                      )
                    : Icon(
                        player.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: colors.playerButtonForeground,
                        size: 40,
                      ),
              ),
            ),
            IconButton(
              iconSize: 40,
              icon: const Icon(Icons.skip_next),
              onPressed: () => read.next(),
            ),
            IconButton(
              iconSize: 26,
              icon: Icon(
                player.repeat == RepeatMode.one
                    ? Icons.repeat_one
                    : Icons.repeat,
                color: player.repeat == RepeatMode.off
                    ? colors.mutedText
                    : colors.primary,
              ),
              onPressed: read.cycleRepeat,
            ),
          ],
        ),
      ),
    );
  }
}
