import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'particles.dart';

class SoftBackground extends StatelessWidget {
  const SoftBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [AppColors.darkBackground, Color(0xFF1F1B33)]
              : const [AppColors.background, Color(0xFFF2E9FF)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const AmbientParticles(),
          child,
        ],
      ),
    );
  }
}
