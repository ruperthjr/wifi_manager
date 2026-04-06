import 'package:flutter/material.dart';

class BouncingRoute<T> extends PageRouteBuilder<T> {
  BouncingRoute({required Widget page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (_, animation, __, child) {
            final scale = Tween<double>(begin: 0.85, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeIn,
              ),
            );
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeIn,
            );
            return ScaleTransition(
              scale: scale,
              child: FadeTransition(opacity: fade, child: child),
            );
          },
        );
}