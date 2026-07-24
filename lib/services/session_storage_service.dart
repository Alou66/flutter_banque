import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persiste le jeton de session (JWT) de façon sécurisée, pour qu'il
/// survive au redémarrage de l'app une fois le backend réel branché.
class SessionStorageService {
  SessionStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'session_token';

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> deleteToken() => _storage.delete(key: _tokenKey);
}
