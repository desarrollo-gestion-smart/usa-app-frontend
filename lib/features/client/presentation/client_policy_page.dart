import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientPolicyPage extends StatelessWidget {
  const ClientPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      appBar: AppBar(
        title: Text(
          'Mi Póliza',
          style: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.fg,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Mi Póliza',
          style: GoogleFonts.fredoka(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppTheme.fg,
          ),
        ),
      ),
    );
  }
}
