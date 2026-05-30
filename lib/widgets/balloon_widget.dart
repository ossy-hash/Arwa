import 'dart:math';
import 'package:flutter/material.dart';

class BalloonWidget extends StatefulWidget {
  final String letter;
  final Color color;
  final VoidCallback onPop;
  final double speed;

  const BalloonWidget({
    super.key,
    required this.letter,
    required this.color,
    required this.onPop,
    this.speed = 1.0,
  });

  @override
  State<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends State<BalloonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  bool _popped = false;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: (3000 / widget.speed).toInt()),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void pop() {
    if (!_popped) {
      setState(() => _popped = true);
      widget.onPop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_popped) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            sin(_floatAnimation.value * 0.1 + _random.nextDouble() * 6) * 8,
            _floatAnimation.value,
          ),
          child: GestureDetector(
            onTap: pop,
            child: Container(
              width: 70,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.color.withValues(alpha: 0.9),
                    widget.color.withValues(alpha: 0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.letter,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
