import 'dart:io';

import 'package:flutter/material.dart';

import 'property_image.dart';

class LocalImage extends StatelessWidget {
  const LocalImage({
    super.key,
    required this.path,
    this.height = 120,
    this.width,
    this.borderRadius,
  });

  final String path;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  bool get _isFile => path.contains(':') || path.startsWith('/');

  @override
  Widget build(BuildContext context) {
    if (_isFile && !path.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.file(
          File(path),
          height: height,
          width: width ?? double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => PropertyImage(
            imagePath: 'assets/images/house1.jpeg',
            height: height,
            borderRadius: borderRadius,
          ),
        ),
      );
    }
    return PropertyImage(
      imagePath: path,
      height: height,
      borderRadius: borderRadius,
    );
  }
}
