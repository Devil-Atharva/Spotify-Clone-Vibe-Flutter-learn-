import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../services/music_api.dart';
import '../theme/app_theme.dart';
import '../widgets/artwork.dart';

/// A curated home feed assembled from several iTunes search "themes".
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MusicApi _api = MusicApi();

  // Each section is a (title, search-term) pair.
  static const _sections = <(String, String)>[
    ('Top Hits', 'top hits 2024'),
    ('Pop Mix', 'pop'),
    ('Hip-Hop Central', 'hip hop'),
    ('Chill Vibes', 'lofi chill'),
    ('Rock Classics', 'classic rock'),
    ('Electronic', 'electronic dance'),
  ];

  late Future<List<(String, List<Song>)>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadAll();
  }

  Future<List<(String, List<Song>)>> _loadAll() async {
    final results = await Future.wait(
      _sections.map((s) async {
        try {
          final songs = await _api.fetchByTerm(s.$2, limit: 20);
          return (s.$1, songs);
        } catch (_) {
          return (s.$1, <Song>[]);
        }
      }),
    );
    return results.where((r) => r.$2.isNotEmpty).toList();
  }

  Future<void> _refresh() async {
    setState(() => _future = _loadAll());
    await _future;
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.headerGradient,
          stops: [0.0, 0.35],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.spotifyGreen,
          backgroundColor: AppColors.cardGrey,
          onRefresh: _refresh,
          child: FutureBuilder<List<(String, List<Song>)>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.spotifyGreen),
                );
              }
              if (snapshot.hasError) {
                return _errorView();
              }
              final sections = snapshot.data ?? [];
              if (sections.isEmpty) {
                return _errorView();
              }
              return ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  _header(),
                  _recentlyPlayed(),
                  ...sections.map((s) => _CarouselSection(
                        title: s.$1,
                        songs: s.$2,
                      )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _errorView() {
    return ListView(
      children: [
        const SizedBox(height: 160),
        const Icon(Icons.wifi_off, size: 48, color: AppColors.lightGrey),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Could not load music.\nCheck your connection and pull to retry.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.lightGrey),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton(
            onPressed: _refresh,
            child: const Text('Retry'),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            _greeting(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.notifications_none),
          const SizedBox(width: 16),
          const Icon(Icons.history),
          const SizedBox(width: 16),
          const Icon(Icons.settings_outlined),
        ],
      ),
    );
  }

  Widget _recentlyPlayed() {
    final recent = context.watch<LibraryProvider>().recent;
    if (recent.isEmpty) return const SizedBox.shrink();
    final items = recent.take(6).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3.4,
        children: items
            .map((song) => _RecentChip(song: song, queue: recent))
            .toList(),
      ),
    );
  }
}

class _RecentChip extends StatelessWidget {
  final Song song;
  final List<Song> queue;
  const _RecentChip({required this.song, required this.queue});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {
          context.read<PlayerProvider>().playSong(song, queue: queue);
          context.read<LibraryProvider>().addRecent(song);
        },
        child: Row(
          children: [
            Artwork(url: song.artworkUrl, size: 48, radius: 4),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                song.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontally scrolling row of album cards for a section.
class _CarouselSection extends StatelessWidget {
  final String title;
  final List<Song> songs;
  const _CarouselSection({required this.title, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: songs.length,
            itemBuilder: (context, i) {
              final song = songs[i];
              return _AlbumCard(song: song, queue: songs);
            },
          ),
        ),
      ],
    );
  }
}

class _AlbumCard extends StatelessWidget {
  final Song song;
  final List<Song> queue;
  const _AlbumCard({required this.song, required this.queue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PlayerProvider>().playSong(song, queue: queue);
        context.read<LibraryProvider>().addRecent(song);
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Artwork(url: song.artworkHighRes(300), size: 150, radius: 8),
            const SizedBox(height: 8),
            Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.lightGrey),
            ),
          ],
        ),
      ),
    );
  }
}
