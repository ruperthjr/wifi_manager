import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../models/device.dart';
import '../providers/devices_provider.dart';

class DeviceCard extends ConsumerWidget {
  const DeviceCard({super.key, required this.device});
  final Device device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifier = ref.read(devicesProvider.notifier);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(AppDim.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(AppDim.rMd),
        border: device.isFavorited
            ? Border.all(
                color: AppColors.warning.withOpacity(0.55), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (device.isConnected
                      ? AppColors.primary
                      : AppColors.subtext)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              device.icon,
              color: device.isConnected
                  ? AppColors.primary
                  : AppColors.subtext,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        device.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? Colors.white : AppColors.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (device.isFavorited)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.star_rounded,
                            color: AppColors.warning, size: 13),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${device.typeLabel} · ${device.ipAddress}',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.subtext),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: device.isConnected
                            ? AppColors.success
                            : AppColors.subtext,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      device.isConnected ? 'Connected' : 'Offline',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: device.isConnected
                            ? AppColors.success
                            : AppColors.subtext,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _SignalBars(
                        bars: device.signalBars,
                        active: device.isConnected),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionBtn(
                icon: device.isFavorited
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: device.isFavorited
                    ? AppColors.warning
                    : AppColors.subtext,
                bgColor: device.isFavorited
                    ? AppColors.warning.withOpacity(0.15)
                    : AppColors.subtext.withOpacity(0.08),
                onTap: () => notifier.toggleFavorite(device.id),
              ),
              const SizedBox(height: 6),
              _ActionBtn(
                icon: device.isConnected
                    ? Icons.wifi_rounded
                    : Icons.wifi_off_rounded,
                color: device.isConnected
                    ? AppColors.success
                    : AppColors.subtext,
                bgColor: device.isConnected
                    ? AppColors.success.withOpacity(0.12)
                    : AppColors.subtext.withOpacity(0.08),
                onTap: () => notifier.toggle(device.id),
              ),
              const SizedBox(height: 6),
              _ActionBtn(
                icon: Icons.delete_outline_rounded,
                color: AppColors.error,
                bgColor: AppColors.error.withOpacity(0.08),
                onTap: () => notifier.remove(device.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      );
}

class _SignalBars extends StatelessWidget {
  const _SignalBars({required this.bars, required this.active});
  final int bars;
  final bool active;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(4, (i) {
          final filled = active && i < bars;
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Container(
              width: 3,
              height: 5.0 + i * 3,
              decoration: BoxDecoration(
                color: filled
                    ? AppColors.secondary
                    : AppColors.subtext.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          );
        }),
      );
}