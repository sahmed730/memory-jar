import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class JarMark extends StatelessWidget {
  const JarMark({super.key, this.size = 96, this.glow = true});

  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _JarPainter(glow: glow, isDark: Theme.of(context).brightness == Brightness.dark),
      ),
    );
  }
}

class _JarPainter extends CustomPainter {
  _JarPainter({required this.glow, required this.isDark});

  final bool glow;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 96;
    final bodyRect = Rect.fromLTWH(22 * scale, 26 * scale, 52 * scale, 58 * scale);
    final lidRect = Rect.fromLTWH(29 * scale, 15 * scale, 38 * scale, 12 * scale);
    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: isDark ? 0.38 : 0.22)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18 * scale);

    if (glow) {
      canvas.drawOval(Rect.fromLTWH(25 * scale, 38 * scale, 46 * scale, 48 * scale), glowPaint);
    }

    final glassPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: isDark ? 0.22 : 0.7),
          AppColors.primaryContainer.withValues(alpha: isDark ? 0.16 : 0.32),
        ],
      ).createShader(bodyRect);

    final outlinePaint = Paint()
      ..color = (isDark ? AppColors.darkOnSurfaceVariant : AppColors.outline).withValues(alpha: 0.82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;

    final lidPaint = Paint()
      ..color = AppColors.secondaryContainer.withValues(alpha: isDark ? 0.62 : 1);

    final bodyPath = Path()
      ..moveTo(32 * scale, 26 * scale)
      ..quadraticBezierTo(23 * scale, 30 * scale, 22 * scale, 42 * scale)
      ..lineTo(22 * scale, 68 * scale)
      ..quadraticBezierTo(22 * scale, 84 * scale, 38 * scale, 84 * scale)
      ..lineTo(58 * scale, 84 * scale)
      ..quadraticBezierTo(74 * scale, 84 * scale, 74 * scale, 68 * scale)
      ..lineTo(74 * scale, 42 * scale)
      ..quadraticBezierTo(73 * scale, 30 * scale, 64 * scale, 26 * scale)
      ..close();

    canvas.drawRRect(RRect.fromRectAndRadius(lidRect, Radius.circular(8 * scale)), lidPaint);
    canvas.drawPath(bodyPath, glassPaint);
    canvas.drawPath(bodyPath, outlinePaint);

    final liquidPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primary.withValues(alpha: isDark ? 0.58 : 0.46),
          AppColors.tertiary.withValues(alpha: isDark ? 0.46 : 0.36),
        ],
      ).createShader(bodyRect);

    canvas.drawOval(Rect.fromLTWH(31 * scale, 54 * scale, 38 * scale, 28 * scale), liquidPaint);

    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.38 : 0.76)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(35 * scale, 36 * scale), Offset(30 * scale, 58 * scale), shinePaint);

    final sparkPaint = Paint()..color = AppColors.tertiary.withValues(alpha: 0.86);
    canvas.drawCircle(Offset(43 * scale, 48 * scale), 2.2 * scale, sparkPaint);
    canvas.drawCircle(Offset(56 * scale, 43 * scale), 1.8 * scale, sparkPaint);
    canvas.drawCircle(Offset(52 * scale, 62 * scale), 1.5 * scale, sparkPaint);
  }

  @override
  bool shouldRepaint(covariant _JarPainter oldDelegate) {
    return oldDelegate.glow != glow || oldDelegate.isDark != isDark;
  }
}
