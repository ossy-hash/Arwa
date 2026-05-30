import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../utils/theme.dart';
import '../widgets/big_menu_button.dart';
import '../animations/float.dart';
import '../widgets/arwa_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _floatingEmojis = ['⭐', '🌈', '🎈', '🦋', '🌸', '🚀', '✨', '🎨'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppStateProvider>().loadState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      body: Stack(
        children: [
          _buildFloatingBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(appState),
                  const SizedBox(height: 10),
                  _buildWelcomeText(),
                  const SizedBox(height: 24),
                  _buildMenuGrid(),
                  const SizedBox(height: 16),
                  _buildProgressSection(appState),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppStateProvider appState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SmallLogo(size: 48),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ARWA',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.purple,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Learn & Play!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _buildBadge(Icons.star_rounded, Colors.amber, '${appState.stars}'),
            const SizedBox(width: 12),
            _buildBadge(
                Icons.monetization_on_rounded, Colors.orange, '${appState.coins}'),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello ARWA! 👋',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose a subject to start learning!',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGrid() {
    return Column(
      children: [
        BigMenuButton(
          title: 'English',
          emoji: '🔤',
          gradient: AppTheme.getGradient('English'),
          onTap: () => Navigator.pushNamed(context, '/english'),
        ),
        const SizedBox(height: 14),
        BigMenuButton(
          title: 'Math',
          emoji: '🔢',
          gradient: AppTheme.getGradient('Math'),
          onTap: () => Navigator.pushNamed(context, '/math'),
        ),
        const SizedBox(height: 14),
        BigMenuButton(
          title: 'Arabic',
          emoji: '🇸🇦',
          gradient: AppTheme.getGradient('Arabic'),
          onTap: () => Navigator.pushNamed(context, '/arabic'),
        ),
        const SizedBox(height: 14),
        BigMenuButton(
          title: 'Mini Games',
          emoji: '🎮',
          gradient: AppTheme.getGradient('Games'),
          onTap: () => Navigator.pushNamed(context, '/games'),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: BigMenuButton(
                title: 'Rewards',
                emoji: '🏆',
                gradient: AppTheme.getGradient('Rewards'),
                height: 90,
                onTap: () => Navigator.pushNamed(context, '/rewards'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: BigMenuButton(
                title: 'Settings',
                emoji: '⚙️',
                gradient: AppTheme.getGradient('Settings'),
                height: 90,
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSection(AppStateProvider appState) {
    const totalLessons = 29;
    final completed = appState.completedLessons.length;
    final progress = totalLessons > 0 ? completed / totalLessons : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightYellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppTheme.purple),
                  minHeight: 14,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            '$completed / $totalLessons lessons completed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBackground() {
    return Positioned.fill(
      child: Column(
        children: List.generate(
          6,
          (i) => Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingWidget(
                  duration: Duration(seconds: 3 + i),
                  child: Text(
                    _floatingEmojis[i % _floatingEmojis.length],
                    style: TextStyle(
                      fontSize: 20.0 + (i * 4),
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                FloatingWidget(
                  duration: Duration(seconds: 4 + i),
                  child: Text(
                    _floatingEmojis[(i + 3) % _floatingEmojis.length],
                    style: TextStyle(
                      fontSize: 24.0 + (i * 3),
                      color: Colors.grey.withValues(alpha: 0.08),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
