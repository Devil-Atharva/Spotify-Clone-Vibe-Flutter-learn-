/// A single playable track sourced from the iTunes Search API.
class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String artworkUrl; // base 100x100 url, upgraded on demand
  final String previewUrl; // 30s m4a preview
  final Duration duration; // full track length (preview is ~30s)
  final String genre;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.artworkUrl,
    required this.previewUrl,
    required this.duration,
    required this.genre,
  });

  /// Higher resolution artwork by swapping the iTunes size token.
  String artworkHighRes([int size = 600]) =>
      artworkUrl.replaceAll('100x100bb', '${size}x${size}bb');

  factory Song.fromJson(Map<String, dynamic> json) {
    final millis = (json['trackTimeMillis'] as num?)?.toInt() ?? 0;
    return Song(
      id: (json['trackId'] ?? json['collectionId'] ?? '').toString(),
      title: (json['trackName'] ?? 'Unknown Title').toString(),
      artist: (json['artistName'] ?? 'Unknown Artist').toString(),
      album: (json['collectionName'] ?? '').toString(),
      artworkUrl: (json['artworkUrl100'] ?? '').toString(),
      previewUrl: (json['previewUrl'] ?? '').toString(),
      duration: Duration(milliseconds: millis),
      genre: (json['primaryGenreName'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'trackId': id,
    'trackName': title,
    'artistName': artist,
    'collectionName': album,
    'artworkUrl100': artworkUrl,
    'previewUrl': previewUrl,
    'trackTimeMillis': duration.inMilliseconds,
    'primaryGenreName': genre,
  };

  bool get isPlayable => previewUrl.isNotEmpty;

  @override
  bool operator ==(Object other) => other is Song && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
