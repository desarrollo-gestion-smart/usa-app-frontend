import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendlyWebView extends StatefulWidget {
  final String url;
  final String? title;

  const CalendlyWebView({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<CalendlyWebView> createState() => _CalendlyWebViewState();
}

class _CalendlyWebViewState extends State<CalendlyWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Calendly WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      appBar: AppBar(
        backgroundColor: AppTheme.paper,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, color: AppTheme.fg),
        ),
        title: Text(
          widget.title ?? 'Agendar reunión',
          style: GoogleFonts.fredoka(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppTheme.fg,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: AppTheme.paper,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.accent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Muestra Calendly en una pantalla modal dentro de la app
void showCalendlyInline(BuildContext context, {String? title}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CalendlyWebView(
        url: 'https://calendly.com/usaallbenefitsgroup/30min',
        title: title,
      ),
    ),
  );
}
