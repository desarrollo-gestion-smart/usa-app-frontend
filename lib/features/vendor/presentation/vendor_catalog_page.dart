import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorCatalogPage extends StatefulWidget {
  const VendorCatalogPage({super.key});

  @override
  State<VendorCatalogPage> createState() => _VendorCatalogPageState();
}

class _VendorCatalogPageState extends State<VendorCatalogPage> {
  final List<String> _filters = ['Todos', 'Salud', 'Dental', 'Vida'];
  String _selectedFilter = 'Todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      appBar: AppBar(
        title: Column(
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
              'Catálogo de Seguros',
              style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.fg,
                letterSpacing: -0.01,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            child: Row(
              children: _filters.map((filter) {
                final isActive = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? AppTheme.accent : AppTheme.paper,
                        border: Border.all(
                          color: isActive
                              ? AppTheme.accent
                              : AppTheme.line,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        filter,
                        style: GoogleFonts.fredoka(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: isActive ? AppTheme.paper : AppTheme.muted,
                          letterSpacing: 0.16,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Plans list
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  _PlanCard(
                    icon: '🦷',
                    name: 'Sonrisa Segura',
                    description: 'Plan dental con cobertura completa',
                    price: '\$18/mes',
                    featured: true,
                  ),
                  const SizedBox(height: 10),
                  _PlanCard(
                    icon: '🏥',
                    name: 'Salud Plus',
                    description: 'Cobertura médica integral',
                    price: '\$45/mes',
                    featured: false,
                  ),
                  const SizedBox(height: 10),
                  _PlanCard(
                    icon: '👁️',
                    name: 'Visión Clara',
                    description: 'Cuidado completo de la vista',
                    price: '\$12/mes',
                    featured: false,
                  ),
                  const SizedBox(height: 10),
                  _PlanCard(
                    icon: '💀',
                    name: 'Protección Vida',
                    description: 'Seguro de vida con rendimiento',
                    price: '\$35/mes',
                    featured: false,
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String icon;
  final String name;
  final String description;
  final String price;
  final bool featured;

  const _PlanCard({
    required this.icon,
    required this.name,
    required this.description,
    required this.price,
    required this.featured,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: featured ? AppTheme.accentDim : AppTheme.paper,
        border: Border.all(
          color: featured ? AppTheme.accent : AppTheme.line,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: featured ? AppTheme.accentDark : AppTheme.lineDark,
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.fg,
                        letterSpacing: -0.01,
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
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.fg,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'mes',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.muted,
                      letterSpacing: 0.06,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (featured) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.paper,
                border: Border.all(
                  color: AppTheme.accent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'MÁS VENDIDO',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accent,
                  letterSpacing: 0.16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
