import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BenefitItemData {
  final String imagePath;
  final String title;
  final String description;

  const BenefitItemData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class BenefitDetailPage extends StatelessWidget {
  final String title;
  final String coverPath;
  final String bebeMessage;
  final String bebeImagePath;
  final List<BenefitItemData> items;
  final String ctaText;
  final String servicesText;
  final String productName;
  final VoidCallback? onServicesTap;

  const BenefitDetailPage({
    super.key,
    required this.title,
    required this.coverPath,
    required this.bebeMessage,
    this.bebeImagePath = 'assets/images/bebe/notario-avatar.png',
    required this.items,
    this.ctaText = 'CONTACTANOS',
    this.servicesText = 'Ver servicios disponibles',
    required this.productName,
    this.onServicesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: AppTheme.muted,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Atrás',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cover
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        coverPath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const SizedBox(height: 16),

                    // BEBE bubble with overlapping image
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 12, top: 24),
                          padding: const EdgeInsets.fromLTRB(90, 18, 20, 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5ED),
                            border: Border.all(color: AppTheme.accent, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'BEBE: ',
                              style: GoogleFonts.fredoka(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.accent,
                              ),
                              children: [
                                TextSpan(
                                  text: bebeMessage,
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.fg,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 4,
                          child: Image.asset(
                            bebeImagePath,
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Items image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        items.first.imagePath,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Services button
                    GestureDetector(
                      onTap: onServicesTap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.accent, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              color: AppTheme.accent,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              servicesText,
                              style: GoogleFonts.fredoka(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.accent,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
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
