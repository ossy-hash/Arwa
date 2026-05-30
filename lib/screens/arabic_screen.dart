import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../models/arabic_alphabet_model.dart';
import '../models/arabic_vocabulary_model.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../utils/data_loader.dart';
import '../widgets/topic_card.dart';
import '../widgets/animated_card.dart';
import '../widgets/tracing_pad.dart';
import '../animations/slide_transition.dart';

class ArabicScreen extends StatelessWidget {
  const ArabicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🇸🇦 العربية')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: AppConstants.arabicTopics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final topic = AppConstants.arabicTopics[index];
            final emoji = AppConstants.arabicEmojis[index];
            final color = AppTheme.getTopicColor(topic);
            final lessonId = 'arabic_${topic.toLowerCase().replaceAll(' ', '_')}';
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
      case 'Arabic Alphabet':
        Navigator.push(context,
            SlideTransitionPage(page: const ArabicAlphabetScreen()));
        break;
      case 'Arabic Vocabulary':
        Navigator.push(context,
            SlideTransitionPage(page: const ArabicVocabularyScreen()));
        break;
      case 'Arabic Tracing':
        Navigator.push(context,
            SlideTransitionPage(page: const ArabicTracingScreen()));
        break;
      case 'Arabic Animals':
        Navigator.push(
            context,
            SlideTransitionPage(
                page: ArabicVocabCategoryScreen(
                    category: 'animals', title: '🐾 الحيوانات')));
        break;
      case 'Arabic Fruits':
        Navigator.push(
            context,
            SlideTransitionPage(
                page: ArabicVocabCategoryScreen(
                    category: 'fruits', title: '🍎 الفواكه')));
        break;
      case 'Arabic Colors':
        Navigator.push(
            context,
            SlideTransitionPage(
                page: ArabicVocabCategoryScreen(
                    category: 'colors', title: '🎨 الألوان')));
        break;
      case 'Arabic Body Parts':
        Navigator.push(
            context,
            SlideTransitionPage(
                page: ArabicVocabCategoryScreen(
                    category: 'body_parts', title: '🦶 أعضاء الجسم')));
        break;
    }
  }
}

class ArabicAlphabetScreen extends StatefulWidget {
  const ArabicAlphabetScreen({super.key});

  @override
  State<ArabicAlphabetScreen> createState() => _ArabicAlphabetScreenState();
}

class _ArabicAlphabetScreenState extends State<ArabicAlphabetScreen> {
  List<ArabicAlphabetModel>? _alphabet;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadAlphabet();
  }

  Future<void> _loadAlphabet() async {
    final data = await DataLoader.loadArabicAlphabet();
    setState(() {
      _alphabet = data;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أ الحروف العربية')),
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
                final color = AppTheme.getTopicColor('Arabic Alphabet');
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideTransitionPage(
                        page: ArabicAlphabetDetailScreen(
                          item: item,
                          allItems: _alphabet!,
                          index: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.letter,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(item.emoji1,
                            style: const TextStyle(fontSize: 24)),
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

class ArabicAlphabetDetailScreen extends StatefulWidget {
  final ArabicAlphabetModel item;
  final List<ArabicAlphabetModel> allItems;
  final int index;

  const ArabicAlphabetDetailScreen({
    super.key,
    required this.item,
    required this.allItems,
    required this.index,
  });

  @override
  State<ArabicAlphabetDetailScreen> createState() =>
      _ArabicAlphabetDetailScreenState();
}

class _ArabicAlphabetDetailScreenState
    extends State<ArabicAlphabetDetailScreen> {
  late ArabicAlphabetModel _currentItem;
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
    final color = AppTheme.getTopicColor('Arabic Alphabet');
    return Scaffold(
      appBar: AppBar(title: Text('حرف ${_currentItem.letter}')),
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
                    label: const Text('السابق'),
                  )
                else
                  const SizedBox(width: 120),
                if (_currentIndex < widget.allItems.length - 1)
                  ElevatedButton.icon(
                    onPressed: _next,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('التالي'),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<AppStateProvider>()
                          .completeLesson('arabic_arabic_alphabet');
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('تم'),
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

class ArabicVocabularyScreen extends StatefulWidget {
  const ArabicVocabularyScreen({super.key});

  @override
  State<ArabicVocabularyScreen> createState() =>
      _ArabicVocabularyScreenState();
}

class _ArabicVocabularyScreenState extends State<ArabicVocabularyScreen> {
  ArabicVocabularyData? _vocab;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DataLoader.loadArabicVocabulary();
    setState(() {
      _vocab = data;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📖 مفردات عربية')),
      body: _loaded
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(
                      '🐾 الحيوانات', _vocab!.animals, AppTheme.getTopicColor('Arabic Animals')),
                  const SizedBox(height: 20),
                  _buildCategorySection(
                      '🍎 الفواكه', _vocab!.fruits, AppTheme.getTopicColor('Arabic Fruits')),
                  const SizedBox(height: 20),
                  _buildCategorySection(
                      '🎨 الألوان', _vocab!.colors, AppTheme.getTopicColor('Arabic Colors')),
                  const SizedBox(height: 20),
                  _buildCategorySection(
                      '🦶 أعضاء الجسم', _vocab!.bodyParts, AppTheme.getTopicColor('Arabic Body Parts')),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCategorySection(
      String title, List<ArabicVocabularyWord> items, Color color) {
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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    SlideTransitionPage(
                      page: ArabicVocabCategoryScreen(
                        category: 'all',
                        title: title,
                        initialIndex: index,
                        allItems: items,
                      ),
                    ),
                  );
                },
                child: Container(
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ArabicVocabCategoryScreen extends StatefulWidget {
  final String category;
  final String title;
  final int initialIndex;
  final List<ArabicVocabularyWord>? allItems;

  const ArabicVocabCategoryScreen({
    super.key,
    required this.category,
    required this.title,
    this.initialIndex = 0,
    this.allItems,
  });

  @override
  State<ArabicVocabCategoryScreen> createState() =>
      _ArabicVocabCategoryScreenState();
}

class _ArabicVocabCategoryScreenState
    extends State<ArabicVocabCategoryScreen> {
  List<ArabicVocabularyWord>? _items;
  bool _loaded = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    if (widget.allItems != null) {
      _items = widget.allItems;
      _loaded = true;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    final vocab = await DataLoader.loadArabicVocabulary();
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
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getTopicColor('Arabic Alphabet'),
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
                          onPressed: () =>
                              setState(() => _currentIndex--),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('السابق'),
                        )
                      else
                        const SizedBox(width: 100),
                      if (_currentIndex < _items!.length - 1)
                        ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => _currentIndex++),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('التالي'),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.check),
                          label: const Text('تم'),
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

class ArabicTracingScreen extends StatelessWidget {
  const ArabicTracingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('✏️ تتبع الحروف')),
      body: FutureBuilder<List<ArabicAlphabetModel>>(
        future: DataLoader.loadArabicAlphabet(),
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
                          leading: Text(item.emoji1,
                              style: const TextStyle(fontSize: 36)),
                          title: Text(
                            'حرف ${item.letter}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppTheme.getTopicColor('Arabic Alphabet'),
                            ),
                          ),
                          subtitle: Text(item.word1),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: AppTheme.getTopicColor('Arabic Alphabet')),
                          onTap: () {
                            Navigator.push(
                              context,
                              SlideTransitionPage(
                                page: ArabicTracingDetailScreen(item: item),
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

class ArabicTracingDetailScreen extends StatelessWidget {
  final ArabicAlphabetModel item;

  const ArabicTracingDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('✏️ اكتب ${item.letter}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '${item.emoji1} ${item.letter} ${item.word1}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.getTopicColor('Arabic Alphabet'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TracingPad(
                letter: item.letter,
                color: AppTheme.getTopicColor('Arabic Alphabet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
