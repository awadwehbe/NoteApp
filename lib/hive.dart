  import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

  import 'package:hive/hive.dart';
  import 'package:path_provider/path_provider.dart';
  import 'dart:io';

  import 'package:hive_flutter/hive_flutter.dart';

  class SharedPrefsManager {
    static const String _boxName = "preferences";
    static const String _accessTokenKey = "access_token";
    static const String _refreshTokenKey = "refresh_token";
    static const String _tokenExpiryTimeKey = "token_expiry_time";

    static Future<void> init() async {
      await Hive.initFlutter();
      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.openBox<String>(_boxName);
      }
    }

    // Save access token
    static Future<void> saveAccessToken(String token) async {
      var box = await _getBox();
      await box.put(_accessTokenKey, token);
    }

    // Get access token
    static Future<String?> getAccessToken() async {
      var box = await _getBox();
      return box.get(_accessTokenKey);
    }

    // Remove access token
    static Future<void> removeAccessToken() async {
      var box = await _getBox();
      await box.delete(_accessTokenKey);
    }

    // Save refresh token
    static Future<void> saveRefreshToken(String token) async {
      var box = await _getBox();
      await box.put(_refreshTokenKey, token);
    }

    // Get refresh token
    static Future<String?> getRefreshToken() async {
      var box = await _getBox();
      return box.get(_refreshTokenKey);
    }

    // Remove refresh token
    static Future<void> removeRefreshToken() async {
      var box = await _getBox();
      await box.delete(_refreshTokenKey);
    }

    // Clear all stored data (for logout, etc.)
    static Future<void> clearAll() async {
      var box = await _getBox();
      await box.clear();
    }

    // Store access token with expiry time
    static Future<void> storeAccessToken(String accessToken, [Duration? validityDuration]) async {
      var box = await _getBox();
      DateTime expiryTime = DateTime.now().add(validityDuration ?? Duration(hours: 1)); // Default to 1 hour if no validityDuration is provided
      await box.put(_accessTokenKey, accessToken);
      await box.put(_tokenExpiryTimeKey, expiryTime.toIso8601String());
    }

    // Get token expiry time
    static Future<DateTime?> getTokenExpiryTime() async {
      var box = await _getBox();
      String? expiryTimeString = box.get(_tokenExpiryTimeKey);
      if (expiryTimeString != null) {
        return DateTime.parse(expiryTimeString);
      }
      return null;
    }

    // Check if the token is expired
    static Future<bool> isTokenExpired() async {
      final expiryTime = await getTokenExpiryTime();
      if (expiryTime != null) {
        return DateTime.now().isAfter(expiryTime);
      }
      return true; // Assume expired if expiry time is not found
    }

    // Private method to get the box, ensuring it is open before accessing it
    static Future<Box<String>> _getBox() async {
      if (!Hive.isBoxOpen(_boxName)) {
        return await Hive.openBox<String>(_boxName);
      }
      return Hive.box<String>(_boxName);
    }
  }
