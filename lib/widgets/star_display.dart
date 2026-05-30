import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final int starCount;
  final int maxStars;
  final double size;

  const StarDisplay({
    super.key,
    this.starCount = 0,
    this.maxStars = 5,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            index < starCount ? Icons.star : Icons.star_border,
            color: index < starCount ? Colors.amber : Colors.grey.shade300,
            size: size,
          ),
        );
      }),
    );
  }
}

class AnimatedStar extends StatefulWidget {
  final int starCount;
  final double size;

  const AnimatedStar({
    super.key,
    required this.starCount,
    this.size = 40,
  });

  @override
  State<AnimatedStar> createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<AnimatedStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _starAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _starAnimations = List.generate(
      widget.starCount,
      (i) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.15, 0.6 + i * 0.1, curve: Curves.elasticOut),
        ),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (index) {
        return AnimatedBuilder(
          animation: _starAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _starAnimations[index].value,
              child: Opacity(
                opacity: _starAnimations[index].value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.star,
              color: Colors.amber,
              size: widget.size,
            ),
          ),
        );
      }),
    );
  }
}
