import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneRequestDialog extends StatefulWidget {
  final String productName;

  const PhoneRequestDialog({
    required this.productName,
    super.key,
  });

  @override
  State<PhoneRequestDialog> createState() => _PhoneRequestDialogState();
}

class _PhoneRequestDialogState extends State<PhoneRequestDialog> {
  late TextEditingController _phoneController;
  String _phoneError = '';

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() {
        _phoneError = 'Por favor ingresa tu número de teléfono';
      });
      return;
    }
    if (phone.length < 10) {
      setState(() {
        _phoneError = 'El número debe tener al menos 10 dígitos';
      });
      return;
    }
    Navigator.pop(context, phone);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppTheme.paper,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Información de Contacto',
              style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.fg,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Subtitle
            Text(
              'Ingresa tu teléfono para recibir información sobre ${widget.productName}',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.muted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            // Phone input
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (_) {
                if (_phoneError.isNotEmpty) {
                  setState(() {
                    _phoneError = '';
                  });
                }
              },
              decoration: InputDecoration(
                hintText: '+1 (555) 123-4567',
                errorText: _phoneError.isEmpty ? null : _phoneError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _phoneError.isNotEmpty ? const Color(0xFFFF6B6B) : AppTheme.line,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _phoneError.isNotEmpty ? const Color(0xFFFF6B6B) : AppTheme.line,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.accent,
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              ),
            ),
            const SizedBox(height: 22),
            // Buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        border: Border.all(color: AppTheme.line, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'CANCELAR',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.muted,
                          letterSpacing: 0.12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Submit button
                Expanded(
                  child: GestureDetector(
                    onTap: _validateAndSubmit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentDark,
                            offset: const Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        'ENVIAR',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.paper,
                          letterSpacing: 0.12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
