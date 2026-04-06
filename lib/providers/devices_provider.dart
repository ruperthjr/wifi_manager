import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device.dart';

const _kDevicesKey = 'nestnet_devices';

final devicesProvider =
    StateNotifierProvider<DevicesNotifier, List<Device>>(
        (ref) => DevicesNotifier());

class DevicesNotifier extends StateNotifier<List<Device>> {
  DevicesNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kDevicesKey);
    if (raw != null) {
      try {
        final list = (jsonDecode(raw) as List)
            .map((e) => Device.fromJson(e as Map<String, dynamic>))
            .toList();
        if (mounted) state = list;
        return;
      } catch (_) {}
    }
    if (mounted) state = _seed();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _kDevicesKey, jsonEncode(state.map((d) => d.toJson()).toList()));
  }

  static List<Device> _seed() => [
        Device(
          id: 'd1',
          name: 'iPhone 15 Pro',
          macAddress: 'A4:C3:F0:12:34:56',
          ipAddress: '192.168.1.101',
          type: DeviceType.phone,
          isConnected: true,
          signalStrength: 0.95,
          connectedAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        Device(
          id: 'd2',
          name: 'MacBook Pro',
          macAddress: 'B8:27:EB:98:76:54',
          ipAddress: '192.168.1.102',
          type: DeviceType.laptop,
          isConnected: true,
          signalStrength: 0.78,
          connectedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Device(
          id: 'd3',
          name: 'Galaxy Tab S9',
          macAddress: 'DC:A6:32:5C:AA:BB',
          ipAddress: '192.168.1.103',
          type: DeviceType.tablet,
          isConnected: true,
          signalStrength: 0.62,
          connectedAt:
              DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        Device(
          id: 'd4',
          name: 'Samsung Smart TV',
          macAddress: 'E4:5F:01:9D:CC:DD',
          ipAddress: '192.168.1.104',
          type: DeviceType.tv,
          isConnected: false,
          signalStrength: 0.45,
          connectedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        Device(
          id: 'd5',
          name: 'Echo Dot (4th Gen)',
          macAddress: 'F0:E0:D0:C0:B0:A0',
          ipAddress: '192.168.1.105',
          type: DeviceType.speaker,
          isConnected: true,
          signalStrength: 0.88,
          connectedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];

  Future<void> add(Device d) async {
    state = [...state, d];
    await _save();
  }

  Future<void> remove(String id) async {
    state = state.where((d) => d.id != id).toList();
    await _save();
  }

  Future<void> toggle(String id) async {
    state = [
      for (final d in state)
        if (d.id == id) d.copyWith(isConnected: !d.isConnected) else d,
    ];
    await _save();
  }

  Future<void> toggleFavorite(String id) async {
    state = [
      for (final d in state)
        if (d.id == id) d.copyWith(isFavorited: !d.isFavorited) else d,
    ];
    await _save();
  }
}

final connectedDevicesProvider = Provider<List<Device>>(
  (ref) =>
      ref.watch(devicesProvider).where((d) => d.isConnected).toList(),
);

final deviceCountProvider = Provider<int>(
  (ref) => ref.watch(connectedDevicesProvider).length,
);

/// Favorites pinned to the top, rest sorted below.
final sortedDevicesProvider = Provider<List<Device>>((ref) {
  final all = ref.watch(devicesProvider);
  final favs = all.where((d) => d.isFavorited).toList();
  final rest = all.where((d) => !d.isFavorited).toList();
  return [...favs, ...rest];
});