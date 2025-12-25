import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedMysteryBackground extends StatelessWidget {
  final Widget child;
  final bool isDangerMode;

  const AnimatedMysteryBackground({
    super.key,
    required this.child,
    this.isDangerMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0F0A2E), // Deep purple
                const Color(0xFF1A1A2E), // Dark purple
                const Color(0xFF16213E), // Navy blue
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Animated gradient overlay
        AnimatedContainer(
          duration: const Duration(seconds: 3),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDangerMode
                  ? [
                      const Color(0xFF2D1B69).withValues(alpha: 0.8),
                      const Color(0xFF8B0000).withValues(alpha: 0.3), // Dark red
                      const Color(0xFF4A0E4E).withValues(alpha: 0.6), // Dark magenta
                    ]
                  : [
                      const Color(0xFF2D1B69).withValues(alpha: 0.6),
                      const Color(0xFF1A1A2E).withValues(alpha: 0.4),
                      const Color(0xFF0E4B99).withValues(alpha: 0.3), // Deep blue
                    ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .fade(
              duration: 4000.ms,
              begin: 0.3,
              end: 0.7,
              curve: Curves.easeInOut,
            ),

        // Floating particles
        ...List.generate(15, (index) => _FloatingParticle(
          index: index,
          isDanger: isDangerMode,
        )),

        // Pulsing danger effect
        if (isDangerMode)
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.transparent,
                  const Color(0xFFFF0000).withValues(alpha: 0.1),
                  const Color(0xFF8B0000).withValues(alpha: 0.2),
                ],
              ),
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                duration: 2000.ms,
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.2, 1.2),
                curve: Curves.easeInOut,
              )
              .fade(
                duration: 2000.ms,
                begin: 0.0,
                end: 0.3,
                curve: Curves.easeInOut,
              ),

        // Child content
        child,
      ],
    );
  }
}

class _FloatingParticle extends StatelessWidget {
  final int index;
  final bool isDanger;

  const _FloatingParticle({
    required this.index,
    required this.isDanger,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final random = math.Random(index);

    final startX = random.nextDouble() * size.width;
    final startY = random.nextDouble() * size.height;
    final particleSize = 2.0 + random.nextDouble() * 4.0;
    final duration = (3000 + random.nextInt(4000)).ms;
    final delay = (random.nextInt(2000)).ms;

    return Positioned(
      left: startX,
      top: startY,
      child: Container(
        width: particleSize,
        height: particleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDanger
              ? const Color(0xFFFF6B6B).withValues(alpha: 0.6)
              : const Color(0xFF4ECDC4).withValues(alpha: 0.4),
          boxShadow: [
            BoxShadow(
              color: isDanger
                  ? const Color(0xFFFF6B6B).withValues(alpha: 0.3)
                  : const Color(0xFF4ECDC4).withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      )
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .moveY(
            duration: duration,
            begin: 0,
            end: -50 - random.nextDouble() * 100,
            curve: Curves.easeInOut,
            delay: delay,
          )
          .moveX(
            duration: duration,
            begin: 0,
            end: (random.nextDouble() - 0.5) * 100,
            curve: Curves.easeInOut,
            delay: delay,
          )
          .fade(
            duration: duration,
            begin: 0.0,
            end: 1.0,
            curve: Curves.easeIn,
            delay: delay,
          )
          .scale(
            duration: duration,
            begin: const Offset(0.3, 0.3),
            end: const Offset(1.2, 1.2),
            curve: Curves.easeOut,
            delay: delay,
          ),
    );
  }
}