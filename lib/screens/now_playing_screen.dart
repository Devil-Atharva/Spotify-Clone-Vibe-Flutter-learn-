import 'package:flutter/material.dart' hide RepeatMode;
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/artwork.dart';

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

    if (song == null) {
      return const Scaffold(body: Center(child: Text('Nothing playing')));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3A3A3A), AppColors.black],
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
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        const Spacer(),
        Column(
          children: [
            const Text(
              'PLAYING FROM PREVIEW',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.2,
                color: AppColors.lightGrey,
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
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.lightGrey,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          iconSize: 30,
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: liked ? AppColors.spotifyGreen : AppColors.white,
          ),
          onPressed: () => context.read<LibraryProvider>().toggleLike(song),
        ),
      ],
    );
  }

  Widget _seekBar(BuildContext context, PlayerProvider player) {
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
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.lightGrey,
                ),
              ),
              Text(
                _fmt(total),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.lightGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _controls(BuildContext context, PlayerProvider player) {
    final read = context.read<PlayerProvider>();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 26,
            icon: Icon(
              Icons.shuffle,
              color: player.shuffle
                  ? AppColors.spotifyGreen
                  : AppColors.lightGrey,
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
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: player.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(22),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.black,
                      ),
                    )
                  : Icon(
                      player.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: AppColors.black,
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
              player.repeat == RepeatMode.one ? Icons.repeat_one : Icons.repeat,
              color: player.repeat == RepeatMode.off
                  ? AppColors.lightGrey
                  : AppColors.spotifyGreen,
            ),
            onPressed: read.cycleRepeat,
          ),
        ],
      ),
    );
  }
}
