import 'package:all_benefits_group/app/theme/app_theme.dart';
import 'package:all_benefits_group/features/auth/data/auth_service.dart';
import 'package:all_benefits_group/features/auth/data/biometric_auth_service.dart';
import 'package:all_benefits_group/features/onboarding/presentation/qr_scan_page.dart';
import 'package:all_benefits_group/features/dashboard/presentation/user_home_page.dart';
import 'package:all_benefits_group/features/dashboard/presentation/student_home_page.dart';
import 'package:all_benefits_group/features/vendor/presentation/vendor_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartedLoginsPage extends StatefulWidget {
  final bool skipQuestions;
  final String? expectedRole;

  const StartedLoginsPage({super.key, this.skipQuestions = false, this.expectedRole});

  @override
  State<StartedLoginsPage> createState() => _StartedLoginsPageState();
}

class _StartedLoginsPageState extends State<StartedLoginsPage> {
  static const int _loginStep = 3;
  static const List<Map<String, Object>> _questions = [];

  String _selectedRole = 'customer';
  bool _showSignIn = true;
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _canCheckBiometrics = false;
  bool _hasSavedCredentials = false;
  String _biometricLabel = 'Biometría';
  late int _currentQuestion;

  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentQuestion = widget.skipQuestions || _questions.isEmpty
        ? _loginStep
        : 0;
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final savedEmail = await BiometricAuthService.getSavedEmail();
    final hasCreds = await BiometricAuthService.hasSavedCredentials();
    final canBio = await BiometricAuthService.canCheckBiometrics();
    final label = await BiometricAuthService.getBiometricLabel();
    final shouldAuto = await BiometricAuthService.shouldOfferBiometricLogin();

    if (!mounted) return;

    setState(() {
      if (savedEmail != null && savedEmail.isNotEmpty) {
        _emailController.text = savedEmail;
      }
      _hasSavedCredentials = hasCreds;
      _canCheckBiometrics = canBio;
      _biometricLabel = label;
      _rememberMe = hasCreds;
    });

    debugPrint('🔐 initState: hasSavedCredentials=$hasCreds, canBiometrics=$canBio, label=$label, shouldAuto=$shouldAuto');

    // Si hay credenciales + biometría + no hubo logout explícito → auto-login directo
    if (shouldAuto) {
      debugPrint('🟢 [Login] Auto-biometría disponible, solicitando...');
      await _handleBiometricLogin();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _currentQuestion < _questions.length
        ? _buildOnboarding(context)
        : _buildLoginForm(context);
  }

  Widget _buildOnboarding(BuildContext context) {
    final questions = _questions;

    if (questions.isEmpty || _currentQuestion >= questions.length) {
      return _buildLoginForm(context);
    }

    final currentQ = questions[_currentQuestion];

    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currentQ['emoji'] as String,
                  style: const TextStyle(fontSize: 56),
                ),
                const SizedBox(height: 24),
                Text(
                  currentQ['question'] as String,
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.fg,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOptionButton(
                      currentQ['option1'] as String,
                      () => _answerQuestion(0),
                    ),
                    const SizedBox(width: 16),
                    _buildOptionButton(
                      currentQ['option2'] as String,
                      () => _answerQuestion(1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.accent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.paper,
          ),
        ),
      ),
    );
  }

  void _answerQuestion(int optionIndex) {
    setState(() {
      _currentQuestion++;
    });
  }

  /// Transforma mensajes de error crudos del backend en mensajes amigables para el usuario.
  String _friendlyErrorMessage(Object error) {
    final raw = error.toString().toLowerCase();

    if (raw.contains('invalid credentials') ||
        raw.contains('invalid email or password') ||
        raw.contains('unauthorized') ||
        raw.contains('unauthenticated') ||
        raw.contains('401')) {
      return 'Credenciales incorrectas, intente nuevamente';
    }

    if (raw.contains('user not found') || raw.contains('usuario no encontrado')) {
      return 'No encontramos una cuenta con ese email. ¿Querés registrarte?';
    }

    if (raw.contains('email already exists') ||
        raw.contains('ya existe') ||
        raw.contains('duplicate')) {
      return 'Ya existe una cuenta con ese email. Probá iniciar sesión o usá otro correo.';
    }

    if (raw.contains('network') ||
        raw.contains('socket') ||
        raw.contains('connection') ||
        raw.contains('timeout')) {
      return 'Problema de conexión. Revisá tu internet e intentá de nuevo.';
    }

    if (raw.contains('server') || raw.contains('500') || raw.contains('503')) {
      return 'El servidor no respondió. Intentá más tarde.';
    }

    // Si no reconocemos el error, mostramos un mensaje genérico amigable
    // en lugar del texto crudo del backend.
    return 'Algo salió mal. Intentá de nuevo en unos segundos.';
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 4),
        elevation: 6,
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.accent, width: 6),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/bebe/bebe-hello.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bienvenido a USA All Benefits Group',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.fg,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _emailFocusNode.unfocus();
                          setState(() => _showSignIn = true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _showSignIn
                                ? AppTheme.accent
                                : AppTheme.paper,
                            border: Border.all(
                              color: AppTheme.accent,
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Iniciar sesión',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: _showSignIn
                                  ? AppTheme.paper
                                  : AppTheme.muted,
                              letterSpacing: 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _emailFocusNode.unfocus();
                          setState(() => _showSignIn = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_showSignIn
                                ? AppTheme.accent
                                : AppTheme.paper,
                            border: Border.all(
                              color: AppTheme.accent,
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Registrarse',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: !_showSignIn
                                  ? AppTheme.paper
                                  : AppTheme.muted,
                              letterSpacing: 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_showSignIn) _buildSignInForm() else _buildSignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _showSignIn ? 'Entrar como' : 'Registrarse como',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.fg,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _showRolesExplanation(context),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppTheme.accentDim,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRoleCard(
                'customer',
                'Cliente',
                imagePath: 'assets/images/bebe/bebe-user.png',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildRoleCard(
                'usuario',
                'Agente',
                imagePath: 'assets/images/bebe/finanzas-bebe.png',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildRoleCard(
                'estudiante',
                'Estudiante',
                imagePath: 'assets/images/bebe/academy.png',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Email',
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.fg,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _emailFocusNode.hasFocus ? AppTheme.accent : AppTheme.line,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.fg,
            ),
            decoration: InputDecoration(
              hintText: 'tú@ejemplo.com',
              hintStyle: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.muted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Contraseña',
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.fg,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.line, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.fg,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.muted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.muted,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
        ),
        // Remember me toggle
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() => _rememberMe = value ?? false);
                  if (!(_rememberMe)) {
                    BiometricAuthService.clearCredentials();
                    setState(() => _hasSavedCredentials = false);
                  }
                },
                activeColor: AppTheme.accent,
                side: BorderSide(color: AppTheme.line, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _rememberMe = !_rememberMe;
                  if (!_rememberMe) {
                    BiometricAuthService.clearCredentials();
                    _hasSavedCredentials = false;
                  }
                });
              },
              child: Text(
                'Recordar contraseña',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.fg,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Biometric login button (if available and credentials saved)
        if (_canCheckBiometrics && _hasSavedCredentials)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: _isLoading ? null : _handleBiometricLogin,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.accent, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fingerprint,
                      color: AppTheme.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ingresar con $_biometricLabel',
                      style: GoogleFonts.fredoka(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.accent,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        GestureDetector(
          onTap: _isLoading ? null : _handleLogin,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: _isLoading ? AppTheme.muted : AppTheme.accent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentDark,
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppTheme.paper,
                      ),
                    ),
                  )
                : Text(
                    'Iniciar sesión',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.paper,
                      letterSpacing: 0.1,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 14),
        _buildQRCard(),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _showSignIn ? 'Entrar como' : 'Registrarse como',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.fg,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _showRolesExplanation(context),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppTheme.accentDim,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRoleCard(
                'customer',
                'Cliente',
                imagePath: 'assets/images/bebe/bebe-user.png',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildRoleCard(
                'usuario',
                'Agente',
                imagePath: 'assets/images/bebe/finanzas-bebe.png',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildRoleCard(
                'estudiante',
                'Estudiante',
                imagePath: 'assets/images/bebe/academy.png',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Nombre completo',
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.fg,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.line, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _nameController,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.fg,
            ),
            decoration: InputDecoration(
              hintText: 'Tu nombre',
              hintStyle: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.muted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Email',
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.fg,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.line, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.fg,
            ),
            decoration: InputDecoration(
              hintText: 'tú@ejemplo.com',
              hintStyle: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.muted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'WhatsApp',
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.fg,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.line, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.fg,
            ),
            decoration: InputDecoration(
              hintText: '+1 (555) 123-4567',
              hintStyle: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.muted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Contraseña',
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.fg,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.line, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.fg,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.muted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.muted,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: _isLoading ? null : _handleRegister,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: _isLoading ? AppTheme.muted : AppTheme.accent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentDark,
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppTheme.paper,
                      ),
                    ),
                  )
                : Text(
                    'Crear cuenta y continuar',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.paper,
                      letterSpacing: 0.1,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa email y contraseña')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.login(email: email, password: password);

      if (!mounted) return;

      // Siempre obtener datos frescos del usuario autenticado
      debugPrint('🟡 [Login] Obteniendo datos del usuario desde /api/auth/me...');
      final me = await AuthService.fetchMe();
      debugPrint('🟢 [Login] fetchMe respondió: $me');

      // Extraer nombre
      final userName = (me['name'] as String?) ??
          (me['user'] is Map ? me['user']['name'] as String? : null) ??
          'Usuario';

      // Extraer rol de forma robusta (top-level o anidado)
      String? rawRole;
      if (me.containsKey('role')) {
        rawRole = me['role'] as String?;
      } else if (me['user'] is Map && (me['user'] as Map).containsKey('role')) {
        rawRole = me['user']['role'] as String?;
      }

      // Normalizar rol: manejar español del backend → inglés esperado
      String role;
      switch (rawRole?.toLowerCase()) {
        case 'seller':
        case 'usuario':
        case 'vendedor':
          role = 'seller';
          break;
        case 'student':
        case 'estudiante':
          role = 'student';
          break;
        case 'client':
        case 'customer':
        case 'cliente':
          role = 'client';
          break;
        default:
          // Fallback al rol guardado durante login
          role = await AuthService.getBackendRole() ?? 'client';
      }

      debugPrint('📛 [Login] Rol detectado: rawRole=$rawRole → normalizedRole=$role');
      if (widget.expectedRole != null) {
        debugPrint('🔒 [Login] Rol esperado: ${widget.expectedRole}');
      }

      if (!mounted) return;

      // Determinar rol esperado para validación:
      // 1. Si viene de un flujo específico (ej: StudentInfoPage), usa expectedRole
      // 2. Si no, usa el rol seleccionado en el UI del login
      final expectedRole = widget.expectedRole ?? AuthService.mapRole(_selectedRole);
      debugPrint('🔒 [Login] Validando rol → esperado=$expectedRole, real=$role');

      if (role != expectedRole) {
        debugPrint('❌ [Login] Rol mismatch: esperado=$expectedRole pero es=$role');
        await AuthService.logout(); // limpiar sesión para evitar quedar logueado
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este usuario no pertenece a este rol.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      debugPrint('✅ [Login] Rol validado correctamente');

      // Guardar credenciales si el usuario marcó "Recordar contraseña"
      if (_rememberMe) {
        await BiometricAuthService.saveCredentials(
          email: email,
          password: password,
        );
        debugPrint('🔐 Credenciales guardadas para biometría futura');
      } else {
        await BiometricAuthService.clearCredentials();
      }

      // Login exitoso → borrar cualquier marca de logout explícito previo
      await BiometricAuthService.clearExplicitLogout();

      // Navegación según el rol real del usuario
      if (role == 'seller') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const VendorDashboardPage()),
        );
      } else if (role == 'student') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => StudentHomePage(userName: userName),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => UserHomePage(userName: userName),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(_friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleBiometricLogin() async {
    debugPrint('🔐 [Biometric] Solicitando autenticación biométrica...');

    final didAuthenticate = await BiometricAuthService.authenticate();
    if (!didAuthenticate) {
      debugPrint('⛔ [Biometric] Autenticación cancelada o fallida');
      return;
    }

    final savedEmail = await BiometricAuthService.getSavedEmail();
    final savedPassword = await BiometricAuthService.getSavedPassword();

    if (savedEmail == null || savedPassword == null || savedEmail.isEmpty || savedPassword.isEmpty) {
      debugPrint('❌ [Biometric] No hay credenciales guardadas');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay credenciales guardadas. Inicia sesión manualmente.')),
        );
      }
      return;
    }

    // Autocompletar campos
    _emailController.text = savedEmail;
    _passwordController.text = savedPassword;

    // Ejecutar login con las credenciales guardadas
    debugPrint('🟢 [Biometric] Autenticación exitosa, procediendo a login automático...');
    await _handleLogin();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        uiRole: _selectedRole,
      );

      if (!mounted) return;

      // Navegación según el rol interno
      if (_selectedRole == 'usuario') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const VendorDashboardPage()),
        );
      } else if (_selectedRole == 'estudiante') {
        final me = await AuthService.fetchMe();
        final userName = (me['name'] as String?) ?? 'Estudiante';
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => StudentHomePage(userName: userName),
          ),
        );
      } else {
        debugPrint('🟡 [Register] Llamando a fetchMe para obtener nombre del usuario...');
        final me = await AuthService.fetchMe();
        final userName = (me['name'] as String?) ?? 'Usuario';
        debugPrint('🟢 [Register] fetchMe respondió: name=$userName');
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => UserHomePage(userName: userName),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(_friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildRoleCard(
    String id,
    String title, {
    IconData? icon,
    String? imagePath,
  }) {
    final isSelected = _selectedRole == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentDim : AppTheme.paper,
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.line,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imagePath != null
                ? Image.asset(
                    imagePath,
                    width: 72,
                    height: 72,
                    fit: BoxFit.contain,
                  )
                : Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accent.withValues(alpha: 0.15)
                          : AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        icon ?? Icons.person,
                        size: 32,
                        color: isSelected ? AppTheme.accent : AppTheme.muted,
                      ),
                    ),
                  ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.accent : AppTheme.fg,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCard() {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const QRScanPage()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.line, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.accentDim,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_2,
                  size: 18,
                  color: AppTheme.accent,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Escanear código QR',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.fg,
                    ),
                  ),
                  Text(
                    '¿Tienes un código de agente?',
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppTheme.muted,
            ),
          ],
        ),
      ),
    );
  }

  void _showRolesExplanation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.paper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '¿Quién eres?',
              style: GoogleFonts.fredoka(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.fg,
              ),
            ),
            const SizedBox(height: 24),
            _buildRoleExplanation('👤', 'CLIENTE', 'Ya tienes una póliza con nosotros. Accede a tus beneficios y cobertura directamente.'),
            const SizedBox(height: 16),
            _buildRoleExplanation('💼', 'USUARIO', 'Agente o vendedor registrado. Gestiona tus ventas, comisiones y cartera de clientes.'),
            const SizedBox(height: 16),
            _buildRoleExplanation('🎓', 'ESTUDIANTE', 'Participante de nuestros programas educativos y de formación.'),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Entendido',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.paper,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleExplanation(String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.fg,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
