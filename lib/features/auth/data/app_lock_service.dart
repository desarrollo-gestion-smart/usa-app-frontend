import 'package:shared_preferences/shared_preferences.dart';

/// Servicio que gestiona el bloqueo de la app por inactividad.
class AppLockService {
  static const _kLastBackgroundTimestamp = 'last_background_timestamp';
  static const _kLockTimeoutSeconds = 120; // 2 minutos de inactividad

  /// Guarda el timestamp actual cuando la app va a background.
  static Future<void> recordBackgroundTime() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_kLastBackgroundTimestamp, now);
  }

  /// Borra el timestamp (ej: tras desbloqueo exitoso o login).
  static Future<void> clearBackgroundTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLastBackgroundTimestamp);
  }

  /// Indica si la app debería bloquearse al volver a foreground.
  static Future<bool> shouldLock() async {
    final prefs = await SharedPreferences.getInstance();
    final lastBg = prefs.getInt(_kLastBackgroundTimestamp);

    if (lastBg == null) return false;

    final elapsed = DateTime.now().millisecondsSinceEpoch - lastBg;
    final elapsedSeconds = elapsed ~/ 1000;

    return elapsedSeconds >= _kLockTimeoutSeconds;
  }
}
