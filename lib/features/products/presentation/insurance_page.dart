import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/common/widgets/calendly_webview.dart';
import 'package:all_benefits_group/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});

  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _bebeController;
  late Animation<double> _bebeAnimation;

  final List<Map<String, String>> insurances = [
    {'icon': '❤️', 'name': 'Vida'},
    {'icon': '🏥', 'name': 'Obamacare'},
    {'icon': '🚗', 'name': 'Accidente'},
    {'icon': '📋', 'name': 'Término'},
    {'icon': '👴', 'name': 'Medicare'},
    {'icon': '🏨', 'name': 'Hospitalización'},
    {'icon': '⚙️', 'name': 'Manage Care'},
    {'icon': '🚑', 'name': 'Auxilios Funerarios'},
    {'icon': '🕯️', 'name': 'Preneed'},
    {'icon': '🚙', 'name': 'Autos'},
    {'icon': '🏠', 'name': 'Casas'},
    {'icon': '🏪', 'name': 'Comercial'},
    {'icon': '👓', 'name': 'Visión'},
    {'icon': '🦷', 'name': 'Dental'},
  ];

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
                    'Seguros',
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

            // BEBE Hero + Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _bebeAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_bebeAnimation.value * 0.08),
                        child: Container(
                          width: 56,
                          height: 56,
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
                              'assets/images/bebe/seguros.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      Text(
                        'BEBE te presenta',
                        style: GoogleFonts.fredoka(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.fg,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '14 opciones de seguros para proteger\ntodo lo que importa.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.muted,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Seguros grid
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.85,
                    children: insurances
                        .asMap()
                        .entries
                        .map((entry) => _buildInsuranceItem(
                              entry.value['icon']!,
                              entry.value['name']!,
                              entry.key,
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),

            // CTA Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: GestureDetector(
                onTap: () async {
                  try {
                    final result = await AuthService.requestProductInfo(productName: 'Seguros');
                    final whatsappUrl = result['whatsappUrl'] as String?;
                    if (whatsappUrl != null && whatsappUrl.isNotEmpty) {
                      final uri = Uri.parse(whatsappUrl);
                      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                      if (!launched && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No se pudo abrir WhatsApp. Intenta desde tu navegador.')),
                        );
                      }
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Solicitud enviada. Te contactaremos pronto.')),
                      );
                    }
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
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
                  showCalendlyInline(context, title: 'Agendar reunión - Seguros');
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
                          'assets/images/bebe/seguros.png',
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
                              text: 'Toca uno para detalles y cotizar.',
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

  Widget _buildInsuranceItem(String icon, String name, int index) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to insurance detail
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.line, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: GoogleFonts.fredoka(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.fg,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
