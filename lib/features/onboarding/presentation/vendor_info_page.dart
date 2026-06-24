import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/features/onboarding/presentation/student_info_page.dart';
import 'package:all_benefits_group/features/onboarding/presentation/started_logins_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorInfoPage extends StatelessWidget {
  const VendorInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: Icon(
                              Icons.arrow_back,
                              color: AppTheme.fg,
                              size: 24,
                            ),
                          ),
                          Text(
                            'PASO 3 / 4',
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accent,
                              letterSpacing: 0.22,
                            ),
                          ),
                          const SizedBox(width: 24),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppTheme.line,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.75,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppTheme.accent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Hero Bebe
                      Hero(
                        tag: 'bebe-vendor',
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.accent, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accent.withValues(alpha: 0.25),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/bebe/finanzas-bebe.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        'Tu espacio como Vendedor',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.fg,
                          letterSpacing: -0.012,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Summary
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9F5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow(
                              icon: Icons.check_circle_outline,
                              text: 'Vende finanzas, taxes, crédito y más beneficios. Gana comisiones por cada cliente que traes.',
                            ),
                            const Divider(height: 24, color: AppTheme.line),
                            _buildSummaryRow(
                              icon: Icons.check_circle_outline,
                              text: 'Usa tu código QR personalizado para captar clientes fácil y rápido.',
                            ),
                            const Divider(height: 24, color: AppTheme.line),
                            _buildSummaryRow(
                              icon: Icons.check_circle_outline,
                              text: 'Crecimiento real: de agente a líder. Capacitación continua y soporte dedicado.',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Bebe bubble
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.accent, width: 2),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/bebe/finanzas-bebe.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.surface,
                                border: Border.all(color: AppTheme.line, width: 1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Text(
                                'BEBE: "Mientras más ayudes, más ganas. Tu éxito empieza cuando decides crecer con nosotros."',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.fg,
                                  height: 1.4,
                                ),
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

            // CTA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
              color: AppTheme.paper,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const StudentInfoPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CONTINUAR AL PASO 4',
                            style: GoogleFonts.fredoka(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.paper,
                              letterSpacing: 0.10,
                            ),
                          ),
                          const SizedBox(width: 8),
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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const StartedLoginsPage(skipQuestions: true),
                        ),
                      );
                    },
                    child: Text(
                      'SALTAR',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.muted,
                        letterSpacing: 0.22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.accent,
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.fg,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
