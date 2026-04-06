import 'package:flutter/material.dart';

enum DeviceType { phone, laptop, tablet, tv, speaker, router, other }

class Device {
  final String id;
  final String name;
  final String macAddress;
  final String ipAddress;
  final DeviceType type;
  final bool isConnected;
  final double signalStrength;
  final DateTime connectedAt;

  const Device({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.ipAddress,
    required this.type,
    required this.isConnected,
    required this.signalStrength,
    required this.connectedAt,
  });

  Device copyWith({
    String? id,
    String? name,
    String? macAddress,
    String? ipAddress,
    DeviceType? type,
    bool? isConnected,
    double? signalStrength,
    DateTime? connectedAt,
  }) =>
      Device(
        id: id ?? this.id,
        name: name ?? this.name,
        macAddress: macAddress ?? this.macAddress,
        ipAddress: ipAddress ?? this.ipAddress,
        type: type ?? this.type,
        isConnected: isConnected ?? this.isConnected,
        signalStrength: signalStrength ?? this.signalStrength,
        connectedAt: connectedAt ?? this.connectedAt,
      );

  IconData get icon {
    switch (type) {
      case DeviceType.phone:   return Icons.smartphone_rounded;
      case DeviceType.laptop:  return Icons.laptop_rounded;
      case DeviceType.tablet:  return Icons.tablet_rounded;
      case DeviceType.tv:      return Icons.tv_rounded;
      case DeviceType.speaker: return Icons.speaker_rounded;
      case DeviceType.router:  return Icons.router_rounded;
      case DeviceType.other:   return Icons.devices_other_rounded;
    }
  }

  String get typeLabel {
    switch (type) {
      case DeviceType.phone:   return 'Phone';
      case DeviceType.laptop:  return 'Laptop';
      case DeviceType.tablet:  return 'Tablet';
      case DeviceType.tv:      return 'Smart TV';
      case DeviceType.speaker: return 'Speaker';
      case DeviceType.router:  return 'Router';
      case DeviceType.other:   return 'Other';
    }
  }

  int get signalBars {
    if (signalStrength >= 0.75) return 4;
    if (signalStrength >= 0.5)  return 3;
    if (signalStrength >= 0.25) return 2;
    return 1;
  }
}