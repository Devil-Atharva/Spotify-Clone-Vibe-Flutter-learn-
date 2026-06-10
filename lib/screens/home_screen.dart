import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../services/music_api.dart';
import '../theme/app_theme.dart';
import '../widgets/artwork.dart';
import '../widgets/themed_surfaces.dart';
import 'settings_screen.dart';

/// A curated home feed assembled from several iTunes search "themes".
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final MusicApi _api = MusicApi();
  late final AnimationController _atmosphere;

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
    _atmosphere = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat(reverse: true);
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
    _atmosphere.dispose();
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
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors.headerGradient,
          stops: [0.0, 0.35],
        ),
      ),
      child: Stack(
        children: [
          _ThemeAtmosphere(animation: _atmosphere),
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: colors.primary,
              backgroundColor: colors.card,
              onRefresh: _refresh,
              child: FutureBuilder<List<(String, List<Song>)>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    );
                  }
                  if (snapshot.hasError) {
                    return _errorView(context);
                  }
                  final sections = snapshot.data ?? [];
                  if (sections.isEmpty) {
                    return _errorView(context);
                  }
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      _header(context),
                      _recentlyPlayed(),
                      ...sections.map(
                        (s) => _CarouselSection(title: s.$1, songs: s.$2),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BoxShadow> _headerShadows(AppThemeColors colors) {
    return switch (colors.personality) {
      ThemePersonality.prayag => [
        BoxShadow(
          color: colors.primary.withAlpha(32),
          blurRadius: 26,
          offset: const Offset(0, 12),
        ),
      ],
      ThemePersonality.sagar => const [
        BoxShadow(
          color: Color(0x66000000),
          blurRadius: 18,
          offset: Offset(0, 10),
        ),
      ],
      ThemePersonality.vaibhav => [
        BoxShadow(
          color: const Color(0xFF4DC4FF).withAlpha(30),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      ThemePersonality.shivli => [
        BoxShadow(
          color: const Color(0xFF7FE36B).withAlpha(24),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
      ThemePersonality.monga => [
        BoxShadow(
          color: const Color(0xFFFF3FD8).withAlpha(40),
          blurRadius: 28,
          offset: const Offset(0, 10),
        ),
      ],
      ThemePersonality.defaultSpotify => const [],
    };
  }

  Widget _errorView(BuildContext context) {
    final colors = context.appColors;

    return ListView(
      children: [
        const SizedBox(height: 160),
        Icon(Icons.wifi_off, size: 48, color: colors.mutedText),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Could not load music.\nCheck your connection and pull to retry.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.mutedText),
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

  Widget _header(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: AppGlassContainer(
        radius: switch (colors.personality) {
          ThemePersonality.sagar => 12,
          ThemePersonality.vaibhav => 14,
          ThemePersonality.shivli => 26,
          ThemePersonality.monga => 18,
          _ => 24,
        },
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shadows: _headerShadows(colors),
        child: Row(
          children: [
            Text(
              _greeting(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Icon(Icons.notifications_none, color: colors.text),
            const SizedBox(width: 16),
            Icon(Icons.history, color: colors.text),
            const SizedBox(width: 12),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.settings_outlined, color: colors.text),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
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
    final colors = context.appColors;

    return AppGlassContainer(
      radius: switch (colors.personality) {
        ThemePersonality.prayag => 16,
        ThemePersonality.sagar => 8,
        ThemePersonality.vaibhav => 10,
        ThemePersonality.shivli => 20,
        ThemePersonality.monga => 14,
        ThemePersonality.defaultSpotify => 4,
      },
      color: colors.elevated,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            switch (colors.personality) {
              ThemePersonality.prayag => 16,
              ThemePersonality.sagar => 8,
              ThemePersonality.vaibhav => 10,
              ThemePersonality.shivli => 20,
              ThemePersonality.monga => 14,
              ThemePersonality.defaultSpotify => 4,
            },
          ),
          onTap: () {
            context.read<PlayerProvider>().playSong(song, queue: queue);
            context.read<LibraryProvider>().addRecent(song);
          },
          child: Row(
            children: [
              Artwork(
                url: song.artworkUrl,
                size: 48,
                radius: switch (colors.personality) {
                  ThemePersonality.prayag => 12,
                  ThemePersonality.sagar => 4,
                  ThemePersonality.vaibhav => 6,
                  ThemePersonality.shivli => 14,
                  ThemePersonality.monga => 10,
                  ThemePersonality.defaultSpotify => 4,
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  song.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
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
    final colors = context.appColors;

    return GestureDetector(
      onTap: () {
        context.read<PlayerProvider>().playSong(song, queue: queue);
        context.read<LibraryProvider>().addRecent(song);
      },
      child: SizedBox(
        width: 150,
        child: AppGlassContainer(
          radius: switch (colors.personality) {
            ThemePersonality.prayag => 26,
            ThemePersonality.sagar => 10,
            ThemePersonality.vaibhav => 12,
            ThemePersonality.shivli => 28,
            ThemePersonality.monga => 18,
            ThemePersonality.defaultSpotify => 20,
          },
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(8),
          gradient: switch (colors.personality) {
            ThemePersonality.vaibhav => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.card, colors.elevated],
            ),
            ThemePersonality.monga => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.card, colors.primary.withAlpha(70)],
            ),
            _ => null,
          },
          shadows: switch (colors.personality) {
            ThemePersonality.prayag => [
              BoxShadow(
                color: colors.primary.withAlpha(26),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            ThemePersonality.sagar => const [
              BoxShadow(
                color: Color(0x88000000),
                blurRadius: 16,
                offset: Offset(0, 10),
              ),
            ],
            ThemePersonality.vaibhav => [
              BoxShadow(
                color: const Color(0xFF4DC4FF).withAlpha(20),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
            ThemePersonality.shivli => [
              BoxShadow(
                color: const Color(0xFF7FE36B).withAlpha(18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            ThemePersonality.monga => [
              BoxShadow(
                color: colors.primary.withAlpha(34),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
            ThemePersonality.defaultSpotify => null,
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Artwork(
                url: song.artworkHighRes(300),
                size: 140,
                radius: switch (colors.personality) {
                  ThemePersonality.prayag => 18,
                  ThemePersonality.sagar => 6,
                  ThemePersonality.vaibhav => 8,
                  ThemePersonality.shivli => 22,
                  ThemePersonality.monga => 12,
                  ThemePersonality.defaultSpotify => 8,
                },
              ),
              const SizedBox(height: 6),
              Text(
                song.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

class _ThemeAtmosphere extends StatelessWidget {
  final Animation<double> animation;

  const _ThemeAtmosphere({required this.animation});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (colors.personality != ThemePersonality.shivli) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final t = animation.value;
          return Stack(
            children: [
              Positioned(
                left: -80 + (40 * t),
                top: 120,
                child: const _FogBlob(
                  size: 220,
                  color: Color(0x338FDFA7),
                ),
              ),
              Positioned(
                right: -60 + (30 * (1 - t)),
                top: 320,
                child: const _FogBlob(
                  size: 180,
                  color: Color(0x22F4FFF0),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FogBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _FogBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
