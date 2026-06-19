import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/common/widgets/calendly_webview.dart';
import 'package:all_benefits_group/features/auth/data/auth_service.dart';
import 'package:all_benefits_group/features/products/presentation/accidentes_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/autos_camiones_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/casas_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/comercial_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/dental_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/poliza_cancer_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/preneed_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/funeral_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/hospitalizacion_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/medicare_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/morgue_protection_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/obamacare_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/vida_detail_page.dart';
import 'package:all_benefits_group/features/products/presentation/vision_detail_page.dart';
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
    {'icon': '❤️', 'name': 'Vida', 'description': 'La tranquilidad de tu familia empieza con una buena decisión hoy.'},
    {'icon': '🏥', 'name': 'Obamacare', 'description': 'Cobertura médica accessible para ti y tu familia.'},
    {'icon': '⚠️', 'name': 'Accidentes', 'description': 'Un accidente puede pasar en segundos; tu respaldo y apoyo debe estar listo.'},
    {'icon': '📋', 'name': 'Mortgage Protection', 'description': 'Que una tragedia no ponga en riesgo el hogar de los tuyos.'},
    {'icon': '👴', 'name': 'Medicare', 'description': 'Tu salud merece una cobertura que se ajuste a tus necesidades.'},
    {'icon': '🏨', 'name': 'Hospitalización', 'description': 'Una hospitalización puede ser inesperada; tu respaldo no debería serlo.'},
    {'icon': '🪦', 'name': 'Seguros Funerarios', 'description': 'Tranquilidad para tu familia en momentos difíciles.'},
    {'icon': '🕯️', 'name': 'Preneed', 'description': 'Un acto de amor también es dejar todo organizado.'},
    {'icon': '🚙', 'name': 'Autos y Camiones', 'description': 'Protege tu vehículo, tu bolsillo y tu responsabilidad en la carretera.'},
    {'icon': '🏠', 'name': 'Casas', 'description': 'Protege lo que tanto esfuerzo te ha costado construir.'},
    {'icon': '🏪', 'name': 'Comercial', 'description': 'Un imprevisto no debería detener lo que has construido, protege tu empresa, tus clientes y tus empleados.'},
    {'icon': '🎗️', 'name': 'Póliza de Cáncer', 'description': 'Un diagnóstico difícil no debería llegar sin respaldo económico.'},
    {'icon': '👓', 'name': 'Visión', 'description': 'Ver bien también es parte de cuidar tu salud y calidad de vida.'},
    {'icon': '🦷', 'name': 'Dental', 'description': 'Cuida tu salud y sonríe con tranquilidad.'},
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

            // Seguros list
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: insurances
                        .asMap()
                        .entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildInsuranceItem(
                                entry.value['icon']!,
                                entry.value['name']!,
                                entry.value['description']!,
                                onTap: entry.value['name'] == 'Vida'
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const VidaDetailPage(),
                                          ),
                                        );
                                      }
                                    : entry.value['name'] == 'Obamacare'
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => const ObamacareDetailPage(),
                                              ),
                                            );
                                          }
                                        : entry.value['name'] == 'Accidentes'
                                            ? () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => const AccidentesDetailPage(),
                                                  ),
                                                );
                                              }
                                            : entry.value['name'] == 'Medicare'
                                                ? () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => const MedicareDetailPage(),
                                                      ),
                                                    );
                                                  }
                                                : entry.value['name'] == 'Hospitalización'
                                                    ? () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) => const HospitalizacionDetailPage(),
                                                          ),
                                                        );
                                                      }
                                                    : entry.value['name'] == 'Autos y Camiones'
                                                        ? () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) => const AutosCamionesDetailPage(),
                                                              ),
                                                            );
                                                          }
                                                         : entry.value['name'] == 'Mortgage Protection'
                                             ? () {
                                                 Navigator.push(
                                                   context,
                                                   MaterialPageRoute(
                                                     builder: (_) => const MortgageProtectionDetailPage(),
                                                   ),
                                                 );
                                               }
                                              : entry.value['name'] == 'Preneed'
                                                  ? () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => const PreneedDetailPage(),
                                                        ),
                                                      );
                                                    }
                                              : entry.value['name'] == 'Casas'
                                                  ? () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => const CasasDetailPage(),
                                                        ),
                                                      );
                                                     }
                                              : entry.value['name'] == 'Comercial'
                                                  ? () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => const ComercialDetailPage(),
                                                        ),
                                                      );
                                                     }
                                              : entry.value['name'] == 'Póliza de Cáncer'
                                                  ? () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => const PolizaCancerDetailPage(),
                                                        ),
                                                      );
                                                    }
                                        : entry.value['name'] == 'Dental'
                                          ? () {
                                              Navigator.push(
                                                context,
                                               MaterialPageRoute(
                                                 builder: (_) => const DentalDetailPage(),
                                               ),
                                             );
                                           }
                                        : entry.value['name'] == 'Visión'
                                            ? () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => const VisionDetailPage(),
                                                  ),
                                                );
                                              }
                                            : entry.value['name'] == 'Seguros Funerarios'
                                                ? () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => const FuneralDetailPage(),
                                                      ),
                                                    );
                                                  }
                                                : null,
                              ),
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
                  final msg = Uri.encodeComponent('Hola, me gustaría recibir información sobre seguros funerarios.');
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

  Widget _buildInsuranceItem(String icon, String name, String description, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {
        _showInsuranceDetail(context, icon, name, description);
      },
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
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.fredoka(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.fg,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.muted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInsuranceDetail(BuildContext context, String icon, String name, String description) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: GoogleFonts.fredoka(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.fg,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        description,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.fg,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'CERRAR',
                    style: GoogleFonts.fredoka(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
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
