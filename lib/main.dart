import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/features/auth/data/app_lock_service.dart';
import 'package:all_benefits_group/features/auth/data/auth_service.dart';
import 'package:all_benefits_group/features/auth/data/biometric_auth_service.dart';
import 'package:all_benefits_group/features/auth/presentation/lock_screen.dart';
import 'package:all_benefits_group/features/splash/presentation/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // App va a background → guardar timestamp
      debugPrint('🌙 [Lifecycle] App a background');
      await AppLockService.recordBackgroundTime();
    } else if (state == AppLifecycleState.resumed) {
      // App vuelve a foreground → verificar si debe bloquearse
      debugPrint('☀️ [Lifecycle] App a foreground');
      await _checkLock();
    }
  }

  Future<void> _checkLock() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) return;

    final shouldLock = await AppLockService.shouldLock();
    final hasBio = await BiometricAuthService.canCheckBiometrics();

    debugPrint('🔒 [Lock] shouldLock=$shouldLock, hasBio=$hasBio');

    if (shouldLock && hasBio) {
      final context = _navigatorKey.currentContext;
      if (context != null && context.mounted) {
        // Verificar que no estemos ya en la LockScreen
        final currentRoute = ModalRoute.of(context);
        if (currentRoute?.settings.name != '/lock') {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/lock'),
              builder: (_) => const LockScreen(),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'USA All Benefits Group',
      navigatorKey: _navigatorKey,
      theme: AppTheme.light(),
      home: const SplashPage(),
    );
  }
}
