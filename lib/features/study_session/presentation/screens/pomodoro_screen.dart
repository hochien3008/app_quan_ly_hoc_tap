import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/firebase_data_service.dart';
import '../../../../core/services/music_service.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isRunning = false;
  bool _isPaused = false;
  int _currentTime = 25 * 60;
  int _totalTime = 25 * 60;
  String _currentMode = 'Work';
  int _completedSessions = 0;
  int _dailyGoal = 8;
  int _currentDaySessions = 0;
  bool _isMusicPlaying = false;

  // Configurable settings
  int _workTimeMinutes = 25;
  int _breakTimeMinutes = 5;
  int _longBreakTimeMinutes = 15;
  int _sessionsBeforeLongBreak = 4;

  final MusicService _musicService = MusicService();
  List<Map<String, dynamic>> _musicOptions = [];

  String _selectedMusic = 'Lo-fi Beats';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();

    // Load saved settings
    _loadSettings();

    // Initialize music options
    _initializeMusicOptions();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _musicService.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (!mounted) return;
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    _pulseController.repeat(reverse: true);
    _runTimer();
    _playMusic();
  }

  void _pauseTimer() {
    if (!mounted) return;
    setState(() {
      _isPaused = true;
    });
    _pulseController.stop();
    _pauseMusic();
  }

  void _resumeTimer() {
    if (!mounted) return;
    setState(() {
      _isPaused = false;
    });
    _pulseController.repeat(reverse: true);
    _runTimer();
    _resumeMusic();
  }

  void _stopTimer() {
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _currentTime = _totalTime;
    });
    _pulseController.stop();
    _stopMusic();
  }

  void _runTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_isRunning && !_isPaused) {
        if (_currentTime > 0) {
          setState(() {
            _currentTime--;
          });
          _runTimer();
        } else {
          _completeSession();
        }
      }
    });
  }

  void _completeSession() {
    if (!mounted) return;
    setState(() {
      if (_currentMode == 'Work') {
        _completedSessions++;
        _currentDaySessions++;
      }
      _isRunning = false;
      _isPaused = false;
    });
    _pulseController.stop();
    _stopMusic();

    // Save study stats to Firebase if user is authenticated
    if (FirebaseDataService().isAuthenticated && _currentMode == 'Work') {
      _saveStudyStatsToFirebase();
    }

    _showSessionCompleteDialog();
  }

  // Save study statistics to Firebase
  Future<void> _saveStudyStatsToFirebase() async {
    try {
      await FirebaseDataService().saveStudyStats(
        totalStudyTime: _workTimeMinutes,
        subjects: {'Pomodoro': _workTimeMinutes},
        completedTasks: 1,
        totalTasks: 1,
        pomodoroSessions: 1,
        focusScore: 85.0, // Default focus score
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error saving study stats to Firebase: $e');
      }
    }
  }

  void _showSessionCompleteDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  _currentMode == 'Work' ? Icons.check_circle : Icons.coffee,
                  color: _currentMode == 'Work' ? Colors.green : Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  _currentMode == 'Work'
                      ? 'Work Session Complete!'
                      : 'Break Time!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentMode == 'Work'
                      ? 'Great job! You\'ve completed a work session. Take a short break.'
                      : 'Break time is over! Ready for the next work session?',
                ),
                if (_currentMode == 'Work') ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Daily Progress: $_currentDaySessions/$_dailyGoal sessions',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              _currentDaySessions >= _dailyGoal
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _switchMode();
                },
                child: const Text('Continue'),
              ),
            ],
          ),
    );
  }

  void _switchMode() {
    if (!mounted) return;
    setState(() {
      if (_currentMode == 'Work') {
        if (_completedSessions % _sessionsBeforeLongBreak == 0) {
          _currentMode = 'Long Break';
          _currentTime = _longBreakTimeMinutes * 60;
          _totalTime = _longBreakTimeMinutes * 60;
        } else {
          _currentMode = 'Break';
          _currentTime = _breakTimeMinutes * 60;
          _totalTime = _breakTimeMinutes * 60;
        }
      } else {
        _currentMode = 'Work';
        _currentTime = _workTimeMinutes * 60;
        _totalTime = _workTimeMinutes * 60;
      }
    });
  }

  void _skipTimer() {
    if (!mounted) return;
    _stopTimer();
    _switchMode();
  }

  void _resetTimer() {
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _currentTime = _totalTime;
    });
    _pulseController.stop();
    _stopMusic();
  }

  void _applySettings() {
    if (!mounted) return;

    // Lưu thời gian cũ để so sánh
    final oldTime = _currentTime;
    final oldMode = _currentMode;

    setState(() {
      // Dừng timer hiện tại
      _isRunning = false;
      _isPaused = false;

      // Áp dụng thời gian mới dựa trên mode hiện tại
      if (_currentMode == 'Work') {
        _currentTime = _workTimeMinutes * 60;
        _totalTime = _workTimeMinutes * 60;
      } else if (_currentMode == 'Break') {
        _currentTime = _breakTimeMinutes * 60;
        _totalTime = _breakTimeMinutes * 60;
      } else if (_currentMode == 'Long Break') {
        _currentTime = _longBreakTimeMinutes * 60;
        _totalTime = _longBreakTimeMinutes * 60;
      }
    });

    _pulseController.stop();
    _stopMusic();

    // Lưu cài đặt mới
    _saveSettings();

    // Tạo thông báo chi tiết
    String message;
    if (oldTime != _currentTime) {
      final oldMinutes = oldTime ~/ 60;
      final newMinutes = _currentTime ~/ 60;
      message = '${oldMode} timer: ${oldMinutes}min → ${newMinutes}min';
    } else {
      message = 'Settings applied successfully!';
    }

    // Hiển thị thông báo thành công với thông tin chi tiết
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Work: ${_workTimeMinutes}min | Break: ${_breakTimeMinutes}min | Long: ${_longBreakTimeMinutes}min',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Lưu cài đặt vào SharedPreferences và Firebase
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('pomodoro_work_time', _workTimeMinutes);
      await prefs.setInt('pomodoro_break_time', _breakTimeMinutes);
      await prefs.setInt('pomodoro_long_break_time', _longBreakTimeMinutes);
      await prefs.setInt(
        'pomodoro_sessions_before_long_break',
        _sessionsBeforeLongBreak,
      );
      await prefs.setInt('pomodoro_daily_goal', _dailyGoal);
      await prefs.setString('pomodoro_selected_music', _selectedMusic);

      // Sync to Firebase if user is authenticated
      if (FirebaseDataService().isAuthenticated) {
        await FirebaseDataService().syncLocalDataToFirebase();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving Pomodoro settings: $e');
      }
    }
  }

  // Load cài đặt từ SharedPreferences và Firebase
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Try to sync from Firebase first if user is authenticated
      if (FirebaseDataService().isAuthenticated) {
        try {
          await FirebaseDataService().syncFirebaseDataToLocal();
        } catch (e) {
          if (kDebugMode) {
            print('Firebase sync failed, using local data: $e');
          }
        }
      }

      setState(() {
        _workTimeMinutes = prefs.getInt('pomodoro_work_time') ?? 25;
        _breakTimeMinutes = prefs.getInt('pomodoro_break_time') ?? 5;
        _longBreakTimeMinutes = prefs.getInt('pomodoro_long_break_time') ?? 15;
        _sessionsBeforeLongBreak =
            prefs.getInt('pomodoro_sessions_before_long_break') ?? 4;
        _dailyGoal = prefs.getInt('pomodoro_daily_goal') ?? 8;
        _selectedMusic =
            prefs.getString('pomodoro_selected_music') ?? 'Lo-fi Beats';

        // Cập nhật timer hiện tại với cài đặt đã lưu
        if (_currentMode == 'Work') {
          _currentTime = _workTimeMinutes * 60;
          _totalTime = _workTimeMinutes * 60;
        } else if (_currentMode == 'Break') {
          _currentTime = _breakTimeMinutes * 60;
          _totalTime = _breakTimeMinutes * 60;
        } else if (_currentMode == 'Long Break') {
          _currentTime = _longBreakTimeMinutes * 60;
          _totalTime = _longBreakTimeMinutes * 60;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Pomodoro settings: $e');
      }
    }
  }

  void _playMusic() async {
    if (!_isMusicPlaying) {
      setState(() {
        _isMusicPlaying = true;
      });
      HapticFeedback.lightImpact();

      await _musicService.playMusic(_selectedMusic);
    }
  }

  void _pauseMusic() async {
    if (_isMusicPlaying) {
      setState(() {
        _isMusicPlaying = false;
      });
      await _musicService.pauseMusic();
    }
  }

  void _resumeMusic() async {
    if (!_isMusicPlaying) {
      setState(() {
        _isMusicPlaying = true;
      });
      await _musicService.resumeMusic();
    }
  }

  void _stopMusic() async {
    setState(() {
      _isMusicPlaying = false;
    });
    await _musicService.stopMusic();
  }

  void _initializeMusicOptions() {
    setState(() {
      _musicOptions =
          _musicService.allMusic.map((music) {
            return {
              'name': music['name'],
              'icon': _getIconFromString(music['icon']),
              'color': _getColorFromString(music['color']),
              'type': music['type'],
            };
          }).toList();
    });
  }

  IconData _getIconFromString(String iconString) {
    switch (iconString) {
      case '🎵':
        return Icons.music_note;
      case '🌿':
        return Icons.nature;
      case '🎹':
        return Icons.piano;
      case '🌊':
        return Icons.waves;
      case '☕':
        return Icons.coffee;
      default:
        return Icons.music_note;
    }
  }

  Color _getColorFromString(String colorString) {
    switch (colorString) {
      case 'purple':
        return Colors.purple;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'grey':
        return Colors.grey;
      case 'brown':
        return Colors.brown;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  // Thêm nhạc từ thiết bị
  Future<void> _addCustomMusic() async {
    final success = await _musicService.addCustomMusic();
    if (success) {
      // Cập nhật danh sách nhạc
      _initializeMusicOptions();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Đã thêm nhạc thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Không thể thêm nhạc'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Xóa nhạc từ thiết bị
  void _removeCustomMusic(String musicName) {
    _musicService.removeCustomMusic(musicName);
    _initializeMusicOptions();

    // Nếu nhạc bị xóa đang được chọn, chuyển về nhạc mặc định
    if (_selectedMusic == musicName) {
      _selectedMusic = 'Lo-fi Beats';
      _saveSettings();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🗑️ Đã xóa $musicName'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _selectMusic(String musicName) async {
    setState(() {
      _selectedMusic = musicName;
    });

    // Nếu đang phát nhạc, chuyển sang nhạc mới
    if (_isMusicPlaying) {
      // Hiển thị thông báo chuyển nhạc
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.swap_horiz, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text('Đang chuyển sang $musicName...'),
            ],
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.blue,
        ),
      );

      await _musicService.switchMusic(musicName);
    }

    // Lưu cài đặt nhạc
    _saveSettings();
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.timer,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Timer Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Customize your Pomodoro timer',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTimeSection(setDialogState),
                      const SizedBox(height: 20),
                      _buildGoalSection(setDialogState),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _applySettings();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          ),
    );
  }

  Widget _buildTimeSection(StateSetter setDialogState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Timer Duration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimeSettingItem(
            'Work Session',
            _workTimeMinutes.toDouble(),
            5.0,
            60.0,
            Icons.work,
            Colors.red,
            (value) {
              setDialogState(() {
                _workTimeMinutes = value.round();
              });
            },
          ),
          const SizedBox(height: 12),
          _buildTimeSettingItem(
            'Short Break',
            _breakTimeMinutes.toDouble(),
            1.0,
            30.0,
            Icons.coffee,
            Colors.orange,
            (value) {
              setDialogState(() {
                _breakTimeMinutes = value.round();
              });
            },
          ),
          const SizedBox(height: 12),
          _buildTimeSettingItem(
            'Long Break',
            _longBreakTimeMinutes.toDouble(),
            5.0,
            60.0,
            Icons.beach_access,
            Colors.green,
            (value) {
              setDialogState(() {
                _longBreakTimeMinutes = value.round();
              });
            },
          ),
          const SizedBox(height: 12),
          _buildTimeSettingItem(
            'Sessions before Long Break',
            _sessionsBeforeLongBreak.toDouble(),
            2.0,
            8.0,
            Icons.repeat,
            Colors.purple,
            (value) {
              setDialogState(() {
                _sessionsBeforeLongBreak = value.round();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSection(StateSetter setDialogState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Daily Goal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimeSettingItem(
            'Target Sessions per Day',
            _dailyGoal.toDouble(),
            1.0,
            20.0,
            Icons.trending_up,
            Colors.green,
            (value) {
              setDialogState(() {
                _dailyGoal = value.round();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSettingItem(
    String label,
    double value,
    double min,
    double max,
    IconData icon,
    Color color,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.round()} min',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
          activeColor: color,
          inactiveColor: color.withOpacity(0.2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${min.round()} min',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              '${max.round()} min',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double _getProgress() {
    return (_totalTime - _currentTime) / _totalTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: const Text(
                    'Pomodoro Timer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.timer, color: Colors.white),
                    onPressed: _showSettingsDialog,
                    tooltip: 'Timer Settings',
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildGoalCard(),
                      const SizedBox(height: 20),
                      _buildTimerCard(),
                      const SizedBox(height: 20),
                      _buildControlsCard(),
                      const SizedBox(height: 20),
                      _buildMusicCard(),
                      const SizedBox(height: 20),
                      _buildStatsCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard() {
    final progress = _currentDaySessions / _dailyGoal;
    final isGoalCompleted = _currentDaySessions >= _dailyGoal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.flag,
                color:
                    isGoalCompleted
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Daily Goal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isGoalCompleted ? Colors.green : null,
                ),
              ),
              const Spacer(),
              Text(
                '$_currentDaySessions/$_dailyGoal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      isGoalCompleted
                          ? Colors.green
                          : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isGoalCompleted
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
            ),
            minHeight: 8,
          ),
          if (isGoalCompleted) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.celebration, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Goal completed! Great job!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color:
                  _currentMode == 'Work'
                      ? Colors.red.withOpacity(0.1)
                      : _currentMode == 'Long Break'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    _currentMode == 'Work'
                        ? Colors.red
                        : _currentMode == 'Long Break'
                        ? Colors.green
                        : Colors.orange,
                width: 1,
              ),
            ),
            child: Text(
              _currentMode,
              style: TextStyle(
                color:
                    _currentMode == 'Work'
                        ? Colors.red
                        : _currentMode == 'Long Break'
                        ? Colors.green
                        : Colors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 30),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isRunning ? _pulseAnimation.value : 1.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: _getProgress(),
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _currentMode == 'Work'
                              ? Colors.red
                              : _currentMode == 'Long Break'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          _formatTime(_currentTime),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color:
                                _currentMode == 'Work'
                                    ? Colors.red
                                    : _currentMode == 'Long Break'
                                    ? Colors.green
                                    : Colors.orange,
                          ),
                        ),
                        Text(
                          _currentMode == 'Work' ? 'Focus Time' : 'Break Time',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.skip_previous,
                label: 'Skip',
                onPressed: _skipTimer,
                color: Colors.grey,
              ),
              _buildControlButton(
                icon:
                    _isRunning
                        ? (_isPaused ? Icons.play_arrow : Icons.pause)
                        : Icons.play_arrow,
                label: _isRunning ? (_isPaused ? 'Resume' : 'Pause') : 'Start',
                onPressed:
                    _isRunning
                        ? (_isPaused ? _resumeTimer : _pauseTimer)
                        : _startTimer,
                color:
                    _isRunning
                        ? (_isPaused ? Colors.green : Colors.orange)
                        : Theme.of(context).colorScheme.primary,
              ),
              _buildControlButton(
                icon: Icons.stop,
                label: 'Stop',
                onPressed: _stopTimer,
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _resetTimer,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Timer'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onPressed,
            iconSize: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMusicCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với switch
          Row(
            children: [
              Icon(
                _isMusicPlaying ? Icons.music_note : Icons.music_off,
                color: _isMusicPlaying ? Colors.green : Colors.grey,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Background Music',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Switch(
                value: _isMusicPlaying,
                onChanged: (value) {
                  if (value) {
                    _playMusic();
                  } else {
                    _pauseMusic();
                  }
                },
                activeColor: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nút thêm nhạc
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addCustomMusic,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Thêm nhạc từ thiết bị'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue.shade700,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.shade200),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Danh sách nhạc
          Text(
            'Nhạc có sẵn',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _musicOptions.map((music) {
                  final isSelected = music['name'] == _selectedMusic;
                  final isCustom = music['type'] == 'custom';

                  return GestureDetector(
                    onTap: () => _selectMusic(music['name']),
                    onLongPress:
                        isCustom
                            ? () => _removeCustomMusic(music['name'])
                            : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? music['color'].withOpacity(0.2)
                                : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected
                                  ? music['color']
                                  : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: music['color'].withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(music['icon'], color: music['color'], size: 16),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              music['name'],
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? music['color']
                                        : Colors.grey.shade700,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.green,
                            ),
                          if (isCustom)
                            Icon(
                              Icons.phone_android,
                              size: 12,
                              color: Colors.orange,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),

          // Hướng dẫn
          if (_musicOptions.any((music) => music['type'] == 'custom'))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '💡 Nhấn giữ để xóa nhạc từ thiết bị',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Session Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Today',
                  '$_currentDaySessions',
                  Icons.today,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Total',
                  '$_completedSessions',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Goal',
                  '$_dailyGoal',
                  Icons.flag,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
