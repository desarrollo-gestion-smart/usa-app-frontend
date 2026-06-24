import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/features/auth/data/auth_service.dart';
import 'package:all_benefits_group/features/onboarding/presentation/started_logins_page.dart';
import 'package:all_benefits_group/features/products/data/course_data.dart';
import 'package:all_benefits_group/features/vendor/presentation/vendor_course_detail_page.dart';
import 'package:all_benefits_group/features/vendor/presentation/vendor_product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorDashboardPage extends StatefulWidget {
  const VendorDashboardPage({super.key});

  @override
  State<VendorDashboardPage> createState() => _VendorDashboardPageState();
}

class _VendorDashboardPageState extends State<VendorDashboardPage> {
  String _userName = 'Vendedor';
  bool _isLoading = true;
  bool _isCatalogExpanded = true;
  bool _isCoursesExpanded = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<VendorProductItem> _products = const [
    VendorProductItem(
      name: 'Seguros',
      desc: 'Vida, Salud, Dental, Auto',
      color: Color(0xFF3B82F6),
      icon: Icons.shield_outlined,
    ),
    VendorProductItem(
      name: 'Finanzas',
      desc: 'IUL y Anualidades',
      color: Color(0xFF10B981),
      icon: Icons.trending_up_outlined,
    ),
    VendorProductItem(
      name: 'Taxes',
      desc: 'Individual y Corporativo',
      color: Color(0xFFF59E0B),
      icon: Icons.receipt_long_outlined,
    ),
    VendorProductItem(
      name: 'Inmigración',
      desc: 'Visas, Green Card',
      color: Color(0xFF8B5CF6),
      icon: Icons.card_travel_outlined,
    ),
    VendorProductItem(
      name: 'Real Estate',
      desc: 'Compra, Venta, Inversión',
      color: Color(0xFFEC4899),
      icon: Icons.home_work_outlined,
    ),
    VendorProductItem(
      name: 'Crédito',
      desc: 'Reparación y Monitoreo',
      color: Color(0xFF06B6D4),
      icon: Icons.credit_score_outlined,
    ),
    VendorProductItem(
      name: 'Préstamos',
      desc: 'Personal, Hipotecario',
      color: Color(0xFF84CC16),
      icon: Icons.account_balance_outlined,
    ),
    VendorProductItem(
      name: 'Academia',
      desc: 'Cursos y Certificaciones',
      color: Color(0xFFF97316),
      icon: Icons.school_outlined,
    ),
    VendorProductItem(
      name: 'Compañías',
      desc: 'LLC, S-Corp, C-Corp',
      color: Color(0xFF6366F1),
      icon: Icons.business_outlined,
    ),
    VendorProductItem(
      name: 'Radio',
      desc: 'Voces de Conciencia',
      color: Color(0xFF14B8A6),
      icon: Icons.radio_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await AuthService.getUser();
      if (user != null && user['name'] != null) {
        setState(() {
          _userName = user['name'] as String;
          _isLoading = false;
        });
        return;
      }

      // Si no hay nombre guardado, consultamos al backend
      final me = await AuthService.fetchMe();
      if (!mounted) return;

      final name = (me['name'] as String?) ??
          (me['user'] is Map ? me['user']['name'] as String? : null) ??
          'Vendedor';

      setState(() {
        _userName = name;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error cargando datos del vendedor: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String get _initials {
    final parts = _userName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _userName.isNotEmpty ? _userName[0].toUpperCase() : 'V';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.paper,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _initials,
                              style: GoogleFonts.fredoka(
                                fontSize: 14,
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
                          'VENDEDOR',
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.muted,
                            letterSpacing: 0.20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userName,
                          style: GoogleFonts.fredoka(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.fg,
                            letterSpacing: -0.01,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.paper,
                      border: Border.all(color: AppTheme.accent, width: 1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'ACTIVA',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.accent,
                        letterSpacing: 0.18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(10),
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KPIs
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _KPICard(
                          label: 'VENTAS ESTE MES',
                          value: '8',
                          delta: '+2 vs. mes anterior',
                          isUp: true,
                        ),
                        _KPICard(
                          label: 'COMISIÓN',
                          value: '\$1,240',
                          delta: '+18% vs. mes anterior',
                          isUp: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Section header
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCatalogExpanded = !_isCatalogExpanded;
                        });
                      },
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
                            'CATÁLOGO DE PRODUCTOS',
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.fg,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          AnimatedRotation(
                            turns: _isCatalogExpanded ? 0 : 0.5,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppTheme.accent,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _isCatalogExpanded
                          ? Column(
                              children: [
                                const SizedBox(height: 14),
                                GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  childAspectRatio: 1.22,
                                  children: _products.map((p) => _ProductCard(product: p)).toList(),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 28),

                    // Courses section header
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCoursesExpanded = !_isCoursesExpanded;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'CATÁLOGO DE CURSOS',
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.fg,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          AnimatedRotation(
                            turns: _isCoursesExpanded ? 0 : 0.5,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF6366F1),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _isCoursesExpanded
                          ? Column(
                              children: [
                                const SizedBox(height: 14),
                                GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  childAspectRatio: 1.22,
                                  children: allCourses.map((c) => _CourseCard(course: c)).toList(),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
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
                              _userName,
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
                    // TODO: navegar a perfil del vendedor
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.trending_up_rounded,
                    color: AppTheme.accent,
                    size: 22,
                  ),
                  title: Text(
                    'Mis ventas',
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.fg,
                    ),
                  ),
                  subtitle: Text(
                    'Ver historial de ventas',
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
                    // TODO: navegar a historial de ventas
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
              const SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String label;
  final String value;
  final String delta;
  final bool isUp;

  const _KPICard({
    required this.label,
    required this.value,
    required this.delta,
    required this.isUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.line, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: AppTheme.muted,
              letterSpacing: 0.20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppTheme.fg,
              letterSpacing: -0.014,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            delta,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: isUp ? AppTheme.good : const Color(0xFFE53935),
              letterSpacing: 0.06,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CourseData course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VendorCourseDetailPage(course: course),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.line, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      width: 1.2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      course.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              course.name,
              style: GoogleFonts.fredoka(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppTheme.fg,
                letterSpacing: -0.01,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              course.shortDesc,
              style: GoogleFonts.nunito(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: AppTheme.muted,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class VendorProductItem {
  final String name;
  final String desc;
  final Color color;
  final IconData icon;

  const VendorProductItem({
    required this.name,
    required this.desc,
    required this.color,
    required this.icon,
  });
}

class _ProductCard extends StatelessWidget {
  final VendorProductItem product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VendorProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.line, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: product.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: product.color.withValues(alpha: 0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    product.icon,
                    color: product.color,
                    size: 18,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.good,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.good.withValues(alpha: 0.4),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              style: GoogleFonts.fredoka(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppTheme.fg,
                letterSpacing: -0.01,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              product.desc,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.muted,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
