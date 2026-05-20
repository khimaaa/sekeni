import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Logo Sekeni — couleurs Mauritanie (vert, or, croissant).
class MauritaniaLogo extends StatelessWidget {
  const MauritaniaLogo({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const SweepGradient(
          colors: [
            Color(0xFF007A3D),
            Color(0xFFFFD700),
            Color(0xFFD21034),
            Color(0xFF007A3D),
          ],
          stops: [0.0, 0.28, 0.52, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007A3D).withValues(alpha: 0.35),
            blurRadius: 32,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(size * 0.06),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF007A3D),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: -math.pi / 5,
              child: Icon(
                Icons.nightlight_round,
                color: const Color(0xFFFFD700),
                size: size * 0.38,
                shadows: const [
                  Shadow(
                    color: Color(0x66FFD700),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
            Positioned(
              right: size * 0.2,
              top: size * 0.18,
              child: Icon(
                Icons.star,
                color: const Color(0xFFFFD700),
                size: size * 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
