import 'package:flutter/material.dart';
import 'package:quan_ly_hoc_tap/shared/widgets/custom_appbar.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isRunning = false;
  bool _isPaused = false;
  int _currentTime = 25 * 60; // 25 minutes in seconds
  int _totalTime = 25 * 60;
  String _currentMode = 'Work';
  int _completedSessions = 0;
  int _totalSessions = 0;

  final List<String> _musicOptions = [
    'Lo-fi Beats',
    'Nature Sounds',
    'Classical',
    'White Noise',
    'Café Ambience',
  ];
  String _selectedMusic = 'Lo-fi Beats';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
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
  }

  void _pauseTimer() {
    if (!mounted) return;
    setState(() {
      _isPaused = true;
    });
    _pulseController.stop();
  }

  void _resumeTimer() {
    if (!mounted) return;
    setState(() {
      _isPaused = false;
    });
    _pulseController.repeat(reverse: true);
    _runTimer();
  }

  void _stopTimer() {
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _currentTime = _totalTime;
    });
    _pulseController.stop();
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
      _completedSessions++;
      _isRunning = false;
      _isPaused = false;
    });
    _pulseController.stop();
    _showSessionCompleteDialog();
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
            content: Text(
              _currentMode == 'Work'
                  ? 'Great job! You\'ve completed a work session. Take a short break.'
                  : 'Break time is over! Ready for the next work session?',
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
        _currentMode = 'Break';
        _currentTime = 5 * 60; // 5 minutes break
        _totalTime = 5 * 60;
      } else {
        _currentMode = 'Work';
        _currentTime = 25 * 60; // 25 minutes work
        _totalTime = 25 * 60;
      }
    });
  }

  void _skipTimer() {
    if (!mounted) return;
    _completeSession();
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Pomodoro Timer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildModeSelector(),
                    const SizedBox(height: 30),
                    _buildTimerDisplay(),
                    const SizedBox(height: 30),
                    _buildControlButtons(),
                    const SizedBox(height: 30),
                    _buildMusicSelector(),
                    const SizedBox(height: 30),
                    _buildSessionStats(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!mounted) return;
                setState(() {
                  _currentMode = 'Work';
                  _currentTime = 25 * 60;
                  _totalTime = 25 * 60;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color:
                      _currentMode == 'Work'
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.work,
                      size: 20,
                      color:
                          _currentMode == 'Work'
                              ? Colors.white
                              : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Work',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:
                            _currentMode == 'Work'
                                ? Colors.white
                                : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!mounted) return;
                setState(() {
                  _currentMode = 'Break';
                  _currentTime = 5 * 60;
                  _totalTime = 5 * 60;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color:
                      _currentMode == 'Break'
                          ? Colors.orange
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.coffee,
                      size: 20,
                      color:
                          _currentMode == 'Break'
                              ? Colors.white
                              : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Break',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:
                            _currentMode == 'Break'
                                ? Colors.white
                                : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isRunning ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      _currentMode == 'Work'
                          ? [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.05),
                          ]
                          : [
                            Colors.orange.withOpacity(0.1),
                            Colors.orange.withOpacity(0.05),
                          ],
                ),
                border: Border.all(
                  color:
                      _currentMode == 'Work'
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3)
                          : Colors.orange.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: CircularProgressIndicator(
                      value: _getProgress(),
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _currentMode == 'Work'
                            ? Theme.of(context).colorScheme.primary
                            : Colors.orange,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(_currentTime),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color:
                              _currentMode == 'Work'
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentMode,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!_isRunning)
          _buildControlButton(
            icon: Icons.play_arrow,
            label: 'Start',
            color: Colors.green,
            onTap: _startTimer,
          )
        else if (_isPaused)
          _buildControlButton(
            icon: Icons.play_arrow,
            label: 'Resume',
            color: Colors.green,
            onTap: _resumeTimer,
          )
        else
          _buildControlButton(
            icon: Icons.pause,
            label: 'Pause',
            color: Colors.orange,
            onTap: _pauseTimer,
          ),
        _buildControlButton(
          icon: Icons.stop,
          label: 'Stop',
          color: Colors.red,
          onTap: _stopTimer,
        ),
        _buildControlButton(
          icon: Icons.skip_next,
          label: 'Skip',
          color: Colors.blue,
          onTap: _skipTimer,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicSelector() {
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
                Icons.music_note,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Background Music',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _musicOptions.map((music) {
                  bool isSelected = _selectedMusic == music;
                  return GestureDetector(
                    onTap: () {
                      if (!mounted) return;
                      setState(() {
                        _selectedMusic = music;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        music,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStats() {
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
              const Text(
                'Session Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  title: 'Completed',
                  value: _completedSessions.toString(),
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.timer,
                  title: 'Total Time',
                  value: '${(_completedSessions * 25)}m',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
