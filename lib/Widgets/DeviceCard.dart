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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(AppDim.rMd),
        border: Border.all(
          color: device.isConnected
              ? AppColors.primary.withOpacity(0.25)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: device.isConnected
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.subtext.withOpacity(0.08),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              device.icon,
              color: device.isConnected ? AppColors.primary : AppColors.subtext,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

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
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: device.isConnected
                            ? AppColors.success
                            : AppColors.error,
                        shape: BoxShape.circle,
                      ),
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
                // Signal bars
                Row(
                  children: [
                    ...List.generate(4, (i) => Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 4,
                        height: 7.0 + (i * 3.5),
                        decoration: BoxDecoration(
                          color: i < device.signalBars
                              ? AppColors.secondary
                              : AppColors.subtext.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    )),
                    const SizedBox(width: 6),
                    Text(
                      '${(device.signalStrength * 100).round()}%',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Actions
          Column(
            children: [
              _ActionBtn(
                icon: device.isConnected
                    ? Icons.link_rounded
                    : Icons.link_off_rounded,
                color: device.isConnected ? AppColors.success : AppColors.error,
                onTap: () =>
                    ref.read(devicesProvider.notifier).toggle(device.id),
              ),
              const SizedBox(height: 6),
              _ActionBtn(
                assetPath: 'Assets/minus.png',
                icon: Icons.delete_outline_rounded,
                color: AppColors.error,
                onTap: () => _confirmRemove(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Remove Device',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(
          'Remove "${device.name}" from your network?',
          style: GoogleFonts.poppins(fontSize: 14, color: AppColors.subtext),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.subtext)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                minimumSize: const Size(80, 40)),
            onPressed: () {
              ref.read(devicesProvider.notifier).remove(device.id);
              Navigator.of(ctx).pop();
            },
            child: Text('Remove', style: GoogleFonts.poppins()),
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
    required this.onTap,
    this.assetPath,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(9),
        ),
        child: assetPath != null
            ? Image.asset(
                assetPath!,
                width: 15,
                height: 15,
                color: color,
                errorBuilder: (_, __, ___) =>
                    Icon(icon, size: 15, color: color),
              )
            : Icon(icon, size: 15, color: color),
      ),
    );
  }
}