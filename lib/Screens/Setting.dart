import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/network_provider.dart';
import '../Widgets/Aboutme.dart';
import '../Widgets/LicenseWidget.dart';
import '../Widgets/FadeRoute.dart';
import 'Login.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark      = ref.watch(themeProvider);
    final auth        = ref.watch(authProvider);
    final networkName = ref.watch(networkNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDim.lg),
        children: [
          _ProfileCard(auth: auth),
          const SizedBox(height: 28),

          _SectionLabel('Network'),
          const SizedBox(height: 10),
          _Tile(
            icon: Icons.wifi_rounded,
            iconColor: AppColors.primary,
            title: 'Network Name',
            subtitle: networkName,
            onTap: () => _editName(context, ref, networkName),
          ),
          const SizedBox(height: 8),
          _Tile(
            icon: Icons.security_rounded,
            iconColor: AppColors.secondary,
            title: 'Security Protocol',
            subtitle: 'WPA3 Encrypted',
            trailing: _Badge('Secure', AppColors.success),
          ),
          const SizedBox(height: 28),

          _SectionLabel('Appearance'),
          const SizedBox(height: 10),
          _Tile(
            icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            iconColor: isDark ? AppColors.purple : AppColors.warning,
            title: 'Dark Mode',
            subtitle: isDark ? 'Enabled' : 'Disabled',
            trailing: Switch.adaptive(
              value: isDark,
              activeColor: AppColors.primary,
              onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
            ),
          ),
          const SizedBox(height: 28),

          _SectionLabel('About'),
          const SizedBox(height: 10),
          _Tile(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.primary,
            title: 'About NestNet',
            subtitle: 'Version 1.0.0',
            onTap: () => showDialog(
              context: context,
              builder: (_) => const AboutMeDialog(),
            ),
          ),
          const SizedBox(height: 8),
          _Tile(
            icon: Icons.description_outlined,
            iconColor: AppColors.subtext,
            title: 'Open Source Licenses',
            subtitle: 'View all licenses',
            onTap: () => showDialog(
              context: context,
              builder: (_) => const LicenseDialog(),
            ),
          ),
          const SizedBox(height: 28),

          _SectionLabel('Account'),
          const SizedBox(height: 10),
          _Tile(
            icon: Icons.logout_rounded,
            iconColor: AppColors.error,
            title: 'Sign Out',
            subtitle: 'Log out of ${auth.user?.email ?? 'your account'}',
            onTap: () {
              ref.read(authProvider.notifier).logout();
              Navigator.of(context).pushAndRemoveUntil(
                FadeRoute(page: const LoginScreen()),
                (_) => false,
              );
            },
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _editName(BuildContext context, WidgetRef ref, String current) {
    final ctrl = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Network Name',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Enter network name',
            prefixIcon: const Icon(Icons.wifi_rounded),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.subtext)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 42)),
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(networkNameProvider.notifier).state =
                    ctrl.text.trim();
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.auth});
  final AuthState auth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDim.rLg),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              auth.user?.initials ?? 'U',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.user?.fullName ?? 'User',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  auth.user?.email ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Admin',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.subtext,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 11, fontWeight: FontWeight.w600, color: color),
        ),
      );
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDim.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(AppDim.rMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.subtext),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? const Icon(Icons.chevron_right_rounded,
                        color: AppColors.subtext, size: 20)
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}