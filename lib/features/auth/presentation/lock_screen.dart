import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/features/auth/data/auth_service.dart';
import 'package:all_benefits_group/features/auth/data/biometric_auth_service.dart';
import 'package:all_benefits_group/features/auth/data/app_lock_service.dart';
import 'package:all_benefits_group/features/onboarding/presentation/started_logins_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool _isAuthenticating = false;

  Future<void> _unlock() async {
    setState(() => _isAuthenticating = true);

    final didAuth = await BiometricAuthService.authenticate();

    if (!mounted) return;

    if (didAuth) {
      debugPrint('🔓 [LockScreen] Desbloqueo exitoso');
      await AppLockService.clearBackgroundTime();
      if (!mounted) return;
      Navigator.of(context).pop(); // Sale del lock overlay
    } else {
      debugPrint('⛔ [LockScreen] Desbloqueo cancelado o fallido');
      setState(() => _isAuthenticating = false);
    }
  }

  Future<void> _logoutAndGoToLogin() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StartedLoginsPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/new-logo.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),

              // Lock icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  color: AppTheme.accent,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'App bloqueada',
                style: GoogleFonts.fredoka(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.fg,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Usa tu biometría para volver a ingresar',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.muted,
                ),
              ),
              const SizedBox(height: 40),

              // Unlock button
              GestureDetector(
                onTap: _isAuthenticating ? null : _unlock,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentDark.withValues(alpha: 0.35),
                        offset: const Offset(0, 5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fingerprint,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Desbloquear',
                        style: GoogleFonts.fredoka(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Use password instead
              TextButton(
                onPressed: _logoutAndGoToLogin,
                child: Text(
                  'Usar email y contraseña',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
