import 'package:flutter/material.dart';
import '../utils/theme.dart';

class DraggableCard extends StatelessWidget {
  final String text;
  final String emoji;
  final Color color;

  const DraggableCard({
    super.key,
    required this.text,
    required this.emoji,
    this.color = AppTheme.purple,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 4),
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
}

class DragTargetBox extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isCorrect;
  final bool? hasAttempt;
  final Color color;

  const DragTargetBox({
    super.key,
    required this.emoji,
    required this.label,
    this.isCorrect = false,
    this.hasAttempt,
    this.color = AppTheme.skyBlue,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    if (hasAttempt == true) {
      bgColor = isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    } else {
      bgColor = color.withValues(alpha: 0.1);
    }

    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasAttempt == true
              ? (isCorrect ? Colors.green : Colors.red)
              : color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
