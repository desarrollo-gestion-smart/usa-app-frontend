import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:all_benefits_group/features/auth/data/auth_service.dart';

class MyServicesService {
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

  /// Obtiene los servicios del usuario autenticado desde /api/users/{id}
  /// enviando el id del usuario como parámetro uid.
  static Future<Map<String, dynamic>> fetchUserServices() async {
    final user = await AuthService.getUser();
    final userId = user?['id'] ?? user?['uid'] ?? user?['_id'];
    if (userId == null || userId.toString().isEmpty) {
      throw Exception('No se encontró el ID del usuario. Inicia sesión de nuevo.');
    }

    final url = Uri.parse('$_baseUrl/api/users/$userId?uid=$userId');
    final token = await AuthService.getToken();

    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🔵 MY SERVICES REQUEST');
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
    debugPrint('│ 🟢 MY SERVICES RESPONSE');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ STATUS CODE: ${response.statusCode}');
    debugPrint('│ BODY: ${responseBody.length > 800 ? '${responseBody.substring(0, 800)}...' : responseBody}');
    debugPrint('└──────────────────────────────────────────');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message;
      try {
        final responseData = jsonDecode(responseBody) as Map<String, dynamic>;
        message = responseData['message'] ??
            responseData['error'] ??
            'Error del servidor: ${response.statusCode}';
      } catch (_) {
        message = 'Error del servidor: ${response.statusCode}';
      }
      debugPrint('❌ MY SERVICES ERROR: $message');
      throw Exception(message);
    }

    try {
      final responseData = jsonDecode(responseBody) as Map<String, dynamic>;
      return responseData;
    } catch (e) {
      debugPrint('❌ MY SERVICES ERROR: No se pudo parsear JSON — $e');
      throw Exception('Respuesta inválida del servidor.');
    }
  }
}
