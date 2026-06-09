import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Servicio para autenticación biométrica y almacenamiento seguro de credenciales.
class BiometricAuthService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accountName: 'all_benefits_group_credentials',
    ),
  );

  static const _kEmail = 'saved_email';
  static const _kPassword = 'saved_password';
  static const _kRememberMe = 'remember_me';
  static const _kExplicitLogout = 'explicitly_logged_out';

  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Guarda credenciales de forma segura.
  static Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _kEmail, value: email);
    await _storage.write(key: _kPassword, value: password);
    await _storage.write(key: _kRememberMe, value: 'true');
    debugPrint('🔐 Credenciales guardadas de forma segura');
  }

  /// Borra las credenciales guardadas.
  static Future<void> clearCredentials() async {
    await _storage.delete(key: _kEmail);
    await _storage.delete(key: _kPassword);
    await _storage.delete(key: _kRememberMe);
    debugPrint('🗑️ Credenciales borradas');
  }

  /// Recupera email guardado.
  static Future<String?> getSavedEmail() async {
    return await _storage.read(key: _kEmail);
  }

  /// Recupera password guardado.
  static Future<String?> getSavedPassword() async {
    return await _storage.read(key: _kPassword);
  }

  /// Indica si hay credenciales guardadas.
  static Future<bool> hasSavedCredentials() async {
    final email = await getSavedEmail();
    final password = await getSavedPassword();
    return email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
  }

  // ── Explicit logout flag ──

  /// Marca que el usuario cerró sesión explícitamente.
  static Future<void> markExplicitLogout() async {
    await _storage.write(key: _kExplicitLogout, value: 'true');
    debugPrint('🚪 Logout explícito marcado');
  }

  /// Borra la marca de logout explícito (ej: tras login exitoso).
  static Future<void> clearExplicitLogout() async {
    await _storage.delete(key: _kExplicitLogout);
    debugPrint('🗑️ Marca de logout explícito borrada');
  }

  /// Indica si el usuario cerró sesión explícitamente la última vez.
  static Future<bool> wasExplicitlyLoggedOut() async {
    final value = await _storage.read(key: _kExplicitLogout);
    return value == 'true';
  }

  /// Determina si se debe ofrecer login biométrico al abrir la app.
  static Future<bool> shouldOfferBiometricLogin() async {
    final hasCreds = await hasSavedCredentials();
    final canBio = await canCheckBiometrics();
    final wasExplicit = await wasExplicitlyLoggedOut();
    final result = hasCreds && canBio && !wasExplicit;
    debugPrint('🔐 shouldOfferBiometricLogin=$result (hasCreds=$hasCreds, canBio=$canBio, wasExplicit=$wasExplicit)');
    return result;
  }

  /// Verifica si el dispositivo soporta alguna forma de autenticación biométrica.
  static Future<bool> canCheckBiometrics() async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      debugPrint('🔍 canCheckBiometrics=$canCheck, isDeviceSupported=$isDeviceSupported');
      return canCheck && isDeviceSupported;
    } catch (e) {
      debugPrint('❌ Error verificando biometría: $e');
      return false;
    }
  }

  /// Lista los tipos de biometría disponibles (Face ID, huella, iris, etc.)
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('❌ Error obteniendo biometrías: $e');
      return [];
    }
  }

  /// Retorna un label descriptivo según la biometría disponible.
  static Future<String> getBiometricLabel() async {
    final biometrics = await getAvailableBiometrics();
    if (biometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (biometrics.contains(BiometricType.strong)) {
      return 'Huella digital';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Huella digital';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Reconocimiento de iris';
    }
    return 'Biometría';
  }

  /// Solicita autenticación biométrica.
  /// Retorna true si el usuario se autenticó correctamente.
  static Future<bool> authenticate() async {
    try {
      final label = await getBiometricLabel();
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Usa tu $label para ingresar a USA All Benefits Group',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      debugPrint(didAuthenticate ? '✅ Biometría exitosa' : '⛔ Biometría cancelada');
      return didAuthenticate;
    } catch (e) {
      debugPrint('❌ Error en autenticación biométrica: $e');
      return false;
    }
  }
}
