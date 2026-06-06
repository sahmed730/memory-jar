import 'dart:math';
import 'package:flutter/material.dart';

class AmbientParticles extends StatefulWidget {
  const AmbientParticles({super.key});

  @override
  State<AmbientParticles> createState() => _AmbientParticlesState();
}

class _AmbientParticlesState extends State<AmbientParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();

    // Initialize 5 slow moving particles
    for (int i = 0; i < 5; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speedX: (_random.nextDouble() - 0.5) * 0.05,
        speedY: (_random.nextDouble() - 0.5) * 0.05,
        radius: _random.nextDouble() * 100 + 50,
        colorOpacity: _random.nextDouble() * 0.15 + 0.05,
      ));
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
      animation: _controller,
      builder: (context, _) {
        _updateParticles();
        return CustomPaint(
          painter: _ParticlePainter(_particles, Theme.of(context).colorScheme.primary),
          size: Size.infinite,
        );
      },
    );
  }

  void _updateParticles() {
    for (var particle in _particles) {
      particle.x += particle.speedX * 0.016; // Approx 60fps delta
      particle.y += particle.speedY * 0.016;

      // Bounce off walls (0.0 to 1.0 logic space)
      if (particle.x < 0 || particle.x > 1) particle.speedX *= -1;
      if (particle.y < 0 || particle.y > 1) particle.speedY *= -1;
    }
  }
}

class _Particle {
  double x, y;
  double speedX, speedY;
  double radius;
  double colorOpacity;

  _Particle({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.radius,
    required this.colorOpacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color baseColor;

  _ParticlePainter(this.particles, this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = baseColor.withValues(alpha: particle.colorOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
