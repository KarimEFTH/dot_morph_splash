import 'package:flutter/animation.dart';

/// Constantes utilisees par le splash screen anime
class SplashConstants {
  SplashConstants._();

  static const Color primaryRed = Color(0xFFD6303C);
  static const Duration totalDuration = Duration(milliseconds: 3000);
  static const double outerCircleRadius = 48;
  static const double innerDotRadius = 12;
  static const double finalScale = 12;

  // Courbe du slide : leger overshoot a l'arrivee
  static const Cubic slideCurve = Cubic(.47, -1.26, .36, 1);

  // Courbe du scale : leger undershoot au depart
  static const Cubic scaleCurve = Cubic(0.58, -0.30, 0.365, 1);
}
