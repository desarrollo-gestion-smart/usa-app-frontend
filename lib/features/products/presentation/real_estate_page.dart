import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/common/widgets/calendly_webview.dart';
import 'package:all_benefits_group/features/products/presentation/loan_officer_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/realtor_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class RealEstatePage extends StatefulWidget {
  const RealEstatePage({super.key});

  @override
  State<RealEstatePage> createState() => _RealEstatePageState();
}

class _RealEstatePageState extends State<RealEstatePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _bebeController;
  late Animation<double> _bebeAnimation;

  @override
  void initState() {
    super.initState();
    _bebeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();

    _bebeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bebeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bebeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: Column(
          children: [
            // Back header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppTheme.fg,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Real Estate',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.fg,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(width: 32),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  child: Column(
                    children: [
                      // BEBE Hero
                      AnimatedBuilder(
                        animation: _bebeAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_bebeAnimation.value * 0.08),
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.accent.withValues(
                                    alpha: 0.3 + (_bebeAnimation.value * 0.4),
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/bebe/realstate.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // BEBE Message
                      Column(
                        children: [
                          Text(
                            'BEBE TE GUÍA',
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.muted,
                              letterSpacing: 0.22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'De renta a propietario — tu camino comienza aquí',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.fg,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Real Estate options
                      _buildRealEstateOption(
                        icon: '🏦',
                        title: 'Loan Officer',
                        subtitle: 'Un buen financiamiento puede acercarte más a tu próxima propiedad.',
                        description: 'Un buen financiamiento puede acercarte más a tu próxima propiedad.',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoanOfficerDetailPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      _buildRealEstateOption(
                        icon: '🏡',
                        title: 'Realtor',
                        subtitle: 'No vendas ni compres solo; hazlo con orientación de principio a fin.',
                        description: 'No vendas ni compres solo; hazlo con orientación de principio a fin.',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RealtorDetailPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // CTA Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: GestureDetector(
                onTap: () async {
                  final msg = Uri.encodeComponent('Hola, me gustaría recibir información sobre real estate.');
                  final uri = Uri.parse('https://wa.me/18329076093?text=$msg');
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentDark.withValues(alpha: 0.35),
                        offset: const Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CONTACTANOS',
                        style: GoogleFonts.fredoka(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Agenda reunion Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              child: GestureDetector(
                onTap: () {
                  showCalendlyInline(context, title: 'Agendar reunión - Real Estate');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accent, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppTheme.accent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AGENDA UNA REUNION',
                        style: GoogleFonts.fredoka(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.accent,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // BEBE mini helper
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  border: Border.all(color: AppTheme.line, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.accent, width: 1.5),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/bebe/realstate.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'BEBE: ',
                          style: GoogleFonts.fredoka(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.accent,
                          ),
                          children: [
                            TextSpan(
                              text: 'Toca una opción para detalles y explorar.',
                              style: GoogleFonts.nunito(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.fg,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealEstateOption({
    required String icon,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.line, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  icon,
                  style: const TextStyle(fontSize: 36),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.fredoka(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.fg,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.muted,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      description,
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.fg,
                        height: 1.3,
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

}
