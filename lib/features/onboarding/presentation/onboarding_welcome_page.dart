import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/features/onboarding/presentation/client_info_page.dart';
import 'package:all_benefits_group/features/onboarding/presentation/started_logins_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingWelcomePage extends StatefulWidget {
  const OnboardingWelcomePage({super.key});

  @override
  State<OnboardingWelcomePage> createState() => _OnboardingWelcomePageState();
}

class _OnboardingWelcomePageState extends State<OnboardingWelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      body: SafeArea(
        child: Stack(
          children: [
            // Bloom background
            Positioned(
              top: -100,
              left: 0,
              right: 0,
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.5, -0.3),
                    radius: 1.2,
                    colors: [
                      AppTheme.accent.withValues(alpha: 0.28),
                      AppTheme.accent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            // Skip button fixed top right
            Positioned(
              top: 22,
              right: 22,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const StartedLoginsPage(),
                    ),
                  );
                },
                child: Text(
                  'SALTAR',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.paper.withValues(alpha: 0.45),
                    letterSpacing: 0.22,
                  ),
                ),
              ),
            ),
            // Content
            Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // USA Logo
                      Image.asset(
                        'assets/images/new-logo.png',
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 4),
                      // Floating BEBE
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_floatAnimation.value),
                            child: child,
                          );
                        },
                        child: Image.asset(
                          'assets/images/bebe-university.png',
                          width: 220,
                          height: 220,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Todos tus Beneficios en ',
                            style: GoogleFonts.fredoka(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.paper,
                              letterSpacing: -0.018,
                            ),
                            children: [
                              TextSpan(
                                text: 'una sola app',
                                style: GoogleFonts.fredoka(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.accent,
                                  letterSpacing: -0.018,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Finanzas, taxes, academia, inmigración, compañías, crédito, real estate, préstamos. BEBE te lleva uno por uno.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.paper.withValues(alpha: 0.66),
                            height: 1.55,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Step indicator
                      Text(
                        'PASO 1 / 4',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.paper.withValues(alpha: 0.55),
                          letterSpacing: 0.22,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Step dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 22,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppTheme.accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppTheme.paper.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppTheme.paper.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Bottom CTA + Skip link
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ClientInfoPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentDark,
                                offset: const Offset(0, 5),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'COMENZAR CON BEBE',
                                style: GoogleFonts.fredoka(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.paper,
                                  letterSpacing: 0.10,
                                ),
                              ),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppTheme.paper,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '→',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.accent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const StartedLoginsPage(skipQuestions: true),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.paper,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.accent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'Iniciar sesión o registrarse',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.accent,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
