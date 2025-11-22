/// Local Storage Service
///
/// Provides persistent storage functionality using SharedPreferences.
/// Handles saving, retrieving, and removing key-value pairs.

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  SharedPreferences? _preferences;

  /// Initialize the service
  /// Must be called before using any storage methods
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Save a string value with the given key
  Future<bool> setString(String key, String value) async {
    if (_preferences == null) {
      throw Exception(
        'LocalStorageService not initialized. Call init() first.',
      );
    }
    return await _preferences!.setString(key, value);
  }

  /// Retrieve a string value by key
  /// Returns null if the key doesn't exist
  String? getString(String key) {
    if (_preferences == null) {
      throw Exception(
        'LocalStorageService not initialized. Call init() first.',
      );
    }
    return _preferences!.getString(key);
  }

  /// Remove a value by key
  Future<bool> remove(String key) async {
    if (_preferences == null) {
      throw Exception(
        'LocalStorageService not initialized. Call init() first.',
      );
    }
    return await _preferences!.remove(key);
  }

  /// Clear all stored values
  Future<bool> clear() async {
    if (_preferences == null) {
      throw Exception(
        'LocalStorageService not initialized. Call init() first.',
      );
    }
    return await _preferences!.clear();
  }
}
