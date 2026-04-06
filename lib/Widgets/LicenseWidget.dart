import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';

class LicenseDialog extends StatelessWidget {
  const LicenseDialog({super.key});

  static const _packages = [
    _Pkg('flutter_riverpod', 'Remi Rousselet', 'MIT'),
    _Pkg('google_fonts',     'Flutter Community', 'Apache 2.0'),
    _Pkg('shared_preferences', 'Flutter Team', 'BSD-3-Clause'),
    _Pkg('cupertino_icons', 'Flutter Team', 'MIT'),
    _Pkg('flutter_lints',   'Dart Team', 'BSD-3-Clause'),
  ];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description_outlined,
                    color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Open Source Licenses',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'NestNet is built on these great packages.',
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.subtext),
            ),
            const SizedBox(height: 18),
            ..._packages.map((p) => _PkgTile(pkg: p, isDark: isDark)),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 44)),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pkg {
  const _Pkg(this.name, this.author, this.license);
  final String name;
  final String author;
  final String license;
}

class _PkgTile extends StatelessWidget {
  const _PkgTile({required this.pkg, required this.isDark});
  final _Pkg pkg;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.code_rounded,
                size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pkg.name,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                Text(
                  '${pkg.author} · ${pkg.license}',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.subtext),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}