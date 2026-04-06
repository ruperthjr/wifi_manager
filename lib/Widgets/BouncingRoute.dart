import 'package:flutter/material.dart';

class BouncingRoute<T> extends PageRouteBuilder<T> {
  BouncingRoute({required Widget page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (_, animation, __, child) {
            final bounce = CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeIn,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(bounce),
              child: child,
            );
          },
        );
}