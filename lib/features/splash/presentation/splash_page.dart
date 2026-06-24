import 'package:all_benefits_group/features/auth/data/auth_service.dart';
import 'package:all_benefits_group/features/auth/data/biometric_auth_service.dart';
import 'package:all_benefits_group/features/dashboard/presentation/student_home_page.dart';
import 'package:all_benefits_group/features/dashboard/presentation/user_home_page.dart';
import 'package:all_benefits_group/features/onboarding/presentation/onboarding_welcome_page.dart';
import 'package:all_benefits_group/features/onboarding/presentation/started_logins_page.dart';
import 'package:all_benefits_group/features/vendor/presentation/vendor_dashboard_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final isLoggedIn = await AuthService.isLoggedIn();
    debugPrint('🔐 [Splash] isLoggedIn=$isLoggedIn');

    if (!isLoggedIn) {
      _goTo(const OnboardingWelcomePage());
      return;
    }

    final canBio = await BiometricAuthService.canCheckBiometrics();
    final quickStart = await BiometricAuthService.isQuickStartEnabled();
    final wasExplicit = await BiometricAuthService.wasExplicitlyLoggedOut();
    debugPrint('🔐 [Splash] canBio=$canBio, quickStart=$quickStart, wasExplicit=$wasExplicit');

    if (!canBio) {
      await _goToHomeWithExistingSession();
      return;
    }

    if (quickStart && !wasExplicit) {
      final didAuth = await BiometricAuthService.authenticate();
      if (!mounted) return;

      if (didAuth) {
        await _goToHomeWithExistingSession();
        return;
      }

      _goTo(const StartedLoginsPage());
      return;
    }

    _goTo(const StartedLoginsPage());
  }

  Future<void> _goToHomeWithExistingSession() async {
    try {
      final me = await AuthService.fetchMe();
      if (!mounted) return;

      final userName = (me['name'] as String?) ??
          (me['user'] is Map ? me['user']['name'] as String? : null) ??
          'Usuario';

      String? rawRole;
      if (me.containsKey('role')) {
        rawRole = me['role'] as String?;
      } else if (me['user'] is Map && (me['user'] as Map).containsKey('role')) {
        rawRole = me['user']['role'] as String?;
      }

      String role;
      switch (rawRole?.toLowerCase()) {
        case 'seller':
        case 'usuario':
        case 'vendedor':
          role = 'seller';
          break;
        case 'student':
        case 'estudiante':
          role = 'student';
          break;
        default:
          role = 'client';
      }

      await BiometricAuthService.clearExplicitLogout();
      if (!mounted) return;

      if (role == 'seller') {
        _goTo(const VendorDashboardPage());
      } else if (role == 'student') {
        _goTo(StudentHomePage(userName: userName));
      } else {
        _goTo(UserHomePage(userName: userName));
      }
    } catch (e) {
      debugPrint('❌ [Splash] Error al recuperar sesión: $e');
      if (!mounted) return;
      _goTo(const StartedLoginsPage());
    }
  }

  void _goTo(Widget page) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/new-logo.png',
          width: 280,
          height: 280,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
