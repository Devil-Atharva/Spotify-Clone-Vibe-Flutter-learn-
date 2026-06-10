import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/song.dart';

/// Persists the user's liked songs and recently played history locally.
class LibraryProvider extends ChangeNotifier {
  static const _likedKey = 'liked_songs';
  static const _recentKey = 'recent_songs';
  static const _maxRecent = 30;

  final List<Song> _liked = [];
  final List<Song> _recent = [];
  bool _loaded = false;

  List<Song> get liked => List.unmodifiable(_liked);
  List<Song> get recent => List.unmodifiable(_recent);
  bool get loaded => _loaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _liked
      ..clear()
      ..addAll(_decode(prefs.getString(_likedKey)));
    _recent
      ..clear()
      ..addAll(_decode(prefs.getString(_recentKey)));
    _loaded = true;
    notifyListeners();
  }

  bool isLiked(Song song) => _liked.any((s) => s.id == song.id);

  Future<void> toggleLike(Song song) async {
    if (isLiked(song)) {
      _liked.removeWhere((s) => s.id == song.id);
    } else {
      _liked.insert(0, song);
    }
    notifyListeners();
    await _persist(_likedKey, _liked);
  }

  Future<void> addRecent(Song song) async {
    _recent.removeWhere((s) => s.id == song.id);
    _recent.insert(0, song);
    if (_recent.length > _maxRecent) {
      _recent.removeRange(_maxRecent, _recent.length);
    }
    notifyListeners();
    await _persist(_recentKey, _recent);
  }

  List<Song> _decode(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = json.decode(raw) as List<dynamic>;
      return list.whereType<Map<String, dynamic>>().map(Song.fromJson).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _persist(String key, List<Song> songs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      key,
      json.encode(songs.map((s) => s.toJson()).toList()),
    );
  }
}
