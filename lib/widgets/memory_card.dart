import 'package:flutter/material.dart';
import '../utils/theme.dart';

class MemoryCard extends StatefulWidget {
  final String emoji;
  final String word;
  final bool isFlipped;
  final bool isMatched;
  final VoidCallback onTap;
  final Color color;

  const MemoryCard({
    super.key,
    required this.emoji,
    required this.word,
    required this.isFlipped,
    required this.isMatched,
    required this.onTap,
    this.color = AppTheme.purple,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.isFlipped || widget.isMatched) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped && !oldWidget.isFlipped) {
      _controller.forward();
    } else if (!widget.isFlipped && oldWidget.isFlipped) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isFront = _animation.value < 0.5;
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_animation.value * 3.14159),
          alignment: Alignment.center,
          child: isFront ? _buildBack() : _buildFront(),
        );
      },
    );
  }

  Widget _buildBack() {
    return GestureDetector(
      onTap: widget.isMatched ? null : widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.color, widget.color.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Transform(
            transform: Matrix4.identity()..rotateY(3.14159),
            child: const Icon(Icons.question_mark_rounded,
                color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    return Container(
      decoration: BoxDecoration(
        color: widget.isMatched ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isMatched
              ? Colors.green
              : widget.color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Transform(
          transform: Matrix4.identity()..rotateY(3.14159),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 4),
              Text(
                widget.word,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
