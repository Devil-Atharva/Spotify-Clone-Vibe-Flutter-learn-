import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models/song.dart';

enum RepeatMode { off, all, one }

/// Owns the [AudioPlayer], the active queue, and all playback state.
class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  final List<Song> _queue = [];
  List<int> _order = []; // indices into _queue (shuffle-aware)
  int _orderPos = -1;

  bool _isPlaying = false;
  bool _isLoading = false;
  bool _shuffle = false;
  RepeatMode _repeat = RepeatMode.off;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String? _error;

  final List<StreamSubscription> _subs = [];

  PlayerProvider() {
    _player.setReleaseMode(ReleaseMode.stop);
    _subs.add(
      _player.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;
        if (state == PlayerState.playing) _isLoading = false;
        notifyListeners();
      }),
    );
    _subs.add(
      _player.onPositionChanged.listen((pos) {
        _position = pos;
        notifyListeners();
      }),
    );
    _subs.add(
      _player.onDurationChanged.listen((dur) {
        _duration = dur;
        notifyListeners();
      }),
    );
    _subs.add(_player.onPlayerComplete.listen((_) => _onComplete()));
  }

  // ---- Getters -------------------------------------------------------------
  Song? get currentSong => _orderPos >= 0 && _orderPos < _order.length
      ? _queue[_order[_orderPos]]
      : null;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get shuffle => _shuffle;
  RepeatMode get repeat => _repeat;
  Duration get position => _position;
  Duration get duration => _duration == Duration.zero
      ? const Duration(seconds: 30) // previews are ~30s
      : _duration;
  String? get error => _error;
  bool get hasSong => currentSong != null;
  List<Song> get queue => List.unmodifiable(_queue);

  double get progress {
    final total = duration.inMilliseconds;
    if (total == 0) return 0;
    return (_position.inMilliseconds / total).clamp(0.0, 1.0);
  }

  // ---- Playback control ----------------------------------------------------

  /// Start playing [song], establishing [queue] (defaults to a single song)
  /// as the active queue.
  Future<void> playSong(Song song, {List<Song>? queue}) async {
    final list = queue ?? [song];
    _queue
      ..clear()
      ..addAll(list);
    _rebuildOrder(startId: song.id);
    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    final song = currentSong;
    if (song == null || !song.isPlayable) {
      _error = 'No preview available for this track';
      notifyListeners();
      return;
    }
    try {
      _error = null;
      _isLoading = true;
      _position = Duration.zero;
      notifyListeners();
      await _player.stop();
      await _player.play(UrlSource(song.previewUrl));
    } catch (e) {
      _isLoading = false;
      _error = 'Could not play track';
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    if (currentSong == null) return;
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
  }

  Future<void> next({bool auto = false}) async {
    if (_order.isEmpty) return;
    if (_repeat == RepeatMode.one && auto) {
      await _playCurrent();
      return;
    }
    if (_orderPos < _order.length - 1) {
      _orderPos++;
    } else if (_repeat == RepeatMode.all || !auto) {
      _orderPos = 0; // wrap around
    } else {
      // End of queue, no repeat.
      await _player.stop();
      _isPlaying = false;
      _position = Duration.zero;
      notifyListeners();
      return;
    }
    await _playCurrent();
  }

  Future<void> previous() async {
    if (_order.isEmpty) return;
    // Restart current track if we're more than 3s in.
    if (_position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }
    if (_orderPos > 0) {
      _orderPos--;
    } else {
      _orderPos = _order.length - 1;
    }
    await _playCurrent();
  }

  Future<void> seek(Duration to) async {
    await _player.seek(to);
    _position = to;
    notifyListeners();
  }

  void toggleShuffle() {
    _shuffle = !_shuffle;
    final current = currentSong;
    _rebuildOrder(startId: current?.id);
    notifyListeners();
  }

  void cycleRepeat() {
    _repeat = RepeatMode.values[(_repeat.index + 1) % RepeatMode.values.length];
    notifyListeners();
  }

  // ---- Internals -----------------------------------------------------------

  void _rebuildOrder({String? startId}) {
    final indices = List<int>.generate(_queue.length, (i) => i);
    if (_shuffle) {
      indices.shuffle();
    }
    // Make the requested start song the first to play.
    if (startId != null) {
      final startIdx = _queue.indexWhere((s) => s.id == startId);
      if (startIdx != -1) {
        indices.remove(startIdx);
        indices.insert(0, startIdx);
        _orderPos = 0;
      }
    }
    _order = indices;
    if (_orderPos < 0 && _order.isNotEmpty) _orderPos = 0;
  }

  Future<void> _onComplete() async {
    await next(auto: true);
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }
}
