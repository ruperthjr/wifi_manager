import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device.dart';

final devicesProvider = StateNotifierProvider<DevicesNotifier, List<Device>>(
    (ref) => DevicesNotifier());

class DevicesNotifier extends StateNotifier<List<Device>> {
  DevicesNotifier() : super(_seed());

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
          connectedAt: DateTime.now().subtract(const Duration(minutes: 30)),
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

  void add(Device d) => state = [...state, d];

  void remove(String id) => state = state.where((d) => d.id != id).toList();

  void toggle(String id) => state = [
        for (final d in state)
          if (d.id == id) d.copyWith(isConnected: !d.isConnected) else d,
      ];
}

final connectedDevicesProvider = Provider<List<Device>>(
  (ref) => ref.watch(devicesProvider).where((d) => d.isConnected).toList(),
);

final deviceCountProvider = Provider<int>(
  (ref) => ref.watch(connectedDevicesProvider).length,
);
