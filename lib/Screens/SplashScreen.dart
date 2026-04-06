import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../Widgets/FadeRoute.dart';
import 'Login.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 1000),
  );
  late final AnimationController _textCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 800),
  );
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
  );
  late final Animation<double> _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _logoCtrl, curve: const Interval(0, 0.5)),
  );
  late final Animation<double> _textOpacity = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn),
  );
  late final Animation<double> _pulse = Tween<double>(begin: 1.0, end: 1.12).animate(
    CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
  );

  @override
  void initState() {
    super.initState();
    _logoCtrl.forward().then((_) {
      _textCtrl.forward().then((_) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(FadeRoute(page: const LoginScreen()));
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_logoCtrl, _pulseCtrl]),
                builder: (_, __) => Transform.scale(
                  scale: _scale.value * _pulse.value,
                  child: Opacity(
                    opacity: _logoOpacity.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'Assets/homeWifi.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.wifi_rounded,
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _textCtrl,
                builder: (_, __) => Opacity(
                  opacity: _textOpacity.value,
                  child: Column(
                    children: [
                      Text(
                        AppStrings.appName,
                        style: GoogleFonts.poppins(
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.tagline,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
              AnimatedBuilder(
                animation: _textCtrl,
                builder: (_, __) => Opacity(
                  opacity: _textOpacity.value,
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}