import 'dart:convert';

import '../logging/app_logger.dart';
import '../session/session_models.dart';
import 'secure_store.dart';

/// Holds the current token in memory and persists it only when allowed.
///
/// * Watch: always persisted (the session lives until shift end).
/// * Mobile: persisted only with "Tetap masuk di perangkat ini". Without it
///   the session ends when the process ends (doc 8.1).
class TokenStore {
  TokenStore(this._secure);

  final SecureStore _secure;
  AuthTokens? _tokens;
  bool _persist = false;

  AuthTokens? get current => _tokens;
  bool get hasSession => _tokens != null;

  /// `session_id` claim of the current token (watch request signing).
  String? get sessionId => _tokens?.sessionId;

  /// Loads the persisted token at startup. Returns null when nothing is
  /// stored or when the user did not ask to stay signed in.
  Future<AuthTokens?> restore() async {
    final remember = await _secure.read(SecureKeys.remember) == 'true';
    if (!remember) {
      // Leftovers from a non-remembered session must not be reused.
      await _secure.write(SecureKeys.accessToken, null);
      return null;
    }
    final raw = await _secure.read(SecureKeys.accessToken);
    if (raw == null) return null;
    final tokens = _decode(raw);
    if (tokens == null) {
      await _secure.write(SecureKeys.accessToken, null);
      return null;
    }
    _persist = true;
    return _tokens = tokens;
  }

  Future<void> save(AuthTokens tokens, {required bool persist}) async {
    _tokens = tokens;
    _persist = persist;
    await _secure.write(SecureKeys.remember, persist ? 'true' : null);
    await _secure.write(
      SecureKeys.accessToken,
      persist ? jsonEncode(tokens.toJson()) : null,
    );
  }

  Future<void> clear() async {
    _tokens = null;
    _persist = false;
    await _secure.write(SecureKeys.remember, null);
    await _secure.write(SecureKeys.accessToken, null);
  }

  bool get persisted => _persist;

  AuthTokens? _decode(String raw) {
    try {
      final json = jsonDecode(raw);
      if (json is Map<String, dynamic>) return AuthTokens.fromJson(json);
    } on FormatException {
      // Fall through.
    } on Object catch (e) {
      AppLogger.warn('Stored token is unreadable', error: e);
    }
    return null;
  }
}
