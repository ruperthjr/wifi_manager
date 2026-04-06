import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  return Stream.periodic(const Duration(seconds: 3), (_) => NetworkStats(
        download: 80 + rng.nextDouble() * 120,
        upload:   20 + rng.nextDouble() * 40,
        ping:      5 + rng.nextInt(25),
        signal:   0.7 + rng.nextDouble() * 0.3,
      )).asBroadcastStream();
});

final networkNameProvider = StateProvider<String>((ref) => 'NestNet_5G');