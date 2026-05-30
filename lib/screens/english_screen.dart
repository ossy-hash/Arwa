import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../models/alphabet_model.dart';
import '../models/vocabulary_model.dart';
import '../models/phonics_model.dart';
import '../models/sight_word_model.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../utils/data_loader.dart';
import '../widgets/topic_card.dart';
import '../widgets/animated_card.dart';
import '../widgets/letter_card.dart';
import '../widgets/tracing_pad.dart';
import '../widgets/star_display.dart';
import '../animations/slide_transition.dart';

class EnglishScreen extends StatelessWidget {
  const EnglishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📖 English Learning')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: AppConstants.englishTopics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final topic = AppConstants.englishTopics[index];
            final emoji = AppConstants.englishEmojis[index];
            final color = AppTheme.getTopicColor(topic);
            final lessonId = 'english_${topic.toLowerCase()}';
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
      case 'Alphabet':
        Navigator.push(
            context, SlideTransitionPage(page: const AlphabetScreen()));
        break;
      case 'Vocabulary':
        Navigator.push(
            context, SlideTransitionPage(page: const VocabularyScreen()));
        break;
      case 'Tracing':
        Navigator.push(
            context, SlideTransitionPage(page: const TracingScreen()));
        break;
      case 'Animals':
        Navigator.push(
            context,
            SlideTransitionPage(
                page: VocabCategoryScreen(
                    category: 'animals', title: '🐾 Animals')));
        break;
      case 'Fruits':
        Navigator.push(
            context,
            SlideTransitionPage(
                page: VocabCategoryScreen(
                    category: 'fruits', title: '🍎 Fruits')));
        break;
      case 'Colors':
        Navigator.push(
            context,
            SlideTransitionPage(
                page: VocabCategoryScreen(
                    category: 'colors', title: '🎨 Colors')));
        break;
      case 'Phonics':
        Navigator.push(context,
            SlideTransitionPage(page: const PhonicsScreen()));
        break;
      case 'Sight Words':
        Navigator.push(context,
            SlideTransitionPage(page: const SightWordsScreen()));
        break;
      case 'Spelling':
        Navigator.push(context,
            SlideTransitionPage(page: const SpellingScreen()));
        break;
      case 'Body Parts':
        Navigator.push(
            context,
            SlideTransitionPage(
                page: VocabCategoryScreen(
                    category: 'body_parts', title: '🦶 Body Parts')));
        break;
      case 'Vegetables':
        Navigator.push(
            context,
            SlideTransitionPage(
                page: VocabCategoryScreen(
                    category: 'vegetables', title: '🥕 Vegetables')));
        break;
      case 'Matching':
        Navigator.push(context,
            SlideTransitionPage(page: const EmojiMatchScreen()));
        break;
    }
  }
}

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  List<AlphabetModel>? _alphabet;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadAlphabet();
  }

  Future<void> _loadAlphabet() async {
    final data = await DataLoader.loadAlphabet();
    setState(() {
      _alphabet = data;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔤 Alphabet')),
      body: _loaded
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _alphabet!.length,
              itemBuilder: (context, index) {
                final item = _alphabet![index];
                final color =
                    AppTheme.getTopicColor('Alphabet');
                return LetterGridCard(
                  letter: item.letter,
                  emoji: item.emoji,
                  color: color,
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideTransitionPage(
                        page: AlphabetDetailScreen(
                          item: item,
                          allItems: _alphabet!,
                          index: index,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class AlphabetDetailScreen extends StatefulWidget {
  final AlphabetModel item;
  final List<AlphabetModel> allItems;
  final int index;

  const AlphabetDetailScreen({
    super.key,
    required this.item,
    required this.allItems,
    required this.index,
  });

  @override
  State<AlphabetDetailScreen> createState() => _AlphabetDetailScreenState();
}

class _AlphabetDetailScreenState extends State<AlphabetDetailScreen> {
  late AlphabetModel _currentItem;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
    _currentIndex = widget.index;
  }

  void _next() {
    if (_currentIndex < widget.allItems.length - 1) {
      setState(() {
        _currentIndex++;
        _currentItem = widget.allItems[_currentIndex];
      });
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _currentItem = widget.allItems[_currentIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Letter ${_currentItem.letter}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.purple, AppTheme.skyBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.purple.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentItem.letter,
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 8,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(_currentItem.emoji1,
                                style: const TextStyle(fontSize: 40)),
                            const SizedBox(height: 4),
                            Text(
                              _currentItem.word1,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text('&',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Column(
                          children: [
                            Text(_currentItem.emoji2,
                                style: const TextStyle(fontSize: 40)),
                            const SizedBox(height: 4),
                            Text(
                              _currentItem.word2,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  ElevatedButton.icon(
                    onPressed: _previous,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  )
                else
                  const SizedBox(width: 120),
                if (_currentIndex < widget.allItems.length - 1)
                  ElevatedButton.icon(
                    onPressed: _next,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<AppStateProvider>()
                          .completeLesson('english_alphabet');
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
      ),
    );
  }
}

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  VocabularyData? _vocab;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DataLoader.loadVocabulary();
    setState(() {
      _vocab = data;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📖 Vocabulary')),
      body: _loaded
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(
                      '🐾 Animals', _vocab!.animals, AppTheme.green),
                  const SizedBox(height: 20),
                  _buildCategorySection(
                      '🍎 Fruits', _vocab!.fruits, Colors.orange),
                  const SizedBox(height: 20),
                  _buildCategorySection(
                      '🎨 Colors', _vocab!.colors, AppTheme.purple),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCategorySection(
      String title, List<VocabularyWord> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: color.withValues(alpha: 0.3), width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.emoji,
                          style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 4),
                      Text(
                        item.word,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
        ),
      ],
    );
  }
}

class VocabCategoryScreen extends StatefulWidget {
  final String category;
  final String title;

  const VocabCategoryScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  State<VocabCategoryScreen> createState() => _VocabCategoryScreenState();
}

class _VocabCategoryScreenState extends State<VocabCategoryScreen> {
  List<VocabularyWord>? _items;
  bool _loaded = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final vocab = await DataLoader.loadVocabulary();
    setState(() {
      _items = vocab.getCategory(widget.category);
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loaded && _items!.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  AnimatedCard(
                    child: Column(
                      children: [
                        Text(
                          _items![_currentIndex].emoji,
                          style: const TextStyle(fontSize: 80),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _items![_currentIndex].word,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.purple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _items![_currentIndex].description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentIndex > 0)
                        ElevatedButton.icon(
                          onPressed: () => setState(() => _currentIndex--),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                        )
                      else
                        const SizedBox(width: 100),
                      if (_currentIndex < _items!.length - 1)
                        ElevatedButton.icon(
                          onPressed: () => setState(() => _currentIndex++),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Next'),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.check),
                          label: const Text('Done'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.green,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class TracingScreen extends StatelessWidget {
  const TracingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('✏️ Letter Tracing')),
      body: FutureBuilder<List<AlphabetModel>>(
        future: DataLoader.loadAlphabet(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final alphabet = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: alphabet.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = alphabet[index];
                      return AnimatedCard(
                        color: AppTheme.lightPink,
                        padding: const EdgeInsets.all(12),
                        child: ListTile(
                          leading: Text(item.emoji,
                              style: const TextStyle(fontSize: 36)),
                          title: Text(
                            'Letter ${item.letter}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppTheme.purple,
                            ),
                          ),
                          subtitle: Text(item.word),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: AppTheme.purple),
                          onTap: () {
                            Navigator.push(
                              context,
                              SlideTransitionPage(
                                page: _TracingDetailScreen(item: item),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TracingDetailScreen extends StatelessWidget {
  final AlphabetModel item;

  const _TracingDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('✏️ Trace ${item.letter}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '${item.emoji} ${item.letter} for ${item.word}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.purple,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TracingPad(
                letter: item.letter,
                color: AppTheme.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhonicsScreen extends StatefulWidget {
  const PhonicsScreen({super.key});

  @override
  State<PhonicsScreen> createState() => _PhonicsScreenState();
}

class _PhonicsScreenState extends State<PhonicsScreen> {
  List<PhonicsModel>? _phonics;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DataLoader.loadPhonics();
    setState(() {
      _phonics = data;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔊 Phonics')),
      body: _loaded
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _phonics!.length,
              itemBuilder: (context, index) {
                final item = _phonics![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideTransitionPage(
                        page: PhonicsDetailScreen(
                          item: item,
                          allItems: _phonics!,
                          index: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.getTopicColor('Phonics'),
                          AppTheme.getTopicColor('Phonics').withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.getTopicColor('Phonics').withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.emoji,
                            style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(
                          item.letter,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          item.sound,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class PhonicsDetailScreen extends StatefulWidget {
  final PhonicsModel item;
  final List<PhonicsModel> allItems;
  final int index;

  const PhonicsDetailScreen({
    super.key,
    required this.item,
    required this.allItems,
    required this.index,
  });

  @override
  State<PhonicsDetailScreen> createState() => _PhonicsDetailScreenState();
}

class _PhonicsDetailScreenState extends State<PhonicsDetailScreen> {
  late PhonicsModel _currentItem;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
    _currentIndex = widget.index;
  }

  void _next() {
    if (_currentIndex < widget.allItems.length - 1) {
      setState(() {
        _currentIndex++;
        _currentItem = widget.allItems[_currentIndex];
      });
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _currentItem = widget.allItems[_currentIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getTopicColor('Phonics');
    return Scaffold(
      appBar: AppBar(title: Text('🔊 ${_currentItem.letter} Sound')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentItem.letter,
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 8,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${_currentItem.sound}"',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentItem.emoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentItem.word,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentItem.phrase,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  ElevatedButton.icon(
                    onPressed: _previous,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  )
                else
                  const SizedBox(width: 120),
                if (_currentIndex < widget.allItems.length - 1)
                  ElevatedButton.icon(
                    onPressed: _next,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<AppStateProvider>()
                          .completeLesson('english_phonics');
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
      ),
    );
  }
}

class SightWordsScreen extends StatefulWidget {
  const SightWordsScreen({super.key});

  @override
  State<SightWordsScreen> createState() => _SightWordsScreenState();
}

class _SightWordsScreenState extends State<SightWordsScreen> {
  List<SightWordModel>? _words;
  int _currentIndex = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DataLoader.loadSightWords();
    setState(() {
      _words = data;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👁️ Sight Words')),
      body: _loaded
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6A0572),
                            Color(0xFFAB83A1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6A0572).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _words![_currentIndex].emoji,
                            style: const TextStyle(fontSize: 64),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _words![_currentIndex].word,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 4,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('💬 ',
                                    style: TextStyle(fontSize: 20)),
                                Text(
                                  _words![_currentIndex].sentence,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            child: Text(
                              'Level ${_words![_currentIndex].difficulty}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                      if (_currentIndex < _words!.length - 1)
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
                                .completeLesson('english_sight_words');
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

class SpellingScreen extends StatefulWidget {
  const SpellingScreen({super.key});

  @override
  State<SpellingScreen> createState() => _SpellingScreenState();
}

class _SpellingScreenState extends State<SpellingScreen> {
  List<VocabularyWord>? _words;
  VocabularyWord? _currentWord;
  List<String> _scrambled = [];
  List<String> _userWord = [];
  int _round = 0;
  int _score = 0;
  bool _loaded = false;

  final int _totalRounds = 5;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final vocab = await DataLoader.loadVocabulary();
    final all = [
      ...vocab.animals.take(4),
      ...vocab.fruits.take(3),
      ...vocab.colors.take(3),
    ];
    setState(() {
      _words = all..shuffle();
      _loaded = true;
      _setupRound();
    });
  }

  void _setupRound() {
    if (_words == null || _round >= _words!.length) return;
    setState(() {
      _currentWord = _words![_round % _words!.length];
      _scrambled = _currentWord!.word.split('')..shuffle();
      _userWord = [];
    });
  }

  void _addLetter(String letter) {
    if (_userWord.length < _currentWord!.word.length) {
      setState(() {
        _userWord.add(letter);
        _scrambled.remove(letter);
      });
      if (_userWord.length == _currentWord!.word.length) {
        _checkAnswer();
      }
    }
  }

  void _removeLastLetter() {
    if (_userWord.isNotEmpty) {
      setState(() {
        final letter = _userWord.removeLast();
        _scrambled.add(letter);
      });
    }
  }

  void _checkAnswer() {
    final userWord = _userWord.join();
    final correct =
        userWord.toLowerCase() == _currentWord!.word.toLowerCase();
    if (correct) _score++;

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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_currentWord!.emoji,
                style: const TextStyle(fontSize: 48)),
            Text('The word was ${_currentWord!.word}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _round++;
                if (_round >= _totalRounds) {
                  _finishGame();
                } else {
                  _setupRound();
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
    context
        .read<AppStateProvider>()
        .completeLesson('english_spelling');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('✍️ '),
            Text('Great Speller!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You spelled $_score/$_totalRounds correctly!'),
            const SizedBox(height: 10),
            StarDisplay(starCount: _score, maxStars: _totalRounds),
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
      appBar: AppBar(title: const Text('✍️ Spelling')),
      body: _loaded && _currentWord != null
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
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _currentWord!.emoji,
                          style: const TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Spell the word!',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightYellow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _currentWord!.word.length,
                        (i) => Container(
                          width: 42,
                          height: 48,
                          margin:
                              const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppTheme.purple
                                  .withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              i < _userWord.length
                                  ? _userWord[i]
                                  : '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.purple,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_userWord.isNotEmpty)
                    TextButton.icon(
                      onPressed: _removeLastLetter,
                      icon: const Icon(Icons.undo),
                      label: const Text('Undo'),
                    ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: _scrambled.map((letter) {
                        return GestureDetector(
                          onTap: () => _addLetter(letter),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF00B4D8),
                                  Color(0xFF90E0EF),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius:
                                  BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00B4D8)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  fontSize: 22,
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
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class EmojiMatchScreen extends StatefulWidget {
  const EmojiMatchScreen({super.key});

  @override
  State<EmojiMatchScreen> createState() => _EmojiMatchScreenState();
}

class _EmojiMatchScreenState extends State<EmojiMatchScreen> {
  List<_MatchPair>? _pairs;
  int _currentIndex = 0;
  String? _selectedWord;
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
    final items = [
      ...vocab.animals.take(3),
      ...vocab.fruits.take(2),
      ...vocab.bodyParts.take(2),
    ];
    items.shuffle();
    setState(() {
      _pairs = items.map((e) => _MatchPair(e.emoji, e.word)).toList();
      _loaded = true;
    });
  }

  void _onSelect(String word) {
    if (_showResult) return;
    setState(() {
      _selectedWord = word;
      _showResult = true;
      _correct = word == _pairs![_currentIndex].word;
      if (_correct) _score++;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        if (_currentIndex < _pairs!.length - 1) {
          setState(() {
            _currentIndex++;
            _selectedWord = null;
            _showResult = false;
          });
        } else {
          _finishGame();
        }
      }
    });
  }

  void _finishGame() {
    context
        .read<AppStateProvider>()
        .completeLesson('english_matching');
    context.read<AppStateProvider>().addStars(_score);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🧩 '),
            Text('Match Master!',
                style: TextStyle(color: AppTheme.purple)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'You matched $_score/${_pairs!.length} correctly!'),
            const SizedBox(height: 10),
            StarDisplay(
                starCount: _score, maxStars: _pairs!.length),
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
      appBar: AppBar(title: const Text('🧩 Emoji Match')),
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
                  const SizedBox(height: 12),
                  Text(
                    '${_currentIndex + 1}/${_pairs!.length}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  AnimatedCard(
                    child: Center(
                      child: Text(
                        _pairs![_currentIndex].emoji,
                        style: const TextStyle(fontSize: 80),
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
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            _correct
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: _correct
                                ? Colors.green
                                : Colors.red,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _correct
                                ? 'Correct!'
                                : 'Wrong! It was ${_pairs![_currentIndex].word}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _correct
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: _pairs!.map((pair) {
                      final isSelected =
                          _selectedWord == pair.word;
                      final isDone = _pairs!.indexOf(pair) <
                          _currentIndex;
                      return Opacity(
                        opacity: isDone ? 0.3 : 1.0,
                        child: GestureDetector(
                          onTap: isDone
                              ? null
                              : () => _onSelect(pair.word),
                          child: AnimatedCard(
                            color: isSelected
                                ? AppTheme.lightYellow
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Text(
                              pair.word,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppTheme.purple
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
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

class _MatchPair {
  final String emoji;
  final String word;
  _MatchPair(this.emoji, this.word);
}
