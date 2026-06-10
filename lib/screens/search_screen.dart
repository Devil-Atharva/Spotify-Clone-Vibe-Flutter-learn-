import 'dart:async';

import 'package:flutter/material.dart';

import '../models/song.dart';
import '../services/music_api.dart';
import '../theme/app_theme.dart';
import '../widgets/song_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MusicApi _api = MusicApi();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<Song> _results = [];
  bool _loading = false;
  String? _error;
  String _lastQuery = '';

  // Genre browse tiles shown before any search.
  static const _genres = <(String, Color)>[
    ('Pop', Color(0xFF8D67AB)),
    ('Hip-Hop', Color(0xFFBA5D07)),
    ('Rock', Color(0xFFE61E32)),
    ('Electronic', Color(0xFF1E3264)),
    ('R&B', Color(0xFF503750)),
    ('Jazz', Color(0xFF477D95)),
    ('Country', Color(0xFFD84000)),
    ('Classical', Color(0xFF7D4B32)),
    ('Indie', Color(0xFF608108)),
    ('Metal', Color(0xFF777777)),
    ('Latin', Color(0xFFE1118C)),
    ('K-Pop', Color(0xFF148A08)),
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _api.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () => _search(value));
  }

  Future<void> _search(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      setState(() {
        _results = [];
        _error = null;
        _lastQuery = '';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _lastQuery = q;
    });
    try {
      final songs = await _api.searchSongs(q, limit: 40);
      if (!mounted || _lastQuery != q) return;
      setState(() {
        _results = songs;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Search failed. Try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _searchField(),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            onSubmitted: _search,
            style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Artists, songs, or albums',
              hintStyle: const TextStyle(color: Colors.black54),
              prefixIcon: const Icon(Icons.search, color: AppColors.black),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.black),
                      onPressed: () {
                        _controller.clear();
                        _search('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.spotifyGreen),
      );
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: AppColors.lightGrey)),
      );
    }
    if (_lastQuery.isEmpty) {
      return _browseGrid();
    }
    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No results for "$_lastQuery"',
          style: const TextStyle(color: AppColors.lightGrey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: _results.length,
      itemBuilder: (_, i) => SongTile(song: _results[i], queue: _results),
    );
  }

  Widget _browseGrid() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Browse all',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.7,
          children: _genres.map((g) {
            return GestureDetector(
              onTap: () {
                _controller.text = g.$1;
                _search(g.$1);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: g.$2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  g.$1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
