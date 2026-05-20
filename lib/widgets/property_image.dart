import 'package:flutter/material.dart';

class PropertyImage extends StatelessWidget {
  const PropertyImage({
    super.key,
    required this.imagePath,
    this.height = 220,
    this.borderRadius,
  });

  final String imagePath;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(
        imagePath,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade300,
                Colors.deepOrange.shade400,
              ],
            ),
          ),
          child: const Icon(
            Icons.home_work,
            size: 64,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
