import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();

  factory SoundManager() => _instance;

  late AudioCache _audioCache;

  SoundManager._internal() {
    _audioCache = AudioCache(prefix: 'assets/');
    _loadSounds();
  }

  void _loadSounds() {
    _audioCache.loadAll([
      'click.wav',
    ]);
  }

  Future<void> playClickSound() async {
    AudioPlayer player = AudioPlayer();
    await player.play(AssetSource('click.wav'), mode: PlayerMode.lowLatency);
  }
}
