import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../Widgets/BouncingRoute.dart';
import '../Widgets/FadeRoute.dart';
import 'SignUp.dart';
import 'DashBoard.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure    = true;

  late final AnimationController _ac = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 900),
  )..forward();
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.25), end: Offset.zero,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));
  late final Animation<double> _fade = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(parent: _ac, curve: Curves.easeIn));

  @override
  void dispose() {
    _ac.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authProvider.notifier)
        .login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    if (ok && mounted) {
      Navigator.of(context)
          .pushReplacement(FadeRoute(page: const DashboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth  = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDim.lg),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // Logo
                    Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.wifi_rounded,
                            color: Colors.white, size: 42),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Text(
                      'Welcome back 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to manage your home network',
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.subtext),
                    ),
                    const SizedBox(height: 36),

                    _Label('Email Address', isDark: isDark),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'you@example.com',
                        prefixIcon: Icon(Icons.email_outlined, color: AppColors.subtext),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    _Label('Password', isDark: isDark),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.subtext),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.subtext,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'At least 6 characters required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          AppStrings.forgotPassword,
                          style: GoogleFonts.poppins(
                              color: AppColors.primary, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    if (auth.error != null) ...[
                      const SizedBox(height: 4),
                      _ErrorBanner(auth.error!),
                      const SizedBox(height: 12),
                    ] else
                      const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: auth.isLoading ? null : _login,
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Sign In'),
                    ),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.noAccount,
                            style: GoogleFonts.poppins(
                                color: AppColors.subtext, fontSize: 14)),
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .push(BouncingRoute(page: const SignUpScreen())),
                          child: Text(
                            AppStrings.signUp,
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class _Label extends StatelessWidget {
  const _Label(this.text, {required this.isDark});
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white70 : AppColors.textDark,
        ),
      );
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner(this.message);
  final String message;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.error.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 17),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                    color: AppColors.error, fontSize: 13),
              ),
            ),
          ],
        ),
      );
}