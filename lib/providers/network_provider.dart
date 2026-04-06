import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkStats {
  final double download;
  final double upload;
  final int ping;
  final double signal;

  const NetworkStats({
    required this.download,
    required this.upload,
    required this.ping,
    required this.signal,
  });
}

final networkStatsProvider = StreamProvider<NetworkStats>((ref) {
  final rng = Random();
  return Stream.periodic(
    const Duration(seconds: 3),
    (_) => NetworkStats(
      download: 80 + rng.nextDouble() * 120,
      upload: 20 + rng.nextDouble() * 40,
      ping: 5 + rng.nextInt(25),
      signal: 0.7 + rng.nextDouble() * 0.3,
    ),
  ).asBroadcastStream();
});

const _kNetworkNameKey = 'nestnet_network_name';

final networkNameProvider =
    StateNotifierProvider<NetworkNameNotifier, String>(
        (ref) => NetworkNameNotifier());

class NetworkNameNotifier extends StateNotifier<String> {
  NetworkNameNotifier() : super('NestNet_5G') {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kNetworkNameKey);
    if (saved != null && mounted) state = saved;
  }

  Future<void> setName(String name) async {
    state = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNetworkNameKey, name);
  }
}