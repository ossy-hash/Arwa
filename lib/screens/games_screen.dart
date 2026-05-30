import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../models/alphabet_model.dart';
import '../utils/theme.dart';
import '../utils/data_loader.dart';
import '../widgets/topic_card.dart';
import '../widgets/animated_card.dart';
import '../widgets/balloon_widget.dart';
import '../widgets/memory_card.dart';
import '../widgets/star_display.dart';
import '../animations/slide_transition.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎮 Mini Games')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1,
          children: [
            TopicCard(
              title: 'Word Match',
              emoji: '🧩',
              color: AppTheme.purple,
              onTap: () => Navigator.push(context,
                  SlideTransitionPage(page: const MatchingGameScreen())),
            ),
            TopicCard(
              title: 'Balloon Pop',
              emoji: '🎈',
              color: AppTheme.skyBlue,
              onTap: () => Navigator.push(context,
                  SlideTransitionPage(page: const BalloonPopScreen())),
            ),
            TopicCard(
              title: 'Memory',
              emoji: '🧠',
              color: AppTheme.green,
              onTap: () => Navigator.push(context,
                  SlideTransitionPage(page: const MemoryGameScreen())),
            ),
            TopicCard(
              title: 'Puzzle',
              emoji: '🧩',
              color: Colors.orange,
              onTap: () => Navigator.push(context,
                  SlideTransitionPage(page: const PuzzleGameScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  List<MapEntry<String, String>>? _pairs;
  int _currentPairIndex = 0;
  String? _draggedWord;
  bool _showResult = false;
  bool _correct = false;
  int _score = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final vocab = await DataLoader.loadVocabulary();
    final items = [...vocab.animals.take(4), ...vocab.fruits.take(2)];
    items.shuffle();
    setState(() {
      _pairs = items.map((e) => MapEntry(e.emoji, e.word)).toList();
      _loaded = true;
    });
  }

  void _onDrop(String word) {
    if (_showResult) return;
    setState(() {
      _draggedWord = word;
      _showResult = true;
      _correct = word == _pairs![_currentPairIndex].value;
      if (_correct) _score++;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        if (_currentPairIndex < _pairs!.length - 1) {
          setState(() {
            _currentPairIndex++;
            _draggedWord = null;
            _showResult = false;
            _correct = false;
          });
        } else {
          _finishGame();
        }
      }
    });
  }

  void _finishGame() {
    context.read<AppStateProvider>().addCoins(_score * 10);
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 '),
            Text('Well Done!', style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You matched $_score/${_pairs!.length}!'),
            const SizedBox(height: 10),
            StarDisplay(starCount: _score, maxStars: _pairs!.length),
            const SizedBox(height: 8),
            Text('+${_score * 10} coins 🪙',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
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
      appBar: AppBar(title: const Text('🧩 Word Match')),
      body: _loaded
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Match the word to the emoji!',
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pair ${_currentPairIndex + 1}/${_pairs!.length}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.purple.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _pairs![_currentPairIndex].key,
                        style: const TextStyle(fontSize: 64),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_showResult)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _correct
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _correct ? Icons.check_circle : Icons.cancel,
                            color: _correct ? Colors.green : Colors.red,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _correct
                                ? 'Correct! ${_pairs![_currentPairIndex].value}'
                                : 'Wrong! It was ${_pairs![_currentPairIndex].value}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  _correct ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _pairs!.map((pair) {
                      final word = pair.value;
                      final isDragged = _draggedWord == word;
                      final isMatched = _pairs!
                          .indexOf(pair) < _currentPairIndex;
                      return Opacity(
                        opacity: isMatched ? 0.3 : 1.0,
                        child: DragTarget<String>(
                          onAcceptWithDetails: (details) =>
                              _onDrop(word),
                          builder: (context, candidates, rejected) {
                            return AnimatedCard(
                              color: isDragged
                                  ? AppTheme.lightYellow
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Text(
                                word,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDragged
                                      ? AppTheme.purple
                                      : Colors.grey.shade700,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '👆 Tap a word to match',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class BalloonPopScreen extends StatefulWidget {
  const BalloonPopScreen({super.key});

  @override
  State<BalloonPopScreen> createState() => _BalloonPopScreenState();
}

class _BalloonPopScreenState extends State<BalloonPopScreen> {
  List<AlphabetModel>? _alphabet;
  AlphabetModel? _target;
  List<String> _balloonLetters = [];
  int _poppedCorrect = 0;
  int _round = 0;
  final int _totalRounds = 5;
  bool _loaded = false;
  final _random = Random();
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DataLoader.loadAlphabet();
    setState(() {
      _alphabet = data;
      _loaded = true;
      _setupRound();
    });
  }

  void _setupRound() {
    if (_alphabet == null) return;
    _target = _alphabet![_random.nextInt(_alphabet!.length)];
    final letters = <String>{_target!.letter};
    while (letters.length < 4) {
      letters.add(
          _alphabet![_random.nextInt(_alphabet!.length)].letter);
    }
    setState(() {
      _balloonLetters = letters.toList()..shuffle();
    });
  }

  void _onBalloonPop(String letter) {
    if (_target == null) return;
    setState(() {
      if (letter == _target!.letter) {
        _poppedCorrect++;
        _score += 10;
      }
      _round++;
    });
    if (_round >= _totalRounds) {
      _finishGame();
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _setupRound();
      });
    }
  }

  void _finishGame() {
    context.read<AppStateProvider>().addCoins(_score);
    context.read<AppStateProvider>().addStars(_poppedCorrect);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🎈 '),
            Text('Pop-tastic!', style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You popped $_poppedCorrect/$_totalRounds correct!'),
            const SizedBox(height: 10),
            StarDisplay(starCount: _poppedCorrect,
                maxStars: _totalRounds),
            const SizedBox(height: 8),
            Text('+$_score coins 🪙',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
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
    final colors = [
      AppTheme.purple,
      AppTheme.skyBlue,
      AppTheme.softPink,
      AppTheme.yellow,
      AppTheme.green,
      Colors.orange,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('🎈 Balloon Pop')),
      body: _loaded
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Pop the balloon with:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _target?.emoji ?? '',
                          style: const TextStyle(fontSize: 48),
                        ),
                        Text(
                          _target?.word ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                      children: _balloonLetters.map((letter) {
                        return BalloonWidget(
                          letter: letter,
                          color: colors[_random.nextInt(colors.length)],
                          speed: 1.0 + _round * 0.1,
                          onPop: () => _onBalloonPop(letter),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<_MemoryCardData> _cards = [];
  int? _firstIndex;
  bool _isProcessing = false;
  int _matchesFound = 0;
  int _attempts = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final vocab = await DataLoader.loadVocabulary();
    final items = [
      ...vocab.animals.take(3),
      ...vocab.fruits.take(3),
    ];
    items.shuffle();

    final cards = <_MemoryCardData>[];
    for (int i = 0; i < items.length; i++) {
      cards.add(_MemoryCardData(
        id: i * 2,
        pairId: i,
        emoji: items[i].emoji,
        word: items[i].word,
      ));
      cards.add(_MemoryCardData(
        id: i * 2 + 1,
        pairId: i,
        emoji: items[i].emoji,
        word: items[i].word,
      ));
    }
    cards.shuffle();

    setState(() {
      _cards = cards;
      _loaded = true;
    });
  }

  void _onCardTap(int index) {
    if (_isProcessing) return;
    if (_cards[index].isMatched) return;
    if (_cards[index].isFlipped) return;

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstIndex == null) {
      _firstIndex = index;
      return;
    }

    _attempts++;
    _isProcessing = true;

    final first = _cards[_firstIndex!];
    final second = _cards[index];

    if (first.pairId == second.pairId) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          first.isMatched = true;
          second.isMatched = true;
          _matchesFound++;
          _firstIndex = null;
          _isProcessing = false;
        });
        if (_matchesFound == _cards.length ~/ 2) {
          _finishGame();
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          first.isFlipped = false;
          second.isFlipped = false;
          _firstIndex = null;
          _isProcessing = false;
        });
      });
    }
  }

  void _finishGame() {
    final score = max(0, 10 - _attempts);
    context.read<AppStateProvider>().addCoins(score * 5);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🧠 '),
            Text('Memory Master!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Found all pairs in $_attempts attempts!'),
            const SizedBox(height: 10),
            StarDisplay(
                starCount: _attempts <= 6
                    ? 3
                    : _attempts <= 10
                        ? 2
                        : 1),
            const SizedBox(height: 8),
            Text('+${score * 5} coins 🪙',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
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
      appBar: AppBar(title: const Text('🧠 Memory Match')),
      body: _loaded
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Matches: $_matchesFound/${_cards.length ~/ 2}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Attempts: $_attempts',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.purple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                      children: List.generate(_cards.length, (index) {
                        final card = _cards[index];
                        return MemoryCard(
                          emoji: card.emoji,
                          word: card.word,
                          isFlipped: card.isFlipped,
                          isMatched: card.isMatched,
                          color: AppTheme.purple,
                          onTap: () => _onCardTap(index),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _MemoryCardData {
  final int id;
  final int pairId;
  final String emoji;
  final String word;
  bool isFlipped = false;
  bool isMatched = false;

  _MemoryCardData({
    required this.id,
    required this.pairId,
    required this.emoji,
    required this.word,
  });
}

class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  String _currentWord = '';
  List<String> _scrambledLetters = [];
  List<String> _userWord = [];
  int _round = 0;
  int _score = 0;

  final List<String> _words = [
    'CAT', 'DOG', 'SUN', 'BALL', 'FISH', 'BIRD',
    'STAR', 'MOON', 'TREE', 'BOOK', 'HOME', 'RAIN'
  ];

  @override
  void initState() {
    super.initState();
    _setupPuzzle();
  }

  void _setupPuzzle() {
    final words = List<String>.from(_words)..shuffle();
    setState(() {
      _currentWord = words[_round % words.length];
      _scrambledLetters = _currentWord.split('')..shuffle();
      _userWord = [];
    });
  }

  void _addLetter(String letter) {
    if (_userWord.length < _currentWord.length) {
      setState(() {
        _userWord.add(letter);
        _scrambledLetters.remove(letter);
      });
      if (_userWord.length == _currentWord.length) {
        _checkAnswer();
      }
    }
  }

  void _removeLastLetter() {
    if (_userWord.isNotEmpty) {
      setState(() {
        final letter = _userWord.removeLast();
        _scrambledLetters.add(letter);
      });
    }
  }

  void _checkAnswer() {
    final userWord = _userWord.join();
    final correct = userWord == _currentWord;
    if (correct) _score += 10;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Text(correct ? '✅ ' : '❌ '),
            Text(
              correct ? 'Correct!' : 'Wrong!',
              style: TextStyle(
                color: correct ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        content: Text('The word was $_currentWord'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _round++;
                if (_round >= 5) {
                  _finishGame();
                } else {
                  _setupPuzzle();
                }
              });
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  void _finishGame() {
    context.read<AppStateProvider>().addCoins(_score);
    context.read<AppStateProvider>().addStars(_score ~/ 10);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🧩 '),
            Text('Puzzle Master!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: $_score points!'),
            const SizedBox(height: 8),
            Text('+$_score coins 🪙',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
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
      appBar: AppBar(title: const Text('🧩 Word Puzzle')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Round ${_round + 1}/5',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Arrange the letters to spell the word!',
              style: TextStyle(
                  fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.lightYellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _currentWord.length,
                  (i) => Container(
                    width: 50,
                    height: 55,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.purple.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        i < _userWord.length ? _userWord[i] : '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.purple,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_userWord.isNotEmpty)
              TextButton.icon(
                onPressed: _removeLastLetter,
                icon: const Icon(Icons.undo),
                label: const Text('Undo'),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: _scrambledLetters.map((letter) {
                  return GestureDetector(
                    onTap: () => _addLetter(letter),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.purple, AppTheme.skyBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.purple.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
