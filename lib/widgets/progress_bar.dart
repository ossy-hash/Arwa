import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final Color? color;

  const ProgressBar({
    super.key,
    required this.progress,
    this.height = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color ?? AppTheme.purple),
            minHeight: height,
          ),
        );
      },
    );
  }
}

class ProgressRow extends StatelessWidget {
  final String label;
  final double progress;
  final String? progressText;

  const ProgressRow({
    super.key,
    required this.label,
    required this.progress,
    this.progressText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              progressText ?? '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ProgressBar(progress: progress),
      ],
    );
  }
}
