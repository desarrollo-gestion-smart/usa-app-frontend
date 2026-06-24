import 'dart:convert';
import 'package:all_benefits_group/features/auth/data/biometric_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  /// Lee la URL base del archivo .env
  static String get _baseUrl {
    final url = dotenv.env['BASE_URL_PROD'];
    if (url == null || url.isEmpty) {
      throw Exception(
        'BASE_URL_PROD no está definido en el archivo .env. '
        'Asegúrate de que el archivo .env exista y contenga BASE_URL_PROD=...',
      );
    }
    return url;
  }

  /// Mapeo de roles internos de la UI a roles del backend
  static const Map<String, String> _roleMap = {
    'customer': 'client',
    'usuario': 'seller',
    'estudiante': 'student',
  };

  /// Convierte un rol interno de la UI al formato esperado por el backend
  static String mapRole(String uiRole) {
    return _roleMap[uiRole] ?? 'client';
  }

  /// Convierte un rol del backend a rol interno de la UI
  static String mapRoleToUi(String backendRole) {
    for (final entry in _roleMap.entries) {
      if (entry.value == backendRole) return entry.key;
    }
    return 'customer';
  }

  // ── Persistencia segura con FlutterSecureStorage ──

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accountName: 'all_benefits_group_auth'),
  );

  static const String _kToken = 'auth_token_secure';
  static const String _kUser = 'auth_user_secure';
  static const String _kRole = 'auth_role_secure';

  /// Guarda la sesión localmente de forma segura
  static Future<void> _saveSession({
    required String token,
    required Map<String, dynamic> user,
    required String role,
  }) async {
    await _storage.write(key: _kToken, value: token);
    await _storage.write(key: _kUser, value: jsonEncode(user));
    await _storage.write(key: _kRole, value: role);
    debugPrint('🔐 Sesión guardada en almacenamiento seguro');
  }

  /// Cierra sesión en el backend y elimina la sesión local
  static Future<void> logout() async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      final url = Uri.parse('$_baseUrl/api/auth/logout');

      debugPrint('┌──────────────────────────────────────────');
      debugPrint('│ 🔵 LOGOUT REQUEST');
      debugPrint('├──────────────────────────────────────────');
      debugPrint('│ URL: $url');
      debugPrint('│ METHOD: POST');
      debugPrint('└──────────────────────────────────────────');

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        debugPrint('┌──────────────────────────────────────────');
        debugPrint('│ 🟢 LOGOUT RESPONSE');
        debugPrint('├──────────────────────────────────────────');
        debugPrint('│ STATUS CODE: ${response.statusCode}');
        debugPrint('│ BODY: ${response.body}');
        debugPrint('└──────────────────────────────────────────');
      } catch (e) {
        debugPrint('┌──────────────────────────────────────────');
        debugPrint('│ ⚠️  LOGOUT NETWORK ERROR');
        debugPrint('├──────────────────────────────────────────');
        debugPrint('│ ERROR: $e');
        debugPrint('└──────────────────────────────────────────');
      }
    } else {
      debugPrint('┌──────────────────────────────────────────');
      debugPrint('│ ⚠️  LOGOUT: No hay token guardado');
      debugPrint('└──────────────────────────────────────────');
    }

    debugPrint('🧹 Limpiando sesión local...');
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kUser);
    await _storage.delete(key: _kRole);
    await BiometricAuthService.clearCredentials();
    await BiometricAuthService.setQuickStartEnabled(false);
    await BiometricAuthService.markExplicitLogout();
    debugPrint('✅ Sesión local y credenciales biométricas eliminadas');
  }

  /// Devuelve true si hay un token guardado
  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _kToken);
    return token != null && token.isNotEmpty;
  }

  /// Devuelve el token JWT guardado
  static Future<String?> getToken() async {
    return await _storage.read(key: _kToken);
  }

  /// Devuelve el rol del backend guardado ('client', 'seller', 'student')
  static Future<String?> getBackendRole() async {
    return await _storage.read(key: _kRole);
  }

  /// Devuelve el rol interno de la UI ('customer', 'usuario', 'estudiante')
  static Future<String?> getUiRole() async {
    final backendRole = await getBackendRole();
    if (backendRole == null) return null;
    return mapRoleToUi(backendRole);
  }

  /// Devuelve los datos del usuario guardado
  static Future<Map<String, dynamic>?> getUser() async {
    final raw = await _storage.read(key: _kUser);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  // ── Endpoints ──

  /// Registra un nuevo usuario en el backend
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String uiRole,
  }) async {
    final url = Uri.parse('$_baseUrl/api/auth/register');
    final body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': mapRole(uiRole),
    });

    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🔵 REGISTER REQUEST');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ URL: $url');
    debugPrint('│ METHOD: POST');
    debugPrint('│ HEADERS: {Content-Type: application/json}');
    debugPrint('│ BODY: $body');
    debugPrint('└──────────────────────────────────────────');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    final responseBody = response.body;
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🟢 REGISTER RESPONSE');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ STATUS CODE: ${response.statusCode}');
    debugPrint('│ BODY: $responseBody');
    debugPrint('└──────────────────────────────────────────');

    final responseData = jsonDecode(responseBody) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final token = responseData['token'] as String?;
      final user = responseData['user'] as Map<String, dynamic>?;
      final role = responseData['role'] as String? ??
          (user?['role'] as String? ?? mapRole(uiRole));

      if (token != null && user != null) {
        await _saveSession(token: token, user: user, role: role);
      }
      return responseData;
    } else {
      final message = responseData['message'] ??
          responseData['error'] ??
          'Error del servidor: ${response.statusCode}';
      debugPrint('❌ REGISTER ERROR: $message');
      throw Exception(message);
    }
  }

  /// Inicia sesión con email y contraseña
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/api/auth/login');
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🔵 LOGIN REQUEST');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ URL: $url');
    debugPrint('│ METHOD: POST');
    debugPrint('│ HEADERS: {Content-Type: application/json}');
    debugPrint('│ BODY: $body');
    debugPrint('└──────────────────────────────────────────');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    final responseBody = response.body;
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🟢 LOGIN RESPONSE');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ STATUS CODE: ${response.statusCode}');
    debugPrint('│ BODY: $responseBody');
    debugPrint('└──────────────────────────────────────────');

    final responseData = jsonDecode(responseBody) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final token = responseData['token'] as String?;
      final user = responseData['user'] as Map<String, dynamic>?;
      final role = responseData['role'] as String? ??
          (user?['role'] as String? ?? 'client');

      if (token != null && user != null) {
        await _saveSession(token: token, user: user, role: role);
      }
      return responseData;
    } else {
      final message = responseData['message'] ??
          responseData['error'] ??
          'Error del servidor: ${response.statusCode}';
      debugPrint('❌ LOGIN ERROR: $message');
      throw Exception(message);
    }
  }

  /// Obtiene los datos del usuario autenticado desde /api/auth/me
  static Future<Map<String, dynamic>> fetchMe() async {
    final url = Uri.parse('$_baseUrl/api/auth/me');
    final token = await getToken();

    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🔵 FETCH ME REQUEST');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ URL: $url');
    debugPrint('│ METHOD: GET');
    debugPrint('└──────────────────────────────────────────');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      },
    );

    final responseBody = response.body;
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🟢 FETCH ME RESPONSE');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ STATUS CODE: ${response.statusCode}');
    debugPrint('│ BODY: $responseBody');
    debugPrint('└──────────────────────────────────────────');

    final responseData = jsonDecode(responseBody) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      final message = responseData['message'] ??
          responseData['error'] ??
          'Error del servidor: ${response.statusCode}';
      debugPrint('❌ FETCH ME ERROR: $message');
      throw Exception(message);
    }
  }

  /// Solicita información de un producto
  static Future<Map<String, dynamic>> requestProductInfo({
    required String productName,
  }) async {
    final url = Uri.parse('$_baseUrl/api/requestProductInfo');
    final token = await getToken();
    final user = await getUser();
    final phone = user?['phone'] as String?;
    final body = jsonEncode({
      'productId': productName,
      'productName': productName,
      'phoneNumber': phone ?? '',
    });

    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🔵 REQUEST PRODUCT INFO');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ URL: $url');
    debugPrint('│ METHOD: POST');
    debugPrint('│ BODY: $body');
    debugPrint('└──────────────────────────────────────────');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      },
      body: body,
    );

    final responseBody = response.body;
    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🟢 REQUEST PRODUCT INFO RESPONSE');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ STATUS CODE: ${response.statusCode}');
    debugPrint('│ BODY: $responseBody');
    debugPrint('└──────────────────────────────────────────');

    final responseData = jsonDecode(responseBody) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final result = responseData['result'] as Map<String, dynamic>?;
      if (result != null && result['ok'] == true) {
        return {
          'ok': true,
          'whatsappUrl': result['whatsappUrl'] as String?,
          'vendorPhone': result['vendorPhone'] as String?,
          'message': result['message'] as String?,
        };
      }
      return responseData;
    } else {
      final message = responseData['message'] ??
          responseData['error'] ??
          'Error del servidor: ${response.statusCode}';
      debugPrint('❌ REQUEST PRODUCT INFO ERROR: $message');
      throw Exception(message);
    }
  }
}
