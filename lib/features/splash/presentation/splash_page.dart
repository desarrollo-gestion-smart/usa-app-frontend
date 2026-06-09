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
    // Mostrar splash al menos 1.5 segundos
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final isLoggedIn = await AuthService.isLoggedIn();
    debugPrint('🔐 [Splash] isLoggedIn=$isLoggedIn');

    if (!isLoggedIn) {
      // No hay sesión → onboarding
      _goTo(const OnboardingWelcomePage());
      return;
    }

    // Hay sesión activa. Verificar si se ofrece biometría
    final shouldUseBio = await BiometricAuthService.shouldOfferBiometricLogin();
    debugPrint('🔐 [Splash] shouldOfferBiometricLogin=$shouldUseBio');

    if (shouldUseBio) {
      // Pedir biometría
      final didAuth = await BiometricAuthService.authenticate();
      debugPrint('🔐 [Splash] Biometric auth result: $didAuth');

      if (!mounted) return;

      if (didAuth) {
        // Biometría exitosa → auto-login con credenciales guardadas
        await _performAutoLogin();
        return;
      }
      // Biometría fallida o cancelada → ir a login manual
      _goTo(const StartedLoginsPage());
      return;
    }

    // Hay sesión pero no hay biometría disponible
    // → ir a login manual para que el usuario entre con email/pass
    _goTo(const StartedLoginsPage());
  }

  Future<void> _performAutoLogin() async {
    try {
      final savedEmail = await BiometricAuthService.getSavedEmail();
      final savedPassword = await BiometricAuthService.getSavedPassword();

      if (savedEmail == null || savedPassword == null || savedEmail.isEmpty || savedPassword.isEmpty) {
        debugPrint('❌ [Splash] No hay credenciales guardadas para auto-login');
        if (!mounted) return;
        _goTo(const StartedLoginsPage());
        return;
      }

      debugPrint('🟢 [Splash] Auto-login con credenciales guardadas');
      await AuthService.login(email: savedEmail, password: savedPassword);

      if (!mounted) return;

      // Obtener datos frescos del usuario
      final me = await AuthService.fetchMe();
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
        case 'client':
        case 'customer':
        case 'cliente':
          role = 'client';
          break;
        default:
          role = await AuthService.getBackendRole() ?? 'client';
      }

      debugPrint('📛 [Splash] Auto-login rol=$role, name=$userName');

      // Borrar flag de explicit logout (el usuario volvió a entrar)
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
      debugPrint('❌ [Splash] Error en auto-login: $e');
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
