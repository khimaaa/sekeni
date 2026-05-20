import 'package:flutter/material.dart';

import '../widgets/mauritania_logo.dart';
import 'language_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _pulseController;
  late final AnimationController _nameController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotation;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _pulse;
  late final Animation<double> _nameOpacity;
  late final Animation<Offset> _nameSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _nameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoRotation = Tween<double>(begin: -0.15, end: 0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );
    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _nameOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _nameController, curve: Curves.easeIn),
    );
    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _nameController, curve: Curves.easeOutCubic),
    );

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _nameController.forward();
    });
    Future.delayed(const Duration(milliseconds: 3500), _goToLogin);
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, __) => const LanguageSelectionScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF007A3D),
              Color(0xFF005C2E),
              Color(0xFF003D20),
            ],
          ),
        ),
        child: Stack(
          children: [
            _glow(top: -60, right: -40, size: 200, alpha: 0.08),
            _glow(bottom: 120, left: -70, size: 240, alpha: 0.1, gold: true),
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_logoController, _pulseController]),
                builder: (_, child) => Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value * _pulse.value,
                    child: Transform.rotate(
                      angle: _logoRotation.value,
                      child: child,
                    ),
                  ),
                ),
                child: const MauritaniaLogo(size: 150),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 56,
              child: SlideTransition(
                position: _nameSlide,
                child: FadeTransition(
                  opacity: _nameOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Sekeni',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Location en Mauritanie',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glow({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double alpha,
    bool gold = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: gold
              ? const Color(0xFFFFD700).withValues(alpha: alpha)
              : Colors.white.withValues(alpha: alpha),
        ),
      ),
    );
  }
}
