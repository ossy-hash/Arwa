import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ArwaLogo extends StatelessWidget {
  final double size;

  const ArwaLogo({super.key, this.size = 160});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: size * 0.12,
            offset: Offset(0, size * 0.06),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'A',
            style: TextStyle(
              fontSize: size * 0.65,
              fontWeight: FontWeight.w900,
              color: AppTheme.purple,
              letterSpacing: 0,
            ),
          ),
          Positioned(
            top: size * 0.18,
            child: Text(
              '★',
              style: TextStyle(
                fontSize: size * 0.15,
                color: AppTheme.yellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmallLogo extends StatelessWidget {
  final double size;

  const SmallLogo({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.yellow,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Center(
        child: Text(
          'A',
          style: TextStyle(
            fontSize: size * 0.55,
            fontWeight: FontWeight.w900,
            color: AppTheme.purple,
          ),
        ),
      ),
    );
  }
}
