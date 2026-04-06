import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'providers/theme_provider.dart';
import 'Screens/SplashScreen.dart';

class NestNetApp extends ConsumerWidget {
  const NestNetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return MaterialApp(
      title: 'NestNet',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const SplashScreen(),
    );
  }
}