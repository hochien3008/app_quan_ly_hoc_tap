import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Danh sách nhạc có sẵn từ assets
  final List<Map<String, dynamic>> _availableMusic = [
    {
      'name': 'Lo-fi Beats',
      'icon': '🎵',
      'color': 'purple',
      'assetPath': 'music/lofi_beats.mp3',
      'type': 'asset',
    },
    {
      'name': 'Nature Sounds',
      'icon': '🌿',
      'color': 'green',
      'assetPath': 'music/nature_sounds.mp3',
      'type': 'asset',
    },
    {
      'name': 'Classical',
      'icon': '🎹',
      'color': 'blue',
      'assetPath': 'music/classical.mp3',
      'type': 'asset',
    },
    {
      'name': 'White Noise',
      'icon': '🌊',
      'color': 'grey',
      'assetPath': 'music/white_noise.mp3',
      'type': 'asset',
    },
    {
      'name': 'Café Ambience',
      'icon': '☕',
      'color': 'brown',
      'assetPath': 'music/cafe_ambience.mp3',
      'type': 'asset',
    },
  ];

  // Danh sách nhạc từ thiết bị
  final List<Map<String, dynamic>> _customMusic = [];

  // Lấy danh sách nhạc có sẵn
  List<Map<String, dynamic>> get availableMusic => _availableMusic;

  // Lấy danh sách nhạc từ thiết bị
  List<Map<String, dynamic>> get customMusic => _customMusic;

  // Lấy tất cả nhạc (assets + custom)
  List<Map<String, dynamic>> get allMusic => [
    ..._availableMusic,
    ..._customMusic,
  ];

  // Kiểm tra xem file có sẵn không (luôn true vì dùng assets)
  Future<bool> isMusicDownloaded(String musicName) async {
    try {
      final music = _availableMusic.firstWhere((m) => m['name'] == musicName);
      return true; // Luôn true vì file đã có trong assets
    } catch (e) {
      return false;
    }
  }

  // Tải nhạc từ assets (không cần tải vì đã có sẵn)
  Future<String?> downloadMusic(String musicName) async {
    try {
      final music = _availableMusic.firstWhere((m) => m['name'] == musicName);
      return music['assetPath']; // Trả về đường dẫn asset
    } catch (e) {
      debugPrint('Error getting music path: $e');
      return null;
    }
  }

  // Phát nhạc từ assets hoặc thiết bị
  Future<void> playMusic(String musicName) async {
    try {
      // Tìm nhạc trong tất cả danh sách
      final allMusic = [..._availableMusic, ..._customMusic];
      final music = allMusic.firstWhere((m) => m['name'] == musicName);

      debugPrint('🎵 Playing music: $musicName');

      // Dừng nhạc hiện tại nếu đang phát
      await _audioPlayer.stop();

      // Đợi một chút để đảm bảo dừng hoàn toàn
      await Future.delayed(const Duration(milliseconds: 100));

      // Phát nhạc dựa trên loại
      if (music['type'] == 'asset') {
        final assetPath = music['assetPath'];
        debugPrint('🎵 Playing asset: $assetPath');
        await _audioPlayer.play(AssetSource(assetPath));
      } else if (music['type'] == 'custom') {
        final filePath = music['filePath'];
        debugPrint('🎵 Playing custom: $filePath');
        await _audioPlayer.play(DeviceFileSource(filePath));
      }

      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(0.5); // Đặt âm lượng 50%

      debugPrint('✅ Music started successfully');
    } catch (e) {
      debugPrint('❌ Error playing music: $e');
    }
  }

  // Tạm dừng nhạc
  Future<void> pauseMusic() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing music: $e');
    }
  }

  // Tiếp tục phát nhạc
  Future<void> resumeMusic() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint('Error resuming music: $e');
    }
  }

  // Dừng nhạc
  Future<void> stopMusic() async {
    try {
      await _audioPlayer.stop();
      debugPrint('🛑 Music stopped');
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }
  }

  // Chuyển nhạc (dừng nhạc hiện tại và phát nhạc mới)
  Future<void> switchMusic(String musicName) async {
    try {
      debugPrint('🔄 Switching to: $musicName');

      // Dừng nhạc hiện tại
      await _audioPlayer.stop();

      // Đợi một chút để đảm bảo dừng hoàn toàn
      await Future.delayed(const Duration(milliseconds: 150));

      // Phát nhạc mới
      await playMusic(musicName);

      debugPrint('✅ Music switched successfully');
    } catch (e) {
      debugPrint('❌ Error switching music: $e');
    }
  }

  // Điều chỉnh âm lượng
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  // Xóa cache (không cần thiết với assets)
  Future<void> clearCache() async {
    // Không cần làm gì vì dùng assets
    debugPrint('Cache cleared (using assets)');
  }

  // Kiểm tra trạng thái phát nhạc
  bool get isPlaying => _audioPlayer.state == PlayerState.playing;

  // Thêm nhạc từ thiết bị
  Future<bool> addCustomMusic() async {
    try {
      debugPrint('🎵 Opening file picker...');

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'aac'],
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;
        String fileName = result.files.single.name;

        if (filePath != null) {
          File file = File(filePath);

          // Kiểm tra file có tồn tại không
          if (await file.exists()) {
            // Tạo thông tin nhạc mới
            Map<String, dynamic> newMusic = {
              'name': fileName
                  .replaceAll('.mp3', '')
                  .replaceAll('.wav', '')
                  .replaceAll('.m4a', '')
                  .replaceAll('.aac', ''),
              'icon': '📱',
              'color': 'orange',
              'filePath': filePath,
              'type': 'custom',
            };

            _customMusic.add(newMusic);
            debugPrint(
              '✅ Added custom music: ${newMusic['name']} at $filePath',
            );
            return true;
          } else {
            debugPrint('❌ File does not exist: $filePath');
          }
        } else {
          debugPrint('❌ File path is null');
        }
      } else {
        debugPrint('❌ No file selected');
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error adding custom music: $e');
      return false;
    }
  }

  // Xóa nhạc từ thiết bị
  void removeCustomMusic(String musicName) {
    _customMusic.removeWhere((music) => music['name'] == musicName);
    debugPrint('🗑️ Removed custom music: $musicName');
  }

  // Dispose
  void dispose() {
    _audioPlayer.dispose();
  }
}
