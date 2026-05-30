import 'package:flutter/material.dart';
import '../animations/celebration.dart';

class ConfettiOverlay extends StatelessWidget {
  final bool show;
  final Widget child;

  const ConfettiOverlay({
    super.key,
    required this.show,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CelebrationOverlay(
      show: show,
      child: child,
    );
  }
}
