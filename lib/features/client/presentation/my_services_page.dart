import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/common/widgets/skeleton_box.dart';
import 'package:all_benefits_group/features/client/data/my_services_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyServicesPage extends StatefulWidget {
  const MyServicesPage({super.key});

  @override
  State<MyServicesPage> createState() => _MyServicesPageState();
}

class _MyServicesPageState extends State<MyServicesPage> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await MyServicesService.fetchUserServices();
      if (!mounted) return;

      final services = _extractServices(data);
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Extrae la lista de servicios de la respuesta de forma flexible.
  List<Map<String, dynamic>> _extractServices(Map<String, dynamic> data) {
    dynamic raw;
    if (data['services'] is List) {
      raw = data['services'];
    } else if (data['data'] is Map && data['data']['services'] is List) {
      raw = data['data']['services'];
    } else if (data['user'] is Map && data['user']['services'] is List) {
      raw = data['user']['services'];
    } else if (data['result'] is Map && data['result']['services'] is List) {
      raw = data['result']['services'];
    }

    if (raw == null || raw is! List) return [];
    return raw.whereType<Map<String, dynamic>>().toList();
  }

  IconData _resolveIcon(String? serviceName, String? serviceType) {
    final name = (serviceName ?? serviceType ?? '').toLowerCase();
    if (name.contains('vida') || name.contains('life') || name.contains('iul')) {
      return Icons.favorite_outline_rounded;
    }
    if (name.contains('salud') || name.contains('health') || name.contains('dental')) {
      return Icons.health_and_safety_outlined;
    }
    if (name.contains('auto') || name.contains('car') || name.contains('vehículo')) {
      return Icons.directions_car_outlined;
    }
    if (name.contains('taxes') || name.contains('impuesto')) {
      return Icons.receipt_long_outlined;
    }
    if (name.contains('crédito') || name.contains('credit') || name.contains('préstamo') || name.contains('loan')) {
      return Icons.credit_score_outlined;
    }
    if (name.contains('inmigración') || name.contains('immigration')) {
      return Icons.card_travel_outlined;
    }
    if (name.contains('real estate') || name.contains('inmueble') || name.contains('propiedad')) {
      return Icons.home_work_outlined;
    }
    if (name.contains('finanza') || name.contains('finance')) {
      return Icons.account_balance_outlined;
    }
    if (name.contains('academia') || name.contains('edu') || name.contains('school')) {
      return Icons.school_outlined;
    }
    if (name.contains('seguro') || name.contains('insurance')) {
      return Icons.shield_outlined;
    }
    return Icons.star_border_rounded;
  }

  Color _resolveStatusColor(String? status) {
    final s = status?.toLowerCase() ?? '';
    if (s == 'active' || s == 'activo') return AppTheme.good;
    if (s.contains('pendiente') || s.contains('pending')) return AppTheme.warn;
    if (s.contains('proceso') || s.contains('process')) return AppTheme.accent;
    if (s.contains('cancel') || s.contains('rechaz') || s.contains('expir')) return Colors.redAccent;
    return AppTheme.muted;
  }

  String _formatStatus(String? status) {
    final s = status?.toLowerCase() ?? '';
    if (s == 'active') return 'Activo';
    if (s == 'inactive') return 'Inactivo';
    if (s == 'pending') return 'Pendiente';
    if (s == 'cancelled') return 'Cancelado';
    if (s == 'expired') return 'Expirado';
    return status ?? 'Desconocido';
  }

  String? _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return null;
    try {
      final date = DateTime.tryParse(isoDate);
      if (date == null) return isoDate;
      return DateFormat('dd MMM yyyy', 'es').format(date);
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _services.where((s) {
      final st = (s['status'] ?? '').toString().toLowerCase();
      return st == 'active' || st == 'activo';
    }).length;

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
                  const Spacer(),
                  Text(
                    'Mis servicios',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.fg,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            Expanded(child: _buildBody(activeCount)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(int activeCount) {
    if (_isLoading) {
      return _buildSkeletonList();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_services.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary
          Text(
            'Tienes $activeCount servicios activos',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 20),
          // Services list
          ..._services.map((service) => _buildServiceCard(context, service)),
          const SizedBox(height: 28),
          // BEBE bubble
          _buildBebeBubble(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSkeletonList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(
            width: 180,
            height: 14,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          const SizedBox(height: 20),
          ...List.generate(3, (_) => _buildSkeletonCard()),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.line, width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkeletonBox(
                width: 44,
                height: 44,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(
                      width: 140,
                      height: 16,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 6),
                    SkeletonBox(
                      width: 80,
                      height: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
              const SkeletonBox(
                width: 60,
                height: 24,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 24, color: AppTheme.line),
          Row(
            children: [
              Expanded(
                child: SkeletonBox(
                  width: double.infinity,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SkeletonBox(
                  width: double.infinity,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: AppTheme.muted),
            const SizedBox(height: 16),
            Text(
              'No pudimos cargar tus servicios',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.fg,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _loadServices,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.fredoka(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_outlined,
                size: 32,
                color: AppTheme.accent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aún no tienes servicios contratados',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.fg,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explora los beneficios disponibles en el inicio y contrata los que más te convengan.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.muted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    final name = service['serviceName']?.toString() ?? 'Servicio';
    final policyNumber = service['policyNumber']?.toString() ?? '';
    final status = service['status']?.toString() ?? 'Desconocido';
    final contractDate = _formatDate(service['contractDate']?.toString());
    final expiryDate = _formatDate(service['expiryDate']?.toString());
    final coverageAmount = service['coverageAmount'];
    final currency = service['currency']?.toString() ?? 'USD';

    final statusColor = _resolveStatusColor(status);
    final displayStatus = _formatStatus(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.line, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _resolveIcon(name, service['serviceType']?.toString()),
                    color: AppTheme.accent,
                    size: 22,
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
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.fg,
                        ),
                      ),
                      if (policyNumber.isNotEmpty)
                        const SizedBox(height: 2),
                      if (policyNumber.isNotEmpty)
                        Text(
                          'Póliza: $policyNumber',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.muted,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    displayStatus,
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: AppTheme.line),
            Row(
              children: [
                if (contractDate != null)
                  Expanded(
                    child: _buildMiniInfo(
                      icon: Icons.calendar_today_outlined,
                      label: 'Inicio: $contractDate',
                    ),
                  ),
                if (expiryDate != null)
                  Expanded(
                    child: _buildMiniInfo(
                      icon: Icons.event_available_outlined,
                      label: 'Vence: $expiryDate',
                    ),
                  ),
              ],
            ),
            if (coverageAmount != null)
              const SizedBox(height: 10),
            if (coverageAmount != null)
              _buildMiniInfo(
                icon: Icons.attach_money_outlined,
                label: 'Cobertura: \$${_formatNumber(coverageAmount)} ${currency.toUpperCase()}',
              ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    final number = value is num ? value : num.tryParse(value.toString());
    if (number == null) return value.toString();
    return NumberFormat.decimalPattern('en').format(number);
  }

  Widget _buildMiniInfo({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.muted,
          size: 14,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.muted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBebeBubble() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.accent, width: 2.5),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/bebe/bebe-hello.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F5),
              border: Border.all(
                color: AppTheme.accent.withValues(alpha: 0.25),
                width: 1.5,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Text(
              'BEBE: "Aquí puedes ver todos los servicios que tienes con nosotros. Cuando contrates un nuevo beneficio, aparecerá automáticamente en esta lista."',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.fg,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
