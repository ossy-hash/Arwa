import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../models/number_model.dart';
import '../models/shape_model.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../utils/data_loader.dart';
import '../widgets/topic_card.dart';
import '../widgets/animated_card.dart';
import '../widgets/number_card.dart';
import '../widgets/shape_widget.dart';
import '../widgets/progress_bar.dart';
import '../widgets/star_display.dart';
import '../animations/slide_transition.dart';

class MathScreen extends StatelessWidget {
  const MathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔢 Math Learning')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: AppConstants.mathTopics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final topic = AppConstants.mathTopics[index];
            final emoji = AppConstants.mathEmojis[index];
            final color = AppTheme.getTopicColor(topic);
            final lessonId = 'math_${topic.toLowerCase().replaceAll(' ', '_')}';
            final completed =
                context.watch<AppStateProvider>().isLessonCompleted(lessonId);

            return TopicCard(
              title: topic,
              emoji: emoji,
              color: color,
              completed: completed,
              onTap: () => _navigateToTopic(context, topic),
            );
          },
        ),
      ),
    );
  }

  void _navigateToTopic(BuildContext context, String topic) {
    switch (topic) {
      case 'Counting':
        Navigator.push(
            context, SlideTransitionPage(page: const CountingScreen()));
        break;
      case 'Addition':
        Navigator.push(
            context, SlideTransitionPage(page: const AdditionScreen()));
        break;
      case 'Subtraction':
        Navigator.push(
            context, SlideTransitionPage(page: const SubtractionScreen()));
        break;
      case 'Shapes':
        Navigator.push(
            context, SlideTransitionPage(page: const ShapesScreen()));
        break;
      case 'Number Match':
        Navigator.push(
            context, SlideTransitionPage(page: const NumberMatchScreen()));
        break;
      case 'Multiplication':
        Navigator.push(context,
            SlideTransitionPage(page: const MultiplicationScreen()));
        break;
      case 'Division':
        Navigator.push(context,
            SlideTransitionPage(page: const DivisionScreen()));
        break;
      case 'Skip Counting':
        Navigator.push(context,
            SlideTransitionPage(page: const SkipCountingScreen()));
        break;
      case 'Comparison':
        Navigator.push(context,
            SlideTransitionPage(page: const ComparisonScreen()));
        break;
      case 'Clock':
        Navigator.push(context,
            SlideTransitionPage(page: const ClockScreen()));
        break;
      case 'Measurement':
        Navigator.push(context,
            SlideTransitionPage(page: const MeasurementScreen()));
        break;
      case 'Count & Tap':
        Navigator.push(context,
            SlideTransitionPage(page: const CountTapScreen()));
        break;
    }
  }
}

class CountingScreen extends StatefulWidget {
  const CountingScreen({super.key});

  @override
  State<CountingScreen> createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen> {
  List<NumberModel>? _numbers;
  int _currentIndex = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DataLoader.loadNumbers();
    setState(() {
      _numbers = data;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔢 Counting')),
      body: _loaded
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: NumberCard(
                      number: _numbers![_currentIndex].number,
                      word: _numbers![_currentIndex].word,
                      emoji: _numbers![_currentIndex].emoji,
                      count: _numbers![_currentIndex].count,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentIndex > 0)
                        ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => _currentIndex--),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                        )
                      else
                        const SizedBox(width: 90),
                      if (_currentIndex < _numbers!.length - 1)
                        ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => _currentIndex++),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Next'),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<AppStateProvider>()
                                .completeLesson('math_counting');
                            context
                                .read<AppStateProvider>()
                                .addStars(5);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Done'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.green,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class AdditionScreen extends StatefulWidget {
  const AdditionScreen({super.key});

  @override
  State<AdditionScreen> createState() => _AdditionScreenState();
}

class _AdditionScreenState extends State<AdditionScreen> {
  final _random = Random();
  int _a = 1, _b = 1;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _correct = false;
  int _score = 0;
  int _questionCount = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    setState(() {
      _a = _random.nextInt(9) + 1;
      _b = _random.nextInt(9) + 1;
      _selectedAnswer = null;
      _showResult = false;
      _correct = false;
    });
  }

  void _checkAnswer(int answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _correct = answer == _correctAnswer;
      if (_correct) _score++;
      _questionCount++;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_questionCount >= 5) {
          _finishLesson();
        } else {
          _generateQuestion();
        }
      }
    });
  }

  void _finishLesson() {
    context.read<AppStateProvider>().completeLesson('math_addition');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 '),
            Text('Great Job!', style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You got $_score/5 correct!',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            StarDisplay(starCount: _score, maxStars: 5),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  int get _correctAnswer => _a + _b;

  List<int> get _options {
    final options = {_correctAnswer, _correctAnswer + 1, _correctAnswer - 1}
        .where((n) => n > 0)
        .toList();
    while (options.length < 3) {
      options.add(_correctAnswer + _random.nextInt(5) + 2);
    }
    return options..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final options = _options;

    return Scaffold(
      appBar: AppBar(title: const Text('➕ Addition')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ProgressRow(
              label: 'Progress',
              progress: _questionCount / 5,
              progressText: '$_questionCount/5',
            ),
            const SizedBox(height: 30),
            AnimatedCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_a',
                    style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.purple),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('+',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                  ),
                  Text(
                    '$_b',
                    style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.skyBlue),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('=',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ),
                  const Text('?',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ...options.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _showResult ? null : () => _checkAnswer(opt),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showResult
                            ? (opt == _correctAnswer
                                ? AppTheme.green
                                : (opt == _selectedAnswer
                                    ? AppTheme.red
                                    : Colors.grey.shade200))
                            : Colors.white,
                        foregroundColor: _showResult
                            ? Colors.white
                            : AppTheme.darkPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: _showResult
                                ? Colors.transparent
                                : AppTheme.purple.withValues(alpha: 0.3),
                          ),
                        ),
                        elevation: _showResult ? 0 : 2,
                      ),
                      child: Text(
                        '$opt',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SubtractionScreen extends StatefulWidget {
  const SubtractionScreen({super.key});

  @override
  State<SubtractionScreen> createState() => _SubtractionScreenState();
}

class _SubtractionScreenState extends State<SubtractionScreen> {
  final _random = Random();
  int _a = 5, _b = 3;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _correct = false;
  int _score = 0;
  int _questionCount = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    setState(() {
      _a = _random.nextInt(9) + 2;
      _b = _random.nextInt(_a);
      _selectedAnswer = null;
      _showResult = false;
      _correct = false;
    });
  }

  void _checkAnswer(int answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _correct = answer == _correctAnswer;
      if (_correct) _score++;
      _questionCount++;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_questionCount >= 5) {
          _finishLesson();
        } else {
          _generateQuestion();
        }
      }
    });
  }

  void _finishLesson() {
    context.read<AppStateProvider>().completeLesson('math_subtraction');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 '),
            Text('Great Job!', style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You got $_score/5 correct!',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            StarDisplay(starCount: _score),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  int get _correctAnswer => _a - _b;

  List<int> get _options {
    final options = {_correctAnswer, _correctAnswer + 1, _correctAnswer - 1}
        .where((n) => n >= 0)
        .toList();
    while (options.length < 3) {
      options.add(_correctAnswer + _random.nextInt(5) + 2);
    }
    return options..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final options = _options;

    return Scaffold(
      appBar: AppBar(title: const Text('➖ Subtraction')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ProgressRow(
              label: 'Progress',
              progress: _questionCount / 5,
              progressText: '$_questionCount/5',
            ),
            const SizedBox(height: 30),
            AnimatedCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$_a',
                      style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.purple)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('-',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                  ),
                  Text('$_b',
                      style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.skyBlue)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('=',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ),
                  const Text('?',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ...options.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          _showResult ? null : () => _checkAnswer(opt),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showResult
                            ? (opt == _correctAnswer
                                ? AppTheme.green
                                : (opt == _selectedAnswer
                                    ? AppTheme.red
                                    : Colors.grey.shade200))
                            : Colors.white,
                        foregroundColor: _showResult
                            ? Colors.white
                            : AppTheme.darkPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: _showResult
                                ? Colors.transparent
                                : AppTheme.purple.withValues(alpha: 0.3),
                          ),
                        ),
                        elevation: _showResult ? 0 : 2,
                      ),
                      child: Text('$opt',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ShapesScreen extends StatefulWidget {
  const ShapesScreen({super.key});

  @override
  State<ShapesScreen> createState() => _ShapesScreenState();
}

class _ShapesScreenState extends State<ShapesScreen> {
  List<ShapeModel>? _shapes;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DataLoader.loadShapes();
    setState(() {
      _shapes = data;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔷 Shapes')),
      body: _loaded
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.9,
              ),
              itemCount: _shapes!.length,
              itemBuilder: (context, index) {
                final shape = _shapes![index];
                return ShapeDisplay(
                  name: shape.name,
                  emoji: shape.emoji,
                  sides: shape.sides,
                  description: shape.description,
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class NumberMatchScreen extends StatefulWidget {
  const NumberMatchScreen({super.key});

  @override
  State<NumberMatchScreen> createState() => _NumberMatchScreenState();
}

class _NumberMatchScreenState extends State<NumberMatchScreen> {
  List<NumberModel>? _numbers;
  int _currentIndex = 0;
  int? _selectedNumber;
  bool _showResult = false;
  bool _loaded = false;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DataLoader.loadNumbers();
    setState(() {
      _numbers = data;
      _loaded = true;
    });
  }

  void _checkAnswer(int num) {
    setState(() {
      _selectedNumber = num;
      _showResult = true;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        if (_currentIndex < _numbers!.length - 1) {
          setState(() {
            _currentIndex++;
            _selectedNumber = null;
            _showResult = false;
          });
        } else {
          context.read<AppStateProvider>().completeLesson('math_number_match');
          context.read<AppStateProvider>().addStars(5);
          Navigator.pop(context);
        }
      }
    });
  }

  List<int> get _options {
    final correct = _numbers![_currentIndex].number;
    final options = {correct};
    while (options.length < 4) {
      options.add(_random.nextInt(10) + 1);
    }
    return options.toList()..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎯 Number Match')),
      body: _loaded
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Count the items and pick the right number!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: AnimatedCard(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _numbers![_currentIndex].emoji,
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _numbers![_currentIndex].count,
                              style: const TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _options.map((opt) {
                      final isCorrect =
                          opt == _numbers![_currentIndex].number;
                      return SizedBox(
                        width: 70,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: _showResult
                              ? null
                              : () => _checkAnswer(opt),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _showResult
                                ? (isCorrect
                                    ? AppTheme.green
                                    : (opt == _selectedNumber
                                        ? AppTheme.red
                                        : Colors.grey.shade200))
                                : Colors.white,
                            foregroundColor: _showResult
                                ? Colors.white
                                : AppTheme.darkPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: _showResult
                                    ? Colors.transparent
                                    : AppTheme.skyBlue
                                        .withValues(alpha: 0.3),
                              ),
                            ),
                            elevation: _showResult ? 0 : 2,
                          ),
                          child: Text('$opt',
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class MultiplicationScreen extends StatefulWidget {
  const MultiplicationScreen({super.key});

  @override
  State<MultiplicationScreen> createState() =>
      _MultiplicationScreenState();
}

class _MultiplicationScreenState extends State<MultiplicationScreen> {
  final _random = Random();
  int _a = 2, _b = 2;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _correct = false;
  int _score = 0;
  int _questionCount = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    setState(() {
      _a = _random.nextInt(9) + 1;
      _b = _random.nextInt(9) + 1;
      _selectedAnswer = null;
      _showResult = false;
      _correct = false;
    });
  }

  void _checkAnswer(int answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _correct = answer == _correctAnswer;
      if (_correct) _score++;
      _questionCount++;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_questionCount >= 5) {
          _finishLesson();
        } else {
          _generateQuestion();
        }
      }
    });
  }

  void _finishLesson() {
    context
        .read<AppStateProvider>()
        .completeLesson('math_multiplication');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 '),
            Text('Great Job!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You got $_score/5 correct!',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            StarDisplay(starCount: _score, maxStars: 5),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  int get _correctAnswer => _a * _b;

  List<int> get _options {
    final options = {_correctAnswer, _correctAnswer + 1, _correctAnswer - 1}
        .where((n) => n > 0)
        .toList();
    while (options.length < 3) {
      options.add(_correctAnswer + _random.nextInt(5) + 2);
    }
    return options..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final options = _options;
    final color = AppTheme.getTopicColor('Multiplication');

    return Scaffold(
      appBar: AppBar(title: const Text('✖️ Multiplication')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ProgressRow(
              label: 'Progress',
              progress: _questionCount / 5,
              progressText: '$_questionCount/5',
            ),
            const SizedBox(height: 30),
            AnimatedCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$_a',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('✖️',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                  ),
                  Text('$_b',
                      style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.skyBlue)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('=',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ),
                  const Text('?',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$_a groups of $_b',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            ...options.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _showResult
                          ? null
                          : () => _checkAnswer(opt),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showResult
                            ? (opt == _correctAnswer
                                ? AppTheme.green
                                : (opt == _selectedAnswer
                                    ? AppTheme.red
                                    : Colors.grey.shade200))
                            : Colors.white,
                        foregroundColor: _showResult
                            ? Colors.white
                            : AppTheme.darkPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          side: BorderSide(
                            color: _showResult
                                ? Colors.transparent
                                : color.withValues(alpha: 0.3),
                          ),
                        ),
                        elevation: _showResult ? 0 : 2,
                      ),
                      child: Text('$opt',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class DivisionScreen extends StatefulWidget {
  const DivisionScreen({super.key});

  @override
  State<DivisionScreen> createState() => _DivisionScreenState();
}

class _DivisionScreenState extends State<DivisionScreen> {
  final _random = Random();
  int _a = 4, _b = 2;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _correct = false;
  int _score = 0;
  int _questionCount = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    _b = _random.nextInt(5) + 2;
    final product = _random.nextInt(5) + 1;
    _a = _b * product;
    setState(() {
      _selectedAnswer = null;
      _showResult = false;
      _correct = false;
    });
  }

  void _checkAnswer(int answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _correct = answer == _correctAnswer;
      if (_correct) _score++;
      _questionCount++;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_questionCount >= 5) {
          _finishLesson();
        } else {
          _generateQuestion();
        }
      }
    });
  }

  void _finishLesson() {
    context
        .read<AppStateProvider>()
        .completeLesson('math_division');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 '),
            Text('Great Job!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You got $_score/5 correct!',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            StarDisplay(starCount: _score, maxStars: 5),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  int get _correctAnswer => _a ~/ _b;

  List<int> get _options {
    final options = {_correctAnswer, _correctAnswer + 1, _correctAnswer - 1}
        .where((n) => n > 0)
        .toList();
    while (options.length < 3) {
      options.add(_correctAnswer + _random.nextInt(5) + 2);
    }
    return options..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final options = _options;
    final color = AppTheme.getTopicColor('Division');

    return Scaffold(
      appBar: AppBar(title: const Text('➗ Division')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ProgressRow(
              label: 'Progress',
              progress: _questionCount / 5,
              progressText: '$_questionCount/5',
            ),
            const SizedBox(height: 30),
            AnimatedCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$_a',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('➗',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                  ),
                  Text('$_b',
                      style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.skyBlue)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('=',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ),
                  const Text('?',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Split $_a into $_b equal groups',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            ...options.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _showResult
                          ? null
                          : () => _checkAnswer(opt),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showResult
                            ? (opt == _correctAnswer
                                ? AppTheme.green
                                : (opt == _selectedAnswer
                                    ? AppTheme.red
                                    : Colors.grey.shade200))
                            : Colors.white,
                        foregroundColor: _showResult
                            ? Colors.white
                            : AppTheme.darkPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          side: BorderSide(
                            color: _showResult
                                ? Colors.transparent
                                : color.withValues(alpha: 0.3),
                          ),
                        ),
                        elevation: _showResult ? 0 : 2,
                      ),
                      child: Text('$opt',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class SkipCountingScreen extends StatefulWidget {
  const SkipCountingScreen({super.key});

  @override
  State<SkipCountingScreen> createState() =>
      _SkipCountingScreenState();
}

class _SkipCountingScreenState
    extends State<SkipCountingScreen> {
  final _random = Random();
  int _step = 2;
  int _start = 2;
  int _missingIndex = 0;
  final List<int> _sequence = [];
  int? _selectedAnswer;
  bool _showResult = false;
  bool _correct = false;
  int _score = 0;
  int _questionCount = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final steps = [2, 5, 10];
    _step = steps[_random.nextInt(steps.length)];
    _start = _step;
    if (_start > 10) _start = _step;
    _sequence.clear();
    for (int i = 0; i < 5; i++) {
      _sequence.add(_start + i * _step);
    }
    _missingIndex = 1 + _random.nextInt(3);
    setState(() {
      _selectedAnswer = null;
      _showResult = false;
      _correct = false;
    });
  }

  void _checkAnswer(int answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _correct = answer == _sequence[_missingIndex];
      if (_correct) _score++;
      _questionCount++;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_questionCount >= 5) {
          _finishLesson();
        } else {
          _generateQuestion();
        }
      }
    });
  }

  void _finishLesson() {
    context
        .read<AppStateProvider>()
        .completeLesson('math_skip_counting');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 '),
            Text('Great Job!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You got $_score/5 correct!',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            StarDisplay(starCount: _score, maxStars: 5),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      _sequence[_missingIndex],
      _sequence[_missingIndex] + _step,
      _sequence[_missingIndex] - _step,
    ]..shuffle();

    return Scaffold(
      appBar: AppBar(title: const Text('2️⃣ Skip Counting')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ProgressRow(
              label: 'Progress',
              progress: _questionCount / 5,
              progressText: '$_questionCount/5',
            ),
            const SizedBox(height: 16),
            Text(
              'Count by $_step! What is missing?',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.purple),
            ),
            const SizedBox(height: 24),
            AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: List.generate(
                    _sequence.length,
                    (i) {
                      final show = i == _missingIndex;
                      return Container(
                        width: 50,
                        height: 55,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 3),
                        decoration: BoxDecoration(
                          color: show
                              ? AppTheme.lightYellow
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                            color: show
                                ? AppTheme
                                    .getTopicColor('Skip Counting')
                                    .withValues(alpha: 0.5)
                                : AppTheme.purple
                                    .withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: show
                              ? const Text('?',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Colors.orange))
                              : Text(
                                  '${_sequence[i]}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: AppTheme.purple,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ...options.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _showResult
                          ? null
                          : () => _checkAnswer(opt),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showResult
                            ? (opt == _sequence[_missingIndex]
                                ? AppTheme.green
                                : (opt == _selectedAnswer
                                    ? AppTheme.red
                                    : Colors.grey.shade200))
                            : Colors.white,
                        foregroundColor: _showResult
                            ? Colors.white
                            : AppTheme.darkPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          side: BorderSide(
                            color: _showResult
                                ? Colors.transparent
                                : AppTheme.getTopicColor(
                                        'Skip Counting')
                                    .withValues(alpha: 0.3),
                          ),
                        ),
                        elevation: _showResult ? 0 : 2,
                      ),
                      child: Text('$opt',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() =>
      _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final _random = Random();
  int _a = 5, _b = 3;
  String? _selectedSymbol;
  bool _showResult = false;
  bool _correct = false;
  int _score = 0;
  int _questionCount = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    _a = _random.nextInt(20) + 1;
    _b = _random.nextInt(20) + 1;
    setState(() {
      _selectedSymbol = null;
      _showResult = false;
      _correct = false;
    });
  }

  String get _correctSymbol {
    if (_a > _b) return '>';
    if (_a < _b) return '<';
    return '=';
  }

  void _checkAnswer(String symbol) {
    setState(() {
      _selectedSymbol = symbol;
      _showResult = true;
      _correct = symbol == _correctSymbol;
      if (_correct) _score++;
      _questionCount++;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_questionCount >= 5) {
          _finishLesson();
        } else {
          _generateQuestion();
        }
      }
    });
  }

  void _finishLesson() {
    context
        .read<AppStateProvider>()
        .completeLesson('math_comparison');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 '),
            Text('Great Job!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You got $_score/5 correct!',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            StarDisplay(starCount: _score, maxStars: 5),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚖️ Comparison')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ProgressRow(
              label: 'Progress',
              progress: _questionCount / 5,
              progressText: '$_questionCount/5',
            ),
            const SizedBox(height: 24),
            Text(
              'Pick the right symbol!',
              style: TextStyle(
                  fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            AnimatedCard(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('$_a',
                          style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.purple)),
                      Text(
                        _getEmojiCount(_a),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12),
                    child: Text(
                      _showResult
                          ? _correctSymbol
                          : '🐊',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _showResult
                            ? AppTheme.green
                            : const Color(0xFFFF9800),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text('$_b',
                          style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.skyBlue)),
                      Text(
                        _getEmojiCount(_b),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'The 🐊 eats the bigger number!',
              style: TextStyle(
                  fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: ['>', '<', '='].map((symbol) {
                return SizedBox(
                  width: 90,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _showResult
                        ? null
                        : () =>
                            _checkAnswer(symbol),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showResult
                          ? (symbol == _correctSymbol
                              ? AppTheme.green
                              : (symbol ==
                                      _selectedSymbol
                                  ? AppTheme.red
                                  : Colors
                                      .grey.shade200))
                          : Colors.white,
                      foregroundColor: _showResult
                          ? Colors.white
                          : AppTheme.darkPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                        side: BorderSide(
                          color: _showResult
                              ? Colors.transparent
                              : AppTheme.getTopicColor(
                                      'Comparison')
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      elevation: _showResult ? 0 : 2,
                    ),
                    child: Text(
                      symbol,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmojiCount(int n) {
    return List.filled(n.clamp(0, 10), '⬛').join('');
  }
}

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  final _random = Random();
  int _hour = 3, _minute = 0;
  int _correctAnswer = 3;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _correct = false;
  int _score = 0;
  int _questionCount = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    _hour = _random.nextInt(12) + 1;
    _minute = _random.nextBool() ? 0 : 30;
    _correctAnswer = _hour;
    setState(() {
      _selectedAnswer = null;
      _showResult = false;
      _correct = false;
    });
  }

  void _checkAnswer(int answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _correct = answer == _correctAnswer;
      if (_correct) _score++;
      _questionCount++;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_questionCount >= 5) {
          _finishLesson();
        } else {
          _generateQuestion();
        }
      }
    });
  }

  void _finishLesson() {
    context
        .read<AppStateProvider>()
        .completeLesson('math_clock');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 '),
            Text('Great Job!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You got $_score/5 correct!',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            StarDisplay(starCount: _score, maxStars: 5),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      _hour,
      _hour == 12 ? 1 : _hour + 1,
      _hour == 1 ? 12 : _hour - 1,
    ]..shuffle();

    final hourAngle = (_hour % 12) * 30 + _minute * 0.5;
    final minuteAngle = _minute * 6.0;

    return Scaffold(
      appBar: AppBar(title: const Text('🕐 Clock')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ProgressRow(
              label: 'Progress',
              progress: _questionCount / 5,
              progressText: '$_questionCount/5',
            ),
            const SizedBox(height: 20),
            Text(
              'What time is it?',
              style: TextStyle(
                  fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            AnimatedCard(
              child: SizedBox(
                width: 220,
                height: 220,
                child: CustomPaint(
                  painter: _ClockPainter(
                    hourAngle: hourAngle,
                    minuteAngle: minuteAngle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _minute == 0
                  ? '$_hour:00'
                  : '$_hour:30',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.purple),
            ),
            const SizedBox(height: 20),
            ...options.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _showResult
                          ? null
                          : () => _checkAnswer(opt),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showResult
                            ? (opt == _correctAnswer
                                ? AppTheme.green
                                : (opt == _selectedAnswer
                                    ? AppTheme.red
                                    : Colors.grey.shade200))
                            : Colors.white,
                        foregroundColor: _showResult
                            ? Colors.white
                            : AppTheme.darkPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          side: BorderSide(
                            color: _showResult
                                ? Colors.transparent
                                : AppTheme.getTopicColor('Clock')
                                    .withValues(alpha: 0.3),
                          ),
                        ),
                        elevation: _showResult ? 0 : 2,
                      ),
                      child: Text(
                        '$opt:00',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final double hourAngle;
  final double minuteAngle;

  _ClockPainter(
      {required this.hourAngle, required this.minuteAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius, bgPaint);

    final borderPaint = Paint()
      ..color = AppTheme.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, borderPaint);

    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30 - 90) * pi / 180;
      final isMain = i % 3 == 0;
      final outer = radius - (isMain ? 12 : 8);
      final inner = radius - (isMain ? 20 : 14);
      canvas.drawLine(
        Offset(center.dx + cos(angle) * inner,
            center.dy + sin(angle) * inner),
        Offset(center.dx + cos(angle) * outer,
            center.dy + sin(angle) * outer),
        Paint()
          ..color = AppTheme.purple
          ..strokeWidth = isMain ? 3 : 1.5,
      );
    }

    final hourRad = (hourAngle - 90) * pi / 180;
    canvas.drawLine(
      center,
      Offset(center.dx + cos(hourRad) * radius * 0.5,
          center.dy + sin(hourRad) * radius * 0.5),
      Paint()
        ..color = AppTheme.purple
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );

    final minRad = (minuteAngle - 90) * pi / 180;
    canvas.drawLine(
      center,
      Offset(center.dx + cos(minRad) * radius * 0.7,
          center.dy + sin(minRad) * radius * 0.7),
      Paint()
        ..color = AppTheme.skyBlue
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(center, 4, Paint()..color = AppTheme.darkPurple);
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) =>
      oldDelegate.hourAngle != hourAngle ||
      oldDelegate.minuteAngle != minuteAngle;
}

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() =>
      _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  final _random = Random();
  int _questionType = 0;
  String _question = '';
  int _correctAnswer = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _correct = false;
  int _score = 0;
  int _questionCount = 0;

  final _questions = [
    {'q': 'Which is TALLER?', 'a': 0, 'o1': '🌳 Tree', 'o2': '🌷 Flower'},
    {'q': 'Which is HEAVIER?', 'a': 0, 'o1': '🐘 Elephant', 'o2': '🐭 Mouse'},
    {'q': 'Which is BIGGER?', 'a': 0, 'o1': '🚗 Car', 'o2': '🚲 Bike'},
    {'q': 'Which is LONGER?', 'a': 0, 'o1': '🐍 Snake', 'o2': '🐛 Caterpillar'},
    {'q': 'Which is SMALLER?', 'a': 1, 'o1': '🏠 House', 'o2': '🐜 Ant'},
    {'q': 'Which is LIGHTER?', 'a': 1, 'o1': '🪨 Rock', 'o2': '🪶 Feather'},
    {'q': 'Which is SHORTER?', 'a': 1, 'o1': '🏢 Building', 'o2': '👶 Baby'},
    {'q': 'Which is FASTER?', 'a': 0, 'o1': '🚀 Rocket', 'o2': '🐢 Turtle'},
    {'q': 'Which is HOTTER?', 'a': 0, 'o1': '☀️ Sun', 'o2': '🧊 Ice'},
    {'q': 'Which is SOFTER?', 'a': 1, 'o1': '🪨 Rock', 'o2': '🧸 Teddy'},
  ];

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final idx = _random.nextInt(_questions.length);
    final q = _questions[idx];
    setState(() {
      _question = q['q'] as String;
      _correctAnswer = q['a'] as int;
      _questionType = idx;
      _selectedAnswer = null;
      _showResult = false;
      _correct = false;
    });
  }

  void _checkAnswer(int answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _correct = answer == _correctAnswer;
      if (_correct) _score++;
      _questionCount++;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_questionCount >= 5) {
          _finishLesson();
        } else {
          _generateQuestion();
        }
      }
    });
  }

  void _finishLesson() {
    context
        .read<AppStateProvider>()
        .completeLesson('math_measurement');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 '),
            Text('Great Job!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You got $_score/5 correct!',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            StarDisplay(starCount: _score, maxStars: 5),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_questionType];

    return Scaffold(
      appBar: AppBar(title: const Text('📏 Measurement')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ProgressRow(
              label: 'Progress',
              progress: _questionCount / 5,
              progressText: '$_questionCount/5',
            ),
            const SizedBox(height: 24),
            Text(
              _question,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.purple),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                _buildChoice(0, q['o1'] as String),
                const Text('vs',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                _buildChoice(1, q['o2'] as String),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoice(int index, String text) {
    final isCorrect = index == _correctAnswer;
    return GestureDetector(
      onTap:
          _showResult ? null : () => _checkAnswer(index),
      child: AnimatedCard(
        color: _showResult
            ? (isCorrect
                ? AppTheme.green
                : (index == _selectedAnswer
                    ? AppTheme.red
                    : Colors.white))
            : Colors.white,
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Text(
              text.split(' ')[0],
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 8),
            Text(
              text.substring(text.indexOf(' ') + 1),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _showResult && !isCorrect &&
                        index == _selectedAnswer
                    ? Colors.white
                    : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountTapScreen extends StatefulWidget {
  const CountTapScreen({super.key});

  @override
  State<CountTapScreen> createState() => _CountTapScreenState();
}

class _CountTapScreenState extends State<CountTapScreen> {
  final _random = Random();
  int _targetCount = 3;
  int _tappedCount = 0;
  List<int> _tappedIndices = [];
  List<String> _emojis = [];
  bool _isCountingMode = true;
  bool _showResult = false;
  bool _correct = false;
  int _score = 0;
  int _round = 0;
  final int _totalRounds = 5;

  final _pool = ['🍎', '🐶', '⭐', '🌙', '🌸', '🚀', '🎈', '🐱', '🍕', '🌈'];

  @override
  void initState() {
    super.initState();
    _setupRound();
  }

  void _setupRound() {
    _targetCount = _random.nextInt(8) + 2;
    _tappedIndices = [];
    _tappedCount = 0;
    _showResult = false;
    _correct = false;
    _isCountingMode = _random.nextBool();

    setState(() {
      _emojis = List.generate(
        12,
        (_) => _pool[_random.nextInt(_pool.length)],
      );
    });
  }

  void _onTapEmoji(int index) {
    if (_showResult) return;
    if (_tappedIndices.contains(index)) return;
    setState(() {
      _tappedIndices.add(index);
      _tappedCount++;
    });
  }

  void _submitCount() {
    setState(() {
      _showResult = true;
      _correct = _tappedCount == _targetCount;
      if (_correct) _score++;
      _round++;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        if (_round >= _totalRounds) {
          _finishGame();
        } else {
          _setupRound();
        }
      }
    });
  }

  void _submitReverse() {
    setState(() {
      _showResult = true;
      _correct = _tappedCount == _targetCount;
      if (_correct) _score++;
      _round++;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        if (_round >= _totalRounds) {
          _finishGame();
        } else {
          _setupRound();
        }
      }
    });
  }

  void _finishGame() {
    context
        .read<AppStateProvider>()
        .completeLesson('math_count_tap');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('👆 '),
            Text('Tap Master!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'You got $_score/$_totalRounds correct!'),
            const SizedBox(height: 10),
            StarDisplay(
                starCount: _score,
                maxStars: _totalRounds),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👆 Count & Tap')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Round ${_round + 1}/$_totalRounds',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Score: $_score',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_isCountingMode)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Text('🔢 ',
                        style: TextStyle(fontSize: 24)),
                    Text(
                      'Tap $_targetCount items!',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.purple),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightYellow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Text('👆 ',
                        style: TextStyle(fontSize: 24)),
                    Text(
                      'Tap $_targetCount times!',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              _isCountingMode
                  ? 'Tapped: $_tappedCount/$_targetCount'
                  : 'Tapped: $_tappedCount times',
              style: TextStyle(
                  fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _emojis.length,
                itemBuilder: (context, index) {
                  final tapped =
                      _tappedIndices.contains(index);
                  return GestureDetector(
                    onTap: () => _onTapEmoji(index),
                    child: AnimatedCard(
                      color: tapped
                          ? AppTheme.lightYellow
                          : Colors.white,
                      padding: const EdgeInsets.all(4),
                      child: Center(
                        child: Text(
                          _emojis[index],
                          style: TextStyle(
                            fontSize: tapped ? 32 : 28,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed:
                    _showResult ? null : _isCountingMode ? _submitCount : _submitReverse,
                icon: const Icon(Icons.check),
                label: Text(
                    _isCountingMode ? 'Submit Count' : 'Done Tapping'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
