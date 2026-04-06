import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../models/device.dart';
import '../providers/auth_provider.dart';
import '../providers/devices_provider.dart';
import '../providers/network_provider.dart';
import '../Widgets/DeviceCard.dart';
import '../Widgets/StatCard.dart';
import '../Widgets/FadeRoute.dart';
import 'Setting.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth        = ref.watch(authProvider);
    final devices     = ref.watch(devicesProvider);
    final connected   = ref.watch(connectedDevicesProvider);
    final statsAsync  = ref.watch(networkStatsProvider);
    final networkName = ref.watch(networkNameProvider);
    final isDark      = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.wifi_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'NestNet',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings_rounded,
                      color: isDark ? Colors.white : AppColors.textDark),
                  onPressed: () => Navigator.of(context)
                      .push(FadeRoute(page: const SettingsScreen())),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppDim.lg, AppDim.sm, AppDim.lg, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Text(
                      'Hey, ${auth.user?.fullName.split(' ').first ?? 'there'} 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Here\'s your network overview',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.subtext),
                    ),
                    const SizedBox(height: 24),

                    // Network banner
                    _NetworkBanner(name: networkName),
                    const SizedBox(height: 24),

                    // Performance
                    Text(
                      'Network Performance',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    statsAsync.when(
                      data: (s) => Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Download',
                              value: s.download.toStringAsFixed(1),
                              unit: 'Mbps',
                              icon: Icons.download_rounded,
                              color: AppColors.secondary,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: StatCard(
                              label: 'Upload',
                              value: s.upload.toStringAsFixed(1),
                              unit: 'Mbps',
                              icon: Icons.upload_rounded,
                              color: AppColors.primary,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: StatCard(
                              label: 'Ping',
                              value: '${s.ping}',
                              unit: 'ms',
                              icon: Icons.speed_rounded,
                              color: AppColors.warning,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppDim.md),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (e, _) => Text('Stats error: $e'),
                    ),
                    const SizedBox(height: 24),

                    // Devices header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Connected Devices',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppColors.textDark,
                              ),
                            ),
                            Text(
                              '${connected.length} of ${devices.length} online',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: AppColors.subtext),
                            ),
                          ],
                        ),
                        _AddDeviceButton(),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Device list
            devices.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Column(
                        children: [
                          Icon(Icons.devices_other_rounded,
                              size: 64,
                              color: AppColors.subtext.withOpacity(0.35)),
                          const SizedBox(height: 16),
                          Text(
                            'No devices found',
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: AppColors.subtext),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDim.lg),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DeviceCard(device: devices[i]),
                        ),
                        childCount: devices.length,
                      ),
                    ),
                  ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

// ── Network Banner ─────────────────────────────────────────────────────────────
class _NetworkBanner extends StatelessWidget {
  const _NetworkBanner({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDim.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDim.rLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Network',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.7), fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success, shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Connected · WPA3 Secured',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.85), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.wifi_rounded, color: Colors.white, size: 68),
        ],
      ),
    );
  }
}

// ── Add Device Button ──────────────────────────────────────────────────────────
class _AddDeviceButton extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AddDeviceButton> createState() => _AddDeviceButtonState();
}

class _AddDeviceButtonState extends ConsumerState<_AddDeviceButton> {
  void _show() {
    DeviceType selected = DeviceType.other;
    final nameCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final dark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(builder: (_, set) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: dark ? AppColors.cardDark : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.subtext.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Add New Device',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: dark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Device Name',
                      hintText: 'e.g. Living Room TV',
                      prefixIcon: const Icon(Icons.devices_rounded,
                          color: AppColors.subtext),
                      filled: true,
                      fillColor:
                          dark ? AppColors.darkBg : AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Device Type',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: dark ? Colors.white70 : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: DeviceType.values.map((t) {
                      final sel = t == selected;
                      final dummy = Device(
                        id: '', name: '', macAddress: '',
                        ipAddress: '', type: t, isConnected: true,
                        signalStrength: 0, connectedAt: DateTime.now(),
                      );
                      return GestureDetector(
                        onTap: () => set(() => selected = t),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primary
                                : (dark
                                    ? AppColors.darkBg
                                    : AppColors.background),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.subtext.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(dummy.icon,
                                  size: 15,
                                  color: sel
                                      ? Colors.white
                                      : AppColors.subtext),
                              const SizedBox(width: 5),
                              Text(
                                dummy.typeLabel,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: sel
                                      ? Colors.white
                                      : AppColors.subtext,
                                  fontWeight: sel
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.trim().isNotEmpty) {
                        ref.read(devicesProvider.notifier).add(
                              Device(
                                id: 'd${DateTime.now().millisecondsSinceEpoch}',
                                name: nameCtrl.text.trim(),
                                macAddress: 'XX:XX:XX:XX:XX:XX',
                                ipAddress:
                                    '192.168.1.${110 + (DateTime.now().millisecond % 40)}',
                                type: selected,
                                isConnected: true,
                                signalStrength: 0.75,
                                connectedAt: DateTime.now(),
                              ),
                            );
                        Navigator.of(ctx).pop();
                      }
                    },
                    child: const Text('Add Device'),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _show,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'Assets/plus.png',
              width: 16,
              height: 16,
              color: Colors.white,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.add_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 6),
            Text(
              'Add Device',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}