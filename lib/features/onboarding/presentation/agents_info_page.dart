import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgentsInfoPage extends StatelessWidget {
  final Map<String, dynamic>? sellerData;

  const AgentsInfoPage({super.key, this.sellerData});

  String get _sellerName => sellerData?['name'] ?? 'Vendedor';
  String? get _sellerTitle => sellerData?['title'];
  String? get _sellerPosition => sellerData?['position'];
  String? get _sellerDesc => sellerData?['description'];
  String? get _sellerLocation => sellerData?['location'];
  String? get _sellerPhoto => sellerData?['foto'];
  double? get _sellerRating => (sellerData?['rating'] as num?)?.toDouble();
  List<String> get _sellerSpecialties {
    final raw = sellerData?['specialties'];
    if (raw is List) {
      return raw.whereType<String>().toList();
    }
    return [];
  }

  String _specialtyEmoji(String specialty) {
    final lower = specialty.toLowerCase();
    if (lower.contains('seguro')) return '🛡️';
    if (lower.contains('finanza')) return '💰';
    if (lower.contains('tax')) return '📋';
    if (lower.contains('crédito') || lower.contains('credito')) return '💳';
    if (lower.contains('inmigracion') || lower.contains('inmigración')) return '🌎';
    if (lower.contains('real') || lower.contains('bienes')) return '🏠';
    if (lower.contains('prestamo') || lower.contains('préstamo')) return '🏦';
    if (lower.contains('academia') || lower.contains('curso')) return '🎓';
    if (lower.contains('compañía') || lower.contains('compania') || lower.contains('llc')) return '🏢';
    if (lower.contains('notario')) return '⚖️';
    if (lower.contains('marketing') || lower.contains('redes')) return '📱';
    if (lower.contains('venta')) return '🤝';
    if (lower.contains('payroll') || lower.contains('nómina')) return '💵';
    if (lower.contains('bookkeeping') || lower.contains('contabilidad')) return '📚';
    if (lower.contains('anualidad')) return '📈';
    return '✅';
  }

  String get _initials {
    final name = _sellerName;
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, min(2, name.length)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF3D2817),
                  const Color(0xFF1A1A1A),
                  const Color(0xFF0F0F0F),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Additional radial gradient for more depth
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.5, -0.5),
                radius: 1.5,
                colors: [
                  AppTheme.accent.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        '← Atrás',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                          letterSpacing: 0.22,
                        ),
                      ),
                    ),
                    Text(
                      'ACCESO RÁPIDO POR QR · TU',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accent,
                        letterSpacing: 0.22,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.line,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Container(
                      height: 4,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Agent Hero
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _sellerPhoto != null && _sellerPhoto!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                _sellerPhoto!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildInitialsFallback(),
                              ),
                            )
                          : _buildInitialsFallback(),
                    ),
                    const SizedBox(height: 14),
                    // Agent info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _sellerName,
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.012,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'AGENTE CERTIFICADO · USA\nBENEFITS',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_sellerDesc != null && _sellerDesc!.isNotEmpty)
                          Text(
                            _sellerDesc!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 1.45,
                            ),
                          )
                        else
                          Text(
                            'Asesor certificado listo para ayudarte con tus beneficios.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 1.45,
                            ),
                          ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ],
                ),
              ),
              // Trust Metrics
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      color: Colors.white30,
                    ),
                    const SizedBox(height: 12),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _sellerLocation?.toUpperCase() ?? 'USA',
                              style: GoogleFonts.fredoka(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'SERVICIO\nACTIVO',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white30,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: const Offset(15, -10),
                              child: Text(
                                '⭐',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '4.9/5',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.accent,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '50+ CLIENTES',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white30,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: const Offset(5, -12),
                              child: Text(
                                '✓',
                                style: GoogleFonts.fredoka(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'RESPONDE',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'TIPICAMENTE\nEN 2H',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Specialties Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1F15),
                    border: Border.all(color: const Color(0xFFCCCCCC), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ESPECIALIDADES',
                        style: GoogleFonts.fredoka(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _sellerSpecialties.isEmpty
                          ? Text(
                              'Sin especialidades registradas',
                              style: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            )
                          : Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: _sellerSpecialties.map((s) {
                                return Text(
                                  '${_specialtyEmoji(s)} ${s[0].toUpperCase()}${s.substring(1)}',
                                  style: GoogleFonts.nunito(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // BEBE Tip
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color(0xFF666666),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/bebe/notario-avatar.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '"BEBE aquí-conecta con ',
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: _sellerName.split(' ').first,
                                style: GoogleFonts.fredoka(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: ' para hablar de tus opciones."',
                                style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
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
              const SizedBox(height: 42),
              // Contact Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildContactButton(
                      icon: '💬',
                      label: 'WhatsApp',
                      onTap: () {
                        // TODO: Open WhatsApp with _sellerWhatsapp
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildContactButton(
                      icon: '📧',
                      label: 'Email',
                      onTap: () {
                        // TODO: Open email with _sellerEmail
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsFallback() {
    return Center(
      child: Text(
        _initials,
        style: GoogleFonts.fredoka(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  int min(int a, int b) => a < b ? a : b;

  Widget _buildContactButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.accent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentDark,
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.fredoka(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppTheme.paper,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
