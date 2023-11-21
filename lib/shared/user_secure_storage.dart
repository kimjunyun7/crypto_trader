import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _accessKey = 'accessKey';
  static const _secretKey = 'secretKey';
  static const _keyJWTToken = 'JWTToken';

  static Future setAccessKey(String key) async =>
      await _storage.write(key: _accessKey, value: key);

  static Future setSecretKey(String key) async =>
      await _storage.write(key: _secretKey, value: key);

  // static Future setJWTToken(String token) async =>
  //     await _storage.write(key: _keyJWTToken, value: token);

  static Future<String?> getAccessKey() async =>
      await _storage.read(key: _accessKey);

  static Future<String?> getSecretKey() async =>
      await _storage.read(key: _secretKey);

  // static Future<String?> getJWTToken() async =>
  //     await _storage.read(key: _keyJWTToken);

  // static Future deleteJWTToken() async =>
  //     await _storage.delete(key: _keyJWTToken);
}
