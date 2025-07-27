import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _seconds = 25 * 60;
  bool _isRunning = false;
  String _selectedMusic = 'Lo-fi';
  final List<String> _musicOptions = ['Lo-fi', 'Rain', 'Cafe', 'None'];
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick);
  }

  void _onTick(Duration elapsed) {
    if (_isRunning && _seconds > 0) {
      setState(() => _seconds--);
    } else if (_seconds == 0) {
      _ticker.stop();
      setState(() => _isRunning = false);
      // TODO: Play sound/notification
    }
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _ticker.start();
  }

  void _pauseTimer() {
    setState(() => _isRunning = false);
    _ticker.stop();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _seconds = 25 * 60;
    });
    _ticker.stop();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Đồng hồ lớn
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.12),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$minutes:$seconds',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Chọn nhạc nền
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedMusic,
                  items:
                      _musicOptions
                          .map(
                            (music) => DropdownMenuItem(
                              value: music,
                              child: Row(
                                children: [
                                  Icon(
                                    _getMusicIcon(music),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(music),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedMusic = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Nút Bắt đầu/Dừng
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    _isRunning ? 'Pause' : 'Start',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 24),
                OutlinedButton(
                  onPressed: _resetTimer,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Reset', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMusicIcon(String music) {
    switch (music) {
      case 'Lo-fi':
        return Icons.music_note;
      case 'Rain':
        return Icons.grain;
      case 'Cafe':
        return Icons.local_cafe;
      default:
        return Icons.volume_off;
    }
  }
}

// Simple ticker for demo (replace with Timer.periodic or a package in production)
class Ticker {
  final void Function(Duration) onTick;
  Duration _elapsed = Duration.zero;
  bool _isActive = false;
  Ticker(this.onTick);
  void start() {
    _isActive = true;
    _tick();
  }

  void stop() {
    _isActive = false;
  }

  void _tick() async {
    while (_isActive) {
      await Future.delayed(const Duration(seconds: 1));
      if (_isActive) {
        _elapsed += const Duration(seconds: 1);
        onTick(_elapsed);
      }
    }
  }

  void dispose() {
    _isActive = false;
  }
}
