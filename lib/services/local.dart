import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static final FlutterSecureStorage flutterSecureStorage =
      FlutterSecureStorage();
  static get AcessToken => "ACCESS_TOKEN";
  static Future<void> storeString(String key, String value) {
    return flutterSecureStorage.write(key: key, value: value);
  }

  static Future<String?> getString(String key) {
    return  flutterSecureStorage.read(key: key);
  }

  static Future<void> deleteString(String key) =>
      flutterSecureStorage.delete(key: key);
}
