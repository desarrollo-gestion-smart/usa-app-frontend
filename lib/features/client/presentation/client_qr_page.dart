import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientQRPage extends StatelessWidget {
  const ClientQRPage({super.key});

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
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // QR Frame placeholder
                  Container(
                    width: 168,
                    height: 168,
                    decoration: BoxDecoration(
                      color: AppTheme.paper,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.ink.withValues(alpha: 0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'QR',
                        style: GoogleFonts.fredoka(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Escanea tu ',
                    style: GoogleFonts.fredoka(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.paper,
                      letterSpacing: -0.014,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'póliza',
                      style: GoogleFonts.fredoka(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.accent,
                        letterSpacing: -0.014,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Acceso rápido a tus beneficios',
                    style: GoogleFonts.nunito(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.paper.withValues(alpha: 0.62),
                      height: 1.55,
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
