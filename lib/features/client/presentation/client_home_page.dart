import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: Column(
          children: [
            // Header con saludo y notificación
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.fg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'J',
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.paper,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CLIENTE',
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.muted,
                            letterSpacing: 0.20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Juan Pérez',
                          style: GoogleFonts.fredoka(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.fg,
                            letterSpacing: -0.01,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.line, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: AppTheme.fg,
                            size: 18,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: AppTheme.accent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.surface,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                child: Column(
                  children: [
                    // Protection card
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.fg,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MI PROTECCIÓN',
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.paper.withValues(alpha: 0.55),
                              letterSpacing: 0.20,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Cobertura Familia',
                            style: GoogleFonts.fredoka(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.paper,
                              letterSpacing: -0.01,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppTheme.paper.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 72,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppTheme.accent,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '72% ACTIVA',
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.paper.withValues(alpha: 0.55),
                              letterSpacing: 0.16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Editorial cards
                    _EditorialCard(
                      marker: true,
                      kicker: 'BENEFICIO',
                      title: 'Sonrisa segura con ',
                      titleHighlight: 'dental',
                      description: 'Acceso a red de dentistas',
                      price: '\$25/mes',
                    ),
                    const SizedBox(height: 10),
                    _EditorialCard(
                      marker: true,
                      kicker: 'PRODUCTO',
                      title: 'Hipoteca ',
                      titleHighlight: 'segura',
                      description: 'Protege tu crédito inmobiliario',
                      price: '\$45/mes',
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
}

class _EditorialCard extends StatelessWidget {
  final bool marker;
  final String kicker;
  final String title;
  final String titleHighlight;
  final String description;
  final String price;

  const _EditorialCard({
    required this.marker,
    required this.kicker,
    required this.title,
    required this.titleHighlight,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.line, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (marker)
            Container(
              width: 6,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          if (marker) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kicker,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.muted,
                    letterSpacing: 0.20,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    text: title,
                    style: GoogleFonts.fredoka(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.fg,
                      letterSpacing: -0.012,
                    ),
                    children: [
                      TextSpan(
                        text: titleHighlight,
                        style: GoogleFonts.fredoka(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.accent,
                          letterSpacing: -0.012,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.nunito(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.muted,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.fg,
                    letterSpacing: 0.06,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
