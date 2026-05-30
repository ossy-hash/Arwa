import 'package:flutter/material.dart';
import '../utils/theme.dart';

class LetterCard extends StatelessWidget {
  final String letter;
  final String word;
  final String emoji;
  final bool isLarge;
  final VoidCallback? onTap;

  const LetterCard({
    super.key,
    required this.letter,
    required this.word,
    required this.emoji,
    this.isLarge = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.purple.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: isLarge ? 64 : 40),
            ),
            const SizedBox(height: 8),
            Text(
              letter,
              style: TextStyle(
                fontSize: isLarge ? 72 : 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.purple,
                letterSpacing: 4,
              ),
            ),
            Text(
              word,
              style: TextStyle(
                fontSize: isLarge ? 24 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LetterGridCard extends StatelessWidget {
  final String letter;
  final String emoji;
  final Color color;
  final VoidCallback? onTap;

  const LetterGridCard({
    super.key,
    required this.letter,
    required this.emoji,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              letter,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
