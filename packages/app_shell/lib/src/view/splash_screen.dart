import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Lightweight splash while the first route is decided (doc 18).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLogoHeader(centered: true),
          SizedBox(height: 24),
          SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ),
    ),
  );
}
