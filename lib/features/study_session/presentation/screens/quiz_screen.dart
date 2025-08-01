import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/firebase_data_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  bool _isQuizStarted = false;
  bool _isQuizCompleted = false;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _totalQuestions = 10;
  int _timeRemaining = 300; // 5 minutes
  bool _isTimerRunning = false;
  Map<int, int> _userAnswers = {}; // question index -> selected answer

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['London', 'Berlin', 'Paris', 'Madrid'],
      'correct': 2,
      'explanation': 'Paris is the capital and largest city of France.',
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      'correct': 1,
      'explanation':
          'Mars is called the Red Planet due to its reddish appearance.',
    },
    {
      'question': 'What is the chemical symbol for gold?',
      'options': ['Ag', 'Au', 'Fe', 'Cu'],
      'correct': 1,
      'explanation': 'Au comes from the Latin word "aurum" meaning gold.',
    },
    {
      'question': 'Who wrote "Romeo and Juliet"?',
      'options': [
        'Charles Dickens',
        'William Shakespeare',
        'Jane Austen',
        'Mark Twain',
      ],
      'correct': 1,
      'explanation': 'William Shakespeare wrote this famous tragedy.',
    },
    {
      'question': 'What is the largest ocean on Earth?',
      'options': [
        'Atlantic Ocean',
        'Indian Ocean',
        'Arctic Ocean',
        'Pacific Ocean',
      ],
      'correct': 3,
      'explanation': 'The Pacific Ocean is the largest and deepest ocean.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    if (!mounted) return;
    setState(() {
      _isQuizStarted = true;
      _isTimerRunning = true;
    });
    _slideController.forward();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_isTimerRunning && _timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
        _startTimer();
      } else if (_timeRemaining == 0) {
        _completeQuiz();
      }
    });
  }

  void _answerQuestion(int selectedOption) {
    if (!mounted) return;

    // Save user's answer
    _userAnswers[_currentQuestionIndex] = selectedOption;

    if (selectedOption == _questions[_currentQuestionIndex]['correct']) {
      _correctAnswers++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _slideController.reset();
      _slideController.forward();
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    if (!mounted) return;
    setState(() {
      _isQuizCompleted = true;
      _isTimerRunning = false;
    });

    // Save quiz result to Firebase if user is authenticated
    if (FirebaseDataService().isAuthenticated) {
      _saveQuizResultToFirebase();
    }
  }

  // Save quiz result to Firebase
  Future<void> _saveQuizResultToFirebase() async {
    try {
      final questions =
          _questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return {
              'question': question['question'],
              'userAnswer': _userAnswers[index] ?? -1,
              'correctAnswer': question['correct'],
              'isCorrect': _userAnswers[index] == question['correct'],
            };
          }).toList();

      await FirebaseDataService().saveQuizResult(
        title: 'General Knowledge Quiz',
        subject: 'General',
        totalQuestions: _questions.length,
        correctAnswers: _correctAnswers,
        timeSpent: 300 - _timeRemaining, // Time spent in seconds
        score: (_correctAnswers / _questions.length) * 100,
        questions: questions,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error saving quiz result to Firebase: $e');
      }
    }
  }

  void _resetQuiz() {
    if (!mounted) return;
    setState(() {
      _isQuizStarted = false;
      _isQuizCompleted = false;
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _timeRemaining = 300;
      _isTimerRunning = false;
      _userAnswers.clear();
    });
    _slideController.reset();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double _getProgress() {
    return (_currentQuestionIndex + 1) / _questions.length;
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
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 32),
                child: const Text(
                  'Quiz & Test',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (!_isQuizStarted) _buildSetup(),
                    if (_isQuizStarted && !_isQuizCompleted) _buildQuiz(),
                    if (_isQuizCompleted) _buildResult(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetup() {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          _buildSetupCard(),
          const SizedBox(height: 24),
          _buildQuizOptions(),
          const SizedBox(height: 24),
          _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildSetupCard() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.quiz,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ready to Test Your Knowledge?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Challenge yourself with our interactive quiz system',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizOptions() {
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
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Quiz Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildOptionRow(
            icon: Icons.question_answer,
            title: 'Questions',
            value: '${_questions.length} questions',
          ),
          const SizedBox(height: 16),
          _buildOptionRow(
            icon: Icons.timer,
            title: 'Time Limit',
            value: '5 minutes',
          ),
          const SizedBox(height: 16),
          _buildOptionRow(
            icon: Icons.category,
            title: 'Subject',
            value: 'General Knowledge',
          ),
          const SizedBox(height: 16),
          _buildOptionRow(
            icon: Icons.emoji_events,
            title: 'Difficulty',
            value: 'Mixed',
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _startQuiz,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow, size: 24),
            SizedBox(width: 8),
            Text(
              'Start Quiz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          _buildTimer(),
          const SizedBox(height: 20),
          _buildProgressBar(),
          const SizedBox(height: 20),
          _buildQuestionCard(),
          const SizedBox(height: 20),
          _buildOptions(),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color:
            _timeRemaining < 60
                ? Colors.red.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _timeRemaining < 60
                  ? Colors.red.withOpacity(0.3)
                  : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            color: _timeRemaining < 60 ? Colors.red : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            _formatTime(_timeRemaining),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _timeRemaining < 60 ? Colors.red : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${((_currentQuestionIndex + 1) / _questions.length * 100).round()}%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: _getProgress(),
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    final question = _questions[_currentQuestionIndex];
    return Container(
      padding: const EdgeInsets.all(24),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.help_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Question',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question['question'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    final question = _questions[_currentQuestionIndex];
    final options = question['options'] as List<String>;

    return Column(
      children:
          options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _answerQuestion(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.shade400,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildResult() {
    final score = (_correctAnswers / _questions.length * 100).round();
    final isPassed = score >= 70;

    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          _buildResultCard(score, isPassed),
          const SizedBox(height: 24),
          _buildScoreDetails(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildResultCard(int score, bool isPassed) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color:
                  isPassed
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPassed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 60,
              color: isPassed ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isPassed ? 'Congratulations!' : 'Keep Trying!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: isPassed ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPassed ? 'You passed the quiz!' : 'You need more practice',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isPassed
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isPassed
                        ? Colors.green.withOpacity(0.3)
                        : Colors.red.withOpacity(0.3),
              ),
            ),
            child: Text(
              '$score%',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: isPassed ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDetails() {
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
                Icons.analytics,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Quiz Summary',
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
                  title: 'Correct',
                  value: '$_correctAnswers',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.cancel,
                  title: 'Incorrect',
                  value: '${_questions.length - _correctAnswers}',
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.timer,
                  title: 'Time Used',
                  value: _formatTime(300 - _timeRemaining),
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.speed,
                  title: 'Accuracy',
                  value:
                      '${(_correctAnswers / _questions.length * 100).round()}%',
                  color: Colors.purple,
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _resetQuiz,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navigate to quiz list or create new quiz
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'New Quiz',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
