import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';

class AboutMeDialog extends StatelessWidget {
  const AboutMeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Developer avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'Assets/leo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.wifi_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
            Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.subtext),
            ),
            const SizedBox(height: 14),
            Text(
              AppStrings.tagline,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDark ? Colors.white70 : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage all devices on your home network\nwith a clean, intuitive interface.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.subtext),
            ),
            const SizedBox(height: 20),
            Divider(color: AppColors.subtext.withOpacity(0.2)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_rounded,
                    size: 14, color: AppColors.error),
                const SizedBox(width: 6),
                Text(
                  'Built with Flutter & Riverpod',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.subtext),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 44)),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}