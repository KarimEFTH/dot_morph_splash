import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/splash_constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Phase 1 : le petit cercle glisse de la gauche vers le centre (0ms -> 720ms)
  late final Animation<double> _dotSlide;

  // Phase 2 : le point rouge interieur passe au blanc (800ms -> 1120ms)
  late final Animation<Color?> _innerDotColor;

  // Phase 3 : le grand cercle scale jusqu'a remplir l'ecran (800ms -> 1440ms)
  late final Animation<double> _circleScale;

  bool _hapticFired = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: SplashConstants.totalDuration,
    );

    // Phase 1 : slide du point (0 -> 720ms = 0.0 -> 0.45 de la duree totale)
    _dotSlide = Tween<double>(begin: -3.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: SplashConstants.slideCurve),
      ),
    );

    // Phase 2 : changement de couleur du point interieur (800ms -> 1120ms = 0.5 -> 0.7)
    _innerDotColor = ColorTween(
      begin: SplashConstants.primaryRed,
      end: Colors.white,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Phase 3 : scale du grand cercle (800ms -> 1440ms = 0.5 -> 0.9)
    _circleScale = Tween<double>(begin: 1.0, end: SplashConstants.finalScale)
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: SplashConstants.scaleCurve),
      ),
    );

    // Haptic feedback quand le slide atteint le centre (~720ms)
    _dotSlide.addListener(() {
      if (!_hapticFired && _dotSlide.status == AnimationStatus.forward) {
        // Le slide est termine quand sa valeur atteint 0.0 (centre)
        if (_dotSlide.value >= -0.05) {
          _hapticFired = true;
          HapticFeedback.lightImpact();
        }
      }
    });

    // Navigation quand l'animation est terminee
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _navigateToHome();
      }
    });

    _controller.forward();
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SplashConstants.primaryRed,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            // Grand cercle blanc qui scale
            child: Transform.scale(
              scale: _circleScale.value,
              child: SizedBox(
                width: SplashConstants.outerCircleRadius * 2,
                height: SplashConstants.outerCircleRadius * 2,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      // Point rouge interieur (qui deviendra blanc)
                      Center(
                        child: SizedBox(
                          width: SplashConstants.innerDotRadius * 2,
                          height: SplashConstants.innerDotRadius * 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: _innerDotColor.value,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      // Petit cercle blanc qui glisse depuis la gauche
                      Align(
                        alignment: Alignment(_dotSlide.value, 0.0),
                        child: SizedBox(
                          width: SplashConstants.innerDotRadius * 2,
                          height: SplashConstants.innerDotRadius * 2,
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
