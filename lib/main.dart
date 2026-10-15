import 'package:flutter/material.dart';

import 'constants/splash_constants.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const DotMorphSplashApp());
}

class DotMorphSplashApp extends StatelessWidget {
  const DotMorphSplashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dot Morph Splash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: SplashConstants.primaryRed,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
