// Smoke tests for the Spotify clone.

import 'package:flutter_test/flutter_test.dart';
import 'package:spotify/models/song.dart';

void main() {
  group('Song', () {
    test('parses an iTunes search result', () {
      final song = Song.fromJson({
        'trackId': 123,
        'trackName': 'Blinding Lights',
        'artistName': 'The Weeknd',
        'collectionName': 'After Hours',
        'artworkUrl100': 'https://example.com/100x100bb.jpg',
        'previewUrl': 'https://example.com/preview.m4a',
        'trackTimeMillis': 200000,
        'primaryGenreName': 'Pop',
      });

      expect(song.id, '123');
      expect(song.title, 'Blinding Lights');
      expect(song.artist, 'The Weeknd');
      expect(song.duration, const Duration(milliseconds: 200000));
      expect(song.isPlayable, isTrue);
    });

    test('upgrades artwork resolution', () {
      final song = Song.fromJson({
        'trackId': 1,
        'artworkUrl100': 'https://example.com/a/100x100bb.jpg',
      });
      expect(song.artworkHighRes(600), 'https://example.com/a/600x600bb.jpg');
    });

    test('handles missing fields gracefully', () {
      final song = Song.fromJson({'trackId': 9});
      expect(song.title, 'Unknown Title');
      expect(song.artist, 'Unknown Artist');
      expect(song.isPlayable, isFalse);
    });

    test('round-trips through json', () {
      final original = Song.fromJson({
        'trackId': 42,
        'trackName': 'Song',
        'artistName': 'Artist',
        'previewUrl': 'https://example.com/p.m4a',
        'trackTimeMillis': 30000,
      });
      final restored = Song.fromJson(original.toJson());
      expect(restored, equals(original));
      expect(restored.title, 'Song');
    });
  });
}
