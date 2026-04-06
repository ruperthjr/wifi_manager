import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) { _load(); }

  static const _key = 'nestnet_dark_mode';

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (mounted) state = p.getBool(_key) ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final p = await SharedPreferences.getInstance();
    await p.setBool(_key, state);
  }
}