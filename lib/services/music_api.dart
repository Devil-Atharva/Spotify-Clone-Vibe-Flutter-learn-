import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/song.dart';

/// Thin client over the free iTunes Search API.
///
/// No API key required. Returns 30-second track previews + artwork.
/// Docs: https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/
class MusicApi {
  static const String _base = 'https://itunes.apple.com';

  final http.Client _client;

  MusicApi({http.Client? client}) : _client = client ?? http.Client();

  /// Search songs by free-text query.
  Future<List<Song>> searchSongs(String query, {int limit = 30}) async {
    if (query.trim().isEmpty) return [];
    final uri = Uri.parse('$_base/search').replace(
      queryParameters: {
        'term': query,
        'media': 'music',
        'entity': 'song',
        'limit': '$limit',
      },
    );
    return _fetchSongs(uri);
  }

  /// Fetch a curated "playlist" by treating a search term as a theme.
  /// Only playable (preview-bearing) tracks are kept.
  Future<List<Song>> fetchByTerm(String term, {int limit = 25}) async {
    final songs = await searchSongs(term, limit: limit);
    return songs.where((s) => s.isPlayable).toList();
  }

  Future<List<Song>> _fetchSongs(Uri uri) async {
    final resp = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (resp.statusCode != 200) {
      throw MusicApiException('Request failed (${resp.statusCode})');
    }
    final body = json.decode(resp.body) as Map<String, dynamic>;
    final results = (body['results'] as List<dynamic>? ?? []);
    final songs = results
        .whereType<Map<String, dynamic>>()
        .map(Song.fromJson)
        .where((s) => s.id.isNotEmpty)
        .toList();
    // De-duplicate by id while preserving order.
    final seen = <String>{};
    return songs.where((s) => seen.add(s.id)).toList();
  }

  void dispose() => _client.close();
}

class MusicApiException implements Exception {
  final String message;
  MusicApiException(this.message);
  @override
  String toString() => message;
}
