import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:all_benefits_group/features/auth/data/auth_service.dart';

class RecommendationService {
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

  /// Obtiene las recomendaciones del endpoint /api/recommendations
  static Future<Map<String, dynamic>> fetchRecommendations() async {
    final url = Uri.parse('$_baseUrl/api/recommendations');
    final token = await AuthService.getToken();

    debugPrint('┌──────────────────────────────────────────');
    debugPrint('│ 🔵 RECOMMENDATIONS REQUEST');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ URL: $url');
    debugPrint('│ METHOD: GET');
    debugPrint('│ HEADERS: {Content-Type: application/json, Authorization: Bearer ${token != null && token.isNotEmpty ? '<token_presente>' : '<sin_token>'}}');
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
    debugPrint('│ 🟢 RECOMMENDATIONS RESPONSE');
    debugPrint('├──────────────────────────────────────────');
    debugPrint('│ STATUS CODE: ${response.statusCode}');
    debugPrint('│ BODY: ${responseBody.length > 500 ? responseBody.substring(0, 500) + '...' : responseBody}');
    debugPrint('└──────────────────────────────────────────');

    // Si el status NO es 2xx, extraemos un mensaje legible SIN forzar JSON
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message;
      try {
        final responseData = jsonDecode(responseBody) as Map<String, dynamic>;
        message = responseData['message'] ??
            responseData['error'] ??
            'Error del servidor: ${response.statusCode}';
      } catch (_) {
        // El body no es JSON (ej: HTML de error 404)
        if (response.statusCode == 404) {
          message = 'Endpoint no encontrado (404). Revisa la URL del backend.';
        } else {
          message = 'Error del servidor: ${response.statusCode}';
        }
      }
      debugPrint('❌ RECOMMENDATIONS ERROR: $message');
      throw Exception(message);
    }

    // Status 2xx: intentamos parsear JSON
    try {
      final responseData = jsonDecode(responseBody) as Map<String, dynamic>;
      return responseData;
    } catch (e) {
      debugPrint('❌ RECOMMENDATIONS ERROR: No se pudo parsear JSON — $e');
      throw Exception('Respuesta inválida del servidor. El body no es JSON válido.');
    }
  }
}
