import 'dart:io';
import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ServiceDetailPage extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  late PageController _pageController;
  bool _isUploading = false;

  late List<String> _existingImages;
  late List<String> _existingDocuments;
  final List<PlatformFile> _newImages = [];
  final List<PlatformFile> _newDocuments = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _existingImages = List<String>.from(widget.service['serviceImages'] as List? ?? []);
    _existingDocuments = List<String>.from(widget.service['serviceDocuments'] as List? ?? []);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif'],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _newImages.addAll(result.files);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al seleccionar imágenes: $e')));
      }
    }
  }

  Future<void> _pickDocuments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _newDocuments.addAll(result.files);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al seleccionar documentos: $e')));
      }
    }
  }

  void _removeImage(int index) => setState(() => _newImages.removeAt(index));
  void _removeDocument(int index) => setState(() => _newDocuments.removeAt(index));

  Future<void> _uploadFiles() async {
    if (_newImages.isEmpty && _newDocuments.isEmpty) return;

    final serviceId = widget.service['id']?.toString() ?? '';
    if (serviceId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo identificar el servicio')));
      return;
    }

    setState(() => _isUploading = true);

    try {
      final uri = Uri.parse('https://your-api.com/api/services/$serviceId/files');
      final request = http.MultipartRequest('POST', uri);

      for (final file in _newImages) {
        if (file.path != null) {
          request.files.add(await http.MultipartFile.fromPath('images', file.path!));
        }
      }

      for (final file in _newDocuments) {
        if (file.path != null) {
          request.files.add(await http.MultipartFile.fromPath('documents', file.path!));
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Archivos subidos exitosamente')));
          
          // Limpiar archivos locales
          _newImages.clear();
          _newDocuments.clear();
          
          // NOTE: Aquí podrías hacer un refresh del servicio desde el backend
          // para obtener la lista actualizada de archivos
          // final updatedService = await fetchServiceById(serviceId);
          // setState(() {
          //   _existingImages = List<String>.from(updatedService['serviceImages'] ?? []);
          //   _existingDocuments = List<String>.from(updatedService['serviceDocuments'] ?? []);
          // });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir: ${response.statusCode}')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _openFullScreenImage(BuildContext context, List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenImageViewer(images: images, initialIndex: initialIndex),
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'No disponible';
    try {
      final date = DateTime.tryParse(isoDate);
      if (date == null) return isoDate;
      return DateFormat('dd MMMM yyyy', 'es').format(date);
    } catch (_) {
      return isoDate;
    }
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    final number = value is num ? value : num.tryParse(value.toString());
    if (number == null) return value.toString();
    return NumberFormat.decimalPattern('en').format(number);
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

  Color _resolveStatusColor(String? status) {
    final s = status?.toLowerCase() ?? '';
    if (s == 'active' || s == 'activo') return AppTheme.good;
    if (s.contains('pendiente') || s.contains('pending')) return AppTheme.warn;
    if (s.contains('proceso') || s.contains('process')) return AppTheme.accent;
    if (s.contains('cancel') || s.contains('rechaz') || s.contains('expir')) return Colors.redAccent;
    return AppTheme.muted;
  }

  IconData _resolveIcon(String? serviceName, String? serviceType) {
    final name = (serviceName ?? serviceType ?? '').toLowerCase();
    if (name.contains('vida') || name.contains('life') || name.contains('iul')) return Icons.favorite_outline_rounded;
    if (name.contains('salud') || name.contains('health') || name.contains('dental')) return Icons.health_and_safety_outlined;
    if (name.contains('auto') || name.contains('car') || name.contains('vehículo')) return Icons.directions_car_outlined;
    if (name.contains('taxes') || name.contains('impuesto')) return Icons.receipt_long_outlined;
    if (name.contains('crédito') || name.contains('credit') || name.contains('préstamo') || name.contains('loan')) return Icons.credit_score_outlined;
    if (name.contains('inmigración') || name.contains('immigration')) return Icons.card_travel_outlined;
    if (name.contains('real estate') || name.contains('inmueble') || name.contains('propiedad')) return Icons.home_work_outlined;
    if (name.contains('finanza') || name.contains('finance')) return Icons.account_balance_outlined;
    if (name.contains('academia') || name.contains('edu') || name.contains('school')) return Icons.school_outlined;
    if (name.contains('seguro') || name.contains('insurance')) return Icons.shield_outlined;
    return Icons.star_border_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.service['serviceName']?.toString() ?? 'Servicio';
    final status = widget.service['status']?.toString() ?? 'Desconocido';
    final statusColor = _resolveStatusColor(status);
    final allImages = [..._existingImages, ..._newImages.where((f) => f.path != null).map((f) => f.path!)];

    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios, color: AppTheme.muted, size: 16),
                        const SizedBox(width: 4),
                        Text('Atrás', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.muted)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text('Detalle del servicio', style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.fg)),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(name, status, statusColor),
                    const SizedBox(height: 16),
                    _CollapsibleSection(
                      title: 'Información general',
                      icon: Icons.info_outline,
                      children: [
                        _buildDetailRow('Tipo de servicio', widget.service['serviceType']?.toString() ?? '-'),
                        _buildDetailRow('Número de póliza', widget.service['policyNumber']?.toString() ?? '-'),
                        _buildDetailRow('Fecha de contratación', _formatDate(widget.service['contractDate']?.toString())),
                        _buildDetailRow('Fecha de vencimiento', _formatDate(widget.service['expiryDate']?.toString())),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _CollapsibleSection(
                      title: 'Cobertura y pago',
                      icon: Icons.payments_outlined,
                      children: [
                        _buildDetailRow('Monto de cobertura', widget.service['coverageAmount'] != null ? '\$${_formatNumber(widget.service['coverageAmount'])} ${widget.service['currency']?.toString().toUpperCase() ?? 'USD'}' : '-'),
                        _buildDetailRow('Pago mensual', widget.service['monthpay'] != null ? '\$${_formatNumber(widget.service['monthpay'])} ${widget.service['currency']?.toString().toUpperCase() ?? 'USD'}' : '-'),
                        _buildDetailRow('Empresa', widget.service['companyName']?.toString() ?? '-'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (widget.service['beneficiaryName'] != null || widget.service['beneficiaryPhone'] != null)
                      _CollapsibleSection(
                        title: 'Beneficiario',
                        icon: Icons.person_outline,
                        children: [
                          if (widget.service['beneficiaryName'] != null) _buildDetailRow('Nombre', widget.service['beneficiaryName'].toString()),
                          if (widget.service['beneficiaryPhone'] != null) _buildDetailRow('Teléfono', widget.service['beneficiaryPhone'].toString()),
                        ],
                      ),
                    if (widget.service['beneficiaryName'] != null || widget.service['beneficiaryPhone'] != null) const SizedBox(height: 12),
                    if (widget.service['notes'] != null && widget.service['notes'].toString().isNotEmpty)
                      _CollapsibleSection(
                        title: 'Notas',
                        icon: Icons.note_outlined,
                        initiallyExpanded: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(widget.service['notes'].toString(), style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.fg, height: 1.5)),
                          ),
                        ],
                      ),
                    if (widget.service['notes'] != null && widget.service['notes'].toString().isNotEmpty) const SizedBox(height: 12),
                    _UploadSection(
                      title: 'Imágenes',
                      icon: Icons.image_outlined,
                      allowedExtensions: 'JPG, PNG, WEBP',
                      existingFiles: _existingImages,
                      newFiles: _newImages,
                      isImage: true,
                      onAdd: _pickImages,
                      onRemove: _removeImage,
                      onViewFullScreen: _existingImages.isNotEmpty ? (index) => _openFullScreenImage(context, allImages, index) : null,
                    ),
                    const SizedBox(height: 12),
                    _UploadSection(
                      title: 'Documentos',
                      icon: Icons.description_outlined,
                      allowedExtensions: 'PDF, DOC, TXT',
                      existingFiles: _existingDocuments,
                      newFiles: _newDocuments,
                      isImage: false,
                      onAdd: _pickDocuments,
                      onRemove: _removeDocument,
                      onViewFullScreen: null,
                    ),
                    if (_newImages.isNotEmpty || _newDocuments.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _isUploading ? null : _uploadFiles,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _isUploading ? AppTheme.muted : AppTheme.accent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _isUploading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text('Subir ${_newImages.length + _newDocuments.length} archivo(s)', style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(String name, String status, Color statusColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.line, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_resolveIcon(name, widget.service['serviceType']?.toString()), color: AppTheme.accent, size: 32),
          ),
          const SizedBox(height: 16),
          Text(name, style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.fg)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.35)),
            ),
            child: Text(_formatStatus(status), style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: statusColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.muted)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(value, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.fg), textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool initiallyExpanded;

  const _CollapsibleSection({required this.title, required this.icon, required this.children, this.initiallyExpanded = false});

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.line, width: 1.5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(widget.icon, color: AppTheme.accent, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(widget.title, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.fg))),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down, color: AppTheme.muted, size: 20),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(children: widget.children),
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _UploadSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String allowedExtensions;
  final List<String> existingFiles;
  final List<PlatformFile> newFiles;
  final bool isImage;
  final VoidCallback onAdd;
  final Function(int) onRemove;
  final Function(int)? onViewFullScreen;

  const _UploadSection({
    required this.title,
    required this.icon,
    required this.allowedExtensions,
    required this.existingFiles,
    required this.newFiles,
    required this.isImage,
    required this.onAdd,
    required this.onRemove,
    this.onViewFullScreen,
  });

  @override
  Widget build(BuildContext context) {
    final allFiles = [...existingFiles, ...newFiles.where((f) => f.path != null).map((f) => f.path!)];

    if (allFiles.isEmpty) {
      return _buildEmptyUpload(context);
    }

    return Container(
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
              Icon(icon, color: AppTheme.accent, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.fg))),
              Text('${allFiles.length}', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.muted)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: AppTheme.accent, size: 16),
                      const SizedBox(width: 4),
                      Text('Agregar', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.accent)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allFiles.length,
              itemBuilder: (context, index) {
                final isExisting = index < existingFiles.length;
                final isNew = !isExisting;
                final filePath = allFiles[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: isImage && isExisting && onViewFullScreen != null
                            ? () => onViewFullScreen!(index)
                            : null,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.surface,
                            border: Border.all(color: AppTheme.line),
                          ),
                          child: isImage
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: filePath.startsWith('http')
                                      ? Image.network(filePath, fit: BoxFit.cover, errorBuilder: (_, _, _) => _buildPlaceholder())
                                      : Image.file(File(filePath), fit: BoxFit.cover, errorBuilder: (_, _, _) => _buildPlaceholder()),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.description_outlined, color: AppTheme.accent, size: 32),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(
                                        filePath.split('/').last.split('.').last.toUpperCase(),
                                        style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.muted),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            if (isNew) {
                              onRemove(newFiles.indexWhere((f) => f.path == filePath));
                            }
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isNew ? Colors.redAccent.withValues(alpha: 0.9) : Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isNew ? Icons.close : Icons.visibility,
                              color: Colors.white,
                              size: isNew ? 14 : 12,
                            ),
                          ),
                        ),
                      ),
                      if (isNew)
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('NEW', style: GoogleFonts.nunito(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.surface,
      child: const Icon(Icons.image_not_supported, color: AppTheme.muted),
    );
  }

  Widget _buildEmptyUpload(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.line, width: 1.5),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(isImage ? Icons.add_photo_alternate_outlined : Icons.add_box_outlined, color: AppTheme.muted, size: 40),
            const SizedBox(height: 8),
            Text('Agregar ${isImage ? 'imágenes' : 'documentos'}', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.muted)),
            const SizedBox(height: 4),
            Text(allowedExtensions, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.muted.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }
}

class _FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _FullScreenImageViewer({required this.images, required this.initialIndex});

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1}/${widget.images.length}',
          style: GoogleFonts.nunito(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: widget.images.length,
        itemBuilder: (context, index) => InteractiveViewer(
          minScale: 1.0,
          maxScale: 4.0,
          child: Center(
            child: widget.images[index].startsWith('http')
                ? Image.network(widget.images[index], fit: BoxFit.contain, errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported, color: Colors.white, size: 60))
                : Image.file(File(widget.images[index]), fit: BoxFit.contain, errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported, color: Colors.white, size: 60)),
          ),
        ),
      ),
    );
  }
}
