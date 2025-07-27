import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String _selectedSubject = 'Math';
  String _selectedLevel = 'Easy';
  int _numQuestions = 5;
  bool _quizStarted = false;
  int _currentQuestion = 0;
  int _score = 0;
  bool _showResult = false;
  List<Map<String, dynamic>> _questions = [];
  int _timer = 30;
  bool _isRunning = false;

  final List<String> _subjects = ['Math', 'English', 'Physics', 'Chemistry'];
  final List<String> _levels = ['Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz/Test'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child:
            _showResult
                ? _buildResult()
                : _quizStarted
                ? _buildQuiz()
                : _buildSetup(),
      ),
    );
  }

  Widget _buildSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Random Quiz',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        Text('Subject', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _selectedSubject,
          items:
              _subjects
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
          onChanged: (v) => setState(() => _selectedSubject = v!),
        ),
        const SizedBox(height: 16),
        Text('Level', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _selectedLevel,
          items:
              _levels
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
          onChanged: (v) => setState(() => _selectedLevel = v!),
        ),
        const SizedBox(height: 16),
        Text(
          'Number of Questions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Slider(
          value: _numQuestions.toDouble(),
          min: 3,
          max: 10,
          divisions: 7,
          label: '$_numQuestions',
          onChanged: (v) => setState(() => _numQuestions = v.round()),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shuffle),
            label: const Text('Create Random Quiz'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: _startQuiz,
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz() {
    final q = _questions[_currentQuestion];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
              label: Text('${_selectedSubject} - ${_selectedLevel}'),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.12),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            _buildTimer(),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Q${_currentQuestion + 1}: ${q['question']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(q['options'].length, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              onPressed: () => _answer(i),
              child: Text(
                q['options'][i],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }),
        const Spacer(),
        Text(
          'Question ${_currentQuestion + 1} / $_numQuestions',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, size: 18),
          const SizedBox(width: 4),
          Text(
            '$_timer s',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 48),
              const SizedBox(height: 16),
              Text('Your Score', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                '$_score / $_numQuestions',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'AI Feedback: Great job! Keep practicing for even better results.',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    () => setState(() {
                      _showResult = false;
                      _quizStarted = false;
                      _score = 0;
                      _currentQuestion = 0;
                    }),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startQuiz() {
    // Dummy questions for demo
    _questions = List.generate(
      _numQuestions,
      (i) => {
        'question':
            'Sample question ${i + 1} for $_selectedSubject ($_selectedLevel)',
        'options': ['A', 'B', 'C', 'D'],
        'answer': 1,
      },
    );
    _quizStarted = true;
    _showResult = false;
    _score = 0;
    _currentQuestion = 0;
    _timer = 30;
    _isRunning = true;
    _startTimer();
    setState(() {});
  }

  void _answer(int selected) {
    if (!_quizStarted) return;
    if (selected == _questions[_currentQuestion]['answer']) {
      _score++;
    }
    if (_currentQuestion < _numQuestions - 1) {
      setState(() {
        _currentQuestion++;
        _timer = 30;
      });
    } else {
      setState(() {
        _showResult = true;
        _quizStarted = false;
        _isRunning = false;
      });
    }
  }

  void _startTimer() async {
    while (_isRunning && _timer > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isRunning) break;
      setState(() => _timer--);
      if (_timer == 0) {
        if (_currentQuestion < _numQuestions - 1) {
          setState(() {
            _currentQuestion++;
            _timer = 30;
          });
        } else {
          setState(() {
            _showResult = true;
            _quizStarted = false;
            _isRunning = false;
          });
        }
      }
    }
  }
}
