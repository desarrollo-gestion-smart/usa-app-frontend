import 'dart:async';

import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/features/auth/data/auth_service.dart';
import 'package:all_benefits_group/features/products/presentation/benefit_detail_page.dart';
import 'package:all_benefits_group/features/products/data/benefit_config.dart';
import 'package:all_benefits_group/features/products/presentation/insurance_page.dart';
import 'package:all_benefits_group/features/products/presentation/finance_page.dart';
import 'package:all_benefits_group/features/products/presentation/taxes_page.dart';
import 'package:all_benefits_group/features/products/presentation/academia_page.dart';
import 'package:all_benefits_group/features/products/presentation/immigration_page.dart';
import 'package:all_benefits_group/features/products/presentation/companies_page.dart';
import 'package:all_benefits_group/features/products/presentation/credit_page.dart';
import 'package:all_benefits_group/features/products/presentation/real_estate_page.dart';
import 'package:all_benefits_group/features/products/presentation/loans_page.dart';
import 'package:all_benefits_group/features/products/presentation/notario_page.dart';
import 'package:all_benefits_group/features/onboarding/presentation/started_logins_page.dart';
import 'package:all_benefits_group/features/onboarding/presentation/qr_scan_page.dart';
import 'package:all_benefits_group/features/profile/presentation/profile_page.dart';
import 'package:all_benefits_group/features/client/presentation/my_services_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:all_benefits_group/common/widgets/app_image.dart';
import 'package:all_benefits_group/common/widgets/skeleton_box.dart';
import 'package:all_benefits_group/features/client/data/recommendation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHomePage extends StatefulWidget {
  final String userName;
  const UserHomePage({super.key, required this.userName});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController? _animController;
  Animation<double>? _fadeAnim;

  final List<Map<String, String>> _benefits = [
    {'name': 'Finanzas', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/w_300,q_95,f_auto/v1779113421/finanzas_tnkyan.png'},
    {'name': 'Voces de Conciencia', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/v1779113257/radio_qpadws.png'},
    {'name': 'Academia', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/w_300,q_95,f_auto/v1779113419/academia_fxpjyu.png'},
    {'name': 'Préstamos', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/w_300,q_95,f_auto/v1779113420/prestamos_vv3pes.png'},
    {'name': 'Crédito', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/w_300,q_95,f_auto/v1779113420/credito_cyh35d.png'},
    {'name': 'Compañías', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/w_300,q_95,f_auto/v1779113420/compañias_fec8bn.png'},
    {'name': 'Seguros', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/w_300,q_95,f_auto/v1779113420/seguros_b3uzmg.png'},
    {'name': 'Taxes', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/w_300,q_95,f_auto/v1779113420/taxes_av74sq.png'},
    {'name': 'Inmigración', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/w_300,q_95,f_auto/v1779113420/inmigracion_koagzv.png'},
    {'name': 'Real Estate', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/w_300,q_95,f_auto/v1779113421/real-state_w0n53e.png'},
    {'name': 'Notario', 'imageUrl': 'https://res.cloudinary.com/dll5kptjp/image/upload/v1781632536/ChatGPT_Image_16_jun_2026__02_53_04_p.m.-removebg-preview_ojjvum.png'},
  ];

  Map<String, dynamic>? _recommendationData;
  bool _isLoadingRecommendations = true;
  String? _recommendationError;
  int _currentRecommendationPage = 0;
  PageController? _recommendationPageController;
  Timer? _recommendationTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController!,
      curve: Curves.easeOut,
    );
    _animController!.forward();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🔄 UI: Iniciando carga de recomendaciones');
    debugPrint('└──────────────────────────────────────────');

    try {
      final response = await RecommendationService.fetchRecommendations();
      if (!mounted) return;

      final result = response['result'] as Map<String, dynamic>?;
      final recommendations = result?['recommendations'] as List<dynamic>?;
      final activeIndex = result?['activeIndex'] as int? ?? 0;
      final total = result?['total'] as int? ?? (recommendations?.length ?? 0);
      final updatedAt = result?['updatedAt'] as String? ?? 'N/A';

      Map<String, dynamic>? selectedRecommendation;
      if (recommendations != null && recommendations.isNotEmpty && activeIndex < recommendations.length) {
        selectedRecommendation = recommendations[activeIndex] as Map<String, dynamic>;
      }

      debugPrint('┌──────────────────────────────────────────');
      debugPrint('│ ✅ UI: Recomendaciones recibidas');
      debugPrint('├──────────────────────────────────────────');
      debugPrint('│ total: $total');
      debugPrint('│ activeIndex: $activeIndex');
      debugPrint('│ updatedAt: $updatedAt');
      if (selectedRecommendation != null) {
        debugPrint('│ selectedId: ${selectedRecommendation['id']}');
        debugPrint('│ selectedTitle: ${selectedRecommendation['title']}');
        debugPrint('│ selectedSubtitle: ${selectedRecommendation['subtitle']}');
        debugPrint('│ selectedColor: ${selectedRecommendation['color']}');
        debugPrint('│ selectedCtaLabel: ${selectedRecommendation['ctaLabel']}');
        debugPrint('│ selectedCtaLink: ${selectedRecommendation['ctaLink']}');
      } else {
        debugPrint('│ ⚠️ No hay recomendación disponible en activeIndex');
      }
      debugPrint('└──────────────────────────────────────────');

      final recCount = recommendations?.length ?? 0;

      setState(() {
        _recommendationData = response;
        _isLoadingRecommendations = false;
        _recommendationError = null;
      });

      // Si hay más de 1 recomendación, inicializar carrusel con auto-play
      if (recCount > 1) {
        _recommendationPageController?.dispose();
        _recommendationPageController = PageController(initialPage: activeIndex);
        _recommendationTimer?.cancel();
        _recommendationTimer = Timer.periodic(
          const Duration(seconds: 10),
          (timer) {
            if (_recommendationPageController == null ||
                !_recommendationPageController!.hasClients ||
                recCount <= 1) {
              timer.cancel();
              return;
            }
            int nextPage = (_currentRecommendationPage + 1) % recCount;
            _recommendationPageController!.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
        );
      }
    } catch (e) {
      if (!mounted) return;

      debugPrint('┌──────────────────────────────────────────');
      debugPrint('│ ❌ UI: Error al cargar recomendaciones');
      debugPrint('├──────────────────────────────────────────');
      debugPrint('│ error: $e');
      debugPrint('└──────────────────────────────────────────');

      setState(() {
        _isLoadingRecommendations = false;
        _recommendationError = e.toString();
      });
    }
  }

  Future<void> _onRefresh() async {
    debugPrint('🔄 [Home] Pull-to-refresh activado');
    _recommendationTimer?.cancel();
    _recommendationPageController?.dispose();
    _recommendationPageController = null;
    await _loadRecommendations();
  }

  @override
  void dispose() {
    _recommendationTimer?.cancel();
    _recommendationPageController?.dispose();
    _animController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F8F8),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim ?? const AlwaysStoppedAnimation(1.0),
          child: RefreshIndicator(
            color: AppTheme.accent,
            backgroundColor: Colors.white,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modern Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        // Avatar with gradient ring
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF8A3D), Color(0xFFFF6B1A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/bebe/bebe-hello.png',
                                fit: BoxFit.cover,
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
                                'BUENOS DÍAS',
                                style: GoogleFonts.ibmPlexMono(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.muted,
                                  letterSpacing: 0.22,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.userName}, ¡hola de nuevo!',
                                style: GoogleFonts.fredoka(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.fg,
                                  letterSpacing: -0.012,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Notification icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.line, width: 1),
                          ),
                          child: Icon(
                            Icons.notifications_none_outlined,
                            color: AppTheme.fg,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Menu
                        GestureDetector(
                          onTap: () => _scaffoldKey.currentState?.openDrawer(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.accent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // BEBE Featured Card — Recomendación dinámica del endpoint
                  _buildRecommendationCard(),

                  const SizedBox(height: 28),

                  // Section header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'TUS BENEFICIOS',
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.fg,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_benefits.length} disponibles',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Benefits Grid with labels
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.68,
                      children: _benefits.asMap().entries.map((entry) {
                        return _buildBenefitCard(context, entry.value, entry.key);
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Bebe helper
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.line, width: 1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.accent.withValues(alpha: 0.1),
                              border: Border.all(color: AppTheme.accent, width: 1.5),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/bebe-radio.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BEBE',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.accent,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Toca cualquier beneficio para explorar planes.',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.fg,
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppTheme.accent;
    final clean = hex.replaceAll('#', '');
    if (clean.length == 6) {
      return Color(int.parse('FF$clean', radix: 16));
    }
    if (clean.length == 8) {
      return Color(int.parse(clean, radix: 16));
    }
    return AppTheme.accent;
  }

  Widget _buildRecommendationCard() {
    if (_isLoadingRecommendations) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE8D1), Color(0xFFFFF5ED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.25), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SkeletonBox(width: 48, height: 48, borderRadius: BorderRadius.all(Radius.circular(24))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 80, height: 10, borderRadius: BorderRadius.circular(4)),
                    const SizedBox(height: 8),
                    SkeletonBox(width: double.infinity, height: 36, borderRadius: BorderRadius.circular(4)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const SkeletonBox(width: 70, height: 32, borderRadius: BorderRadius.all(Radius.circular(10))),
            ],
          ),
        ),
      );
    }

    if (_recommendationError != null || _recommendationData == null) {
      // Fallback: card mínimo para que la UI no se rompa
      return Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.line, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BEBE TE AYUDA',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accent,
                        letterSpacing: 0.12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'No pudimos cargar tu recomendación. Toca para reintentar.',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _loadRecommendations,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'REINTENTAR',
                    style: GoogleFonts.fredoka(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final result = _recommendationData!['result'] as Map<String, dynamic>?;
    final allRecommendations = result?['recommendations'] as List<dynamic>?;

    if (allRecommendations == null || allRecommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    // Mostrar máximo 4 banners
    final recommendations = allRecommendations.take(4).toList();

    // Si hay solo 1 recomendación, mostrar card estático
    if (recommendations.length == 1) {
      return _buildSingleRecommendationCard(recommendations[0] as Map<String, dynamic>);
    }

    // Si hay múltiples recomendaciones, mostrar carrusel con auto-play
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _recommendationPageController,
            itemCount: recommendations.length,
            onPageChanged: (index) {
              setState(() => _currentRecommendationPage = index);
            },
            itemBuilder: (context, index) {
              return _buildSingleRecommendationCard(
                recommendations[index] as Map<String, dynamic>,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(recommendations.length, (index) {
            final isActive = index == _currentRecommendationPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.accent : AppTheme.line,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSingleRecommendationCard(Map<String, dynamic> recommendation) {
    final colorHex = recommendation['color'] as String?;
    final imageUrl = recommendation['imageUrl'] as String?;
    final ctaLink = recommendation['ctaLink'] as String? ?? '';

    final accentColor = _parseColor(colorHex);

    return GestureDetector(
      onTap: () async {
        if (ctaLink.isNotEmpty) {
          try {
            var url = ctaLink;
            if (!url.startsWith('http://') && !url.startsWith('https://')) {
              url = 'https://$url';
            }
            final uri = Uri.parse(url);
            final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
            if (!launched && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No se pudo abrir el enlace.')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al abrir enlace: $e')),
              );
            }
          }
        }
      },
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: accentColor.withValues(alpha: 0.3)),
            )
          else
            Container(color: accentColor.withValues(alpha: 0.3)),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildBenefitCard(BuildContext context, Map<String, String> benefit, int index) {
    final name = benefit['name']!;
    return GestureDetector(
      onTap: () {
        final config = benefitConfigs[name];
        if (config != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BenefitDetailPage(
                title: config.title,
                coverPath: config.coverPath,
                bebeMessage: config.bebeMessage,
                bebeImagePath: config.bebeImagePath,
                items: config.items,
                ctaText: config.ctaText,
                servicesText: name == 'Voces de Conciencia' ? 'Escuchar' : 'Ver servicios disponibles',
                productName: config.title,
                onServicesTap: () async {
                  if (name == 'Voces de Conciencia') {
                    final url = Uri.parse('https://www.youtube.com/@vocesdeconcienciaradio');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                    return;
                  }
                  Widget? page;
                  switch (name) {
                    case 'Seguros':
                      page = const InsurancePage();
                      break;
                    case 'Finanzas':
                      page = const FinancePage();
                      break;
                    case 'Taxes':
                      page = const TaxesPage();
                      break;
                    case 'Academia':
                      page = const AcademiaPage();
                      break;
                    case 'Inmigración':
                      page = const ImmigrationPage();
                      break;
                    case 'Compañías':
                      page = const CompaniesPage();
                      break;
                    case 'Crédito':
                      page = const CreditPage();
                      break;
                    case 'Real Estate':
                      page = const RealEstatePage();
                      break;
                    case 'Préstamos':
                      page = const LoansPage();
                      break;
                    case 'Notario':
                      page = const NotarioPage();
                      break;
                  }
                  if (page != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => page!),
                    );
                  }
                },
              ),
            ),
          );
        }
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AppImage(
                  assetPath: benefit['imageUrl']!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.fredoka(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.fg,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Container(
          color: AppTheme.paper,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      Container(
                        color: AppTheme.accent,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Image.asset(
                                    'assets/images/bebe/bebe-user.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '¡Bienvenido de nuevo!',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.userName,
                              style: GoogleFonts.fredoka(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.person_outline_rounded,
                            color: AppTheme.accent,
                            size: 22,
                          ),
                          title: Text(
                            'Mi perfil',
                            style: GoogleFonts.fredoka(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.fg,
                            ),
                          ),
                          subtitle: Text(
                            'Ver y editar tu información',
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.muted,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppTheme.muted,
                            size: 18,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfilePage(),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.work_outline_rounded,
                            color: AppTheme.accent,
                            size: 22,
                          ),
                          title: Text(
                            'Mis servicios',
                            style: GoogleFonts.fredoka(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.fg,
                            ),
                          ),
                          subtitle: Text(
                            'Ver tus servicios contratados',
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.muted,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppTheme.muted,
                            size: 18,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyServicesPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.line, width: 1),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.qr_code_2,
                        color: AppTheme.accent,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Escanear código QR',
                      style: GoogleFonts.fredoka(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.fg,
                      ),
                    ),
                    subtitle: Text(
                      '¿Tienes un código de agente?',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.muted,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppTheme.muted,
                      size: 18,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QRScanPage()),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.line, width: 1),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.share_outlined,
                        color: AppTheme.accent,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Compartir app',
                      style: GoogleFonts.fredoka(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.fg,
                      ),
                    ),
                    subtitle: Text(
                      'Invitar a más personas',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.muted,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppTheme.muted,
                      size: 18,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: AppTheme.paper,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'Próximamente',
                            style: GoogleFonts.fredoka(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.fg,
                            ),
                          ),
                          content: Text(
                            'Esta funcionalidad estará disponible cuando la app esté disponible en la Play Store.',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.muted,
                              height: 1.4,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Entendido',
                                style: GoogleFonts.nunito(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.line, width: 1),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: AppTheme.accent,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Cerrar sesión',
                      style: GoogleFonts.fredoka(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.fg,
                      ),
                    ),
                    subtitle: Text(
                      'Salir de tu cuenta',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.muted,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppTheme.muted,
                      size: 18,
                    ),
                    onTap: () async {
                      try {
                        final backendRole = await AuthService.getBackendRole();
                        await AuthService.logout();
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StartedLoginsPage(),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al cerrar sesión: $e')),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'USA All Benefits Group',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.muted,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
