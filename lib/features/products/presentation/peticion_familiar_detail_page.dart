import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeticionFamiliarDetailPage extends StatelessWidget {
  const PeticionFamiliarDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                      'Petición Familiar',
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.fg,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 32),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFF880E4F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('👨‍👩‍👧‍👦', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    Text(
                      'PETICIÓN FAMILIAR',
                      style: GoogleFonts.fredoka(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Reunificación familiar',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'REUNIFICACIÓN LEGAL',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: AppTheme.accent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '¿Qué es?',
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.fg,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'La petición familiar permite que ciudadanos o residentes permanentes puedan solicitar a ciertos familiares elegibles para iniciar un proceso migratorio. Este servicio ayuda a revisar la relación familiar, documentos de soporte y requisitos necesarios para preparar el caso de forma organizada.',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.fg,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppTheme.good.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.star_outline,
                            color: AppTheme.good,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Beneficios',
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.fg,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem(
                      icon: Icons.people_outline,
                      text: 'Revisión de elegibilidad familiar',
                    ),
                    const SizedBox(height: 12),
                    _buildBenefitItem(
                      icon: Icons.folder_outlined,
                      text: 'Organización de documentos personales y familiares',
                    ),
                    const SizedBox(height: 12),
                    _buildBenefitItem(
                      icon: Icons.description_outlined,
                      text: 'Preparación del paquete de solicitud',
                    ),
                    const SizedBox(height: 12),
                    _buildBenefitItem(
                      icon: Icons.support_outlined,
                      text: 'Acompañamiento durante el proceso',
                    ),
                    const SizedBox(height: 12),
                    _buildBenefitItem(
                      icon: Icons.favorite_outline,
                      text: 'Apoyo para familias que desean reunirse legalmente',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(16),
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
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'VOLVER A INMIGRACIÓN',
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
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.good.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.good,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.fg,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
