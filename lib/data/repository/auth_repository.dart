import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/user_model.dart';

class AuthRepository {
  static const String userKey = 'user_data';
  static const String fileName = 'user_backup.json';
  static const String appFolderName = 'basic_chat_app'; // Replace with your app name

  // DUAL STORAGE STRATEGY:
  // 1. SharedPreferences (primary) - fast access, cleared on uninstall
  // 2. External storage (backup) - survives uninstall

  /// Save user to both SharedPreferences and persistent storage
  Future<void> saveUser(UserModel user) async {
    try {
      // Primary: Save to SharedPreferences (fast access)
      await _saveToSharedPrefs(user);
      
      // Backup: Save to persistent storage (survives uninstall)
      await _saveToPersistentStorage(user);
      
      print('✅ User saved to both local and persistent storage');
    } catch (e) {
      print('❌ Error saving user: $e');
      rethrow;
    }
  }

  /// Get user with fallback strategy
  Future<UserModel?> getUser() async {
    try {
      // Try SharedPreferences first (faster)
      UserModel? user = await _getUserFromSharedPrefs();
      
      if (user != null) {
        print('📱 User loaded from SharedPreferences');
        return user;
      }

      // Fallback: Try persistent storage (in case app was reinstalled)
      user = await _getUserFromPersistentStorage();
      
      if (user != null) {
        print('💾 User restored from persistent storage');
        // Restore to SharedPreferences for future fast access
        await _saveToSharedPrefs(user);
        return user;
      }

      print('👤 No user data found');
      return null;
    } catch (e) {
      print('❌ Error getting user: $e');
      return null;
    }
  }

  /// Clear user from both storages
  Future<void> clearUser() async {
    try {
      // Clear from SharedPreferences
      await _clearFromSharedPrefs();
      
      // Clear from persistent storage
      await _clearFromPersistentStorage();
      
      print('🗑️ User data cleared from both storages');
    } catch (e) {
      print('❌ Error clearing user: $e');
    }
  }

  /// Check if user exists in either storage
  Future<bool> hasUser() async {
    try {
      // Check SharedPreferences first
      if (await _hasUserInSharedPrefs()) {
        return true;
      }
      
      // Check persistent storage
      return await _hasUserInPersistentStorage();
    } catch (e) {
      print('❌ Error checking user existence: $e');
      return false;
    }
  }

  /// Sync data between storages (useful for data recovery)
  Future<void> syncStorages() async {
    try {
      final user = await getUser();
      if (user != null) {
        await saveUser(user);
        print('🔄 Storage sync completed');
      }
    } catch (e) {
      print('❌ Error syncing storages: $e');
    }
  }

  // ===== SHARED PREFERENCES METHODS =====

  Future<void> _saveToSharedPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> _getUserFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(userKey);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  Future<void> _clearFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }

  Future<bool> _hasUserInSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(userKey);
  }

  // ===== PERSISTENT STORAGE METHODS =====

  Future<String?> get _persistentFilePath async {
    try {
      if (Platform.isAndroid) {
        if (await _requestStoragePermission()) {
          final dir = await _getPublicDirectory();
          if (dir != null) {
            final appDir = Directory('${dir.path}/$appFolderName');
            if (!await appDir.exists()) {
              await appDir.create(recursive: true);
            }
            return '${appDir.path}/$fileName';
          }
        }
      } else if (Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        return '${dir.path}/$fileName';
      }
      return null;
    } catch (e) {
      print('Error getting persistent file path: $e');
      return null;
    }
  }

  Future<Directory?> _getPublicDirectory() async {
    try {
      // Try Downloads directory first
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (await downloadDir.exists()) {
        return downloadDir;
      }

      // Fallback to Documents
      final documentsDir = Directory('/storage/emulated/0/Documents');
      if (await documentsDir.exists()) {
        return documentsDir;
      }

      // Last resort: External storage root
      final externalDir = Directory('/storage/emulated/0');
      if (await externalDir.exists()) {
        return externalDir;
      }

      return null;
    } catch (e) {
      print('Error getting public directory: $e');
      return null;
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      // Check if permission is already granted
      if (await Permission.storage.isGranted || 
          await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // Request permission
      var status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      
      return status.isGranted;
    } catch (e) {
      print('Error requesting storage permission: $e');
      return false;
    }
  }

  Future<void> _saveToPersistentStorage(UserModel user) async {
    try {
      final path = await _persistentFilePath;
      if (path == null) {
        print('⚠️ Could not get persistent storage path');
        return;
      }

      final file = File(path);
      final jsonData = jsonEncode(user.toJson());
      await file.writeAsString(jsonData);
      
      print('💾 User backed up to: $path');
    } catch (e) {
      print('❌ Error saving to persistent storage: $e');
    }
  }

  Future<UserModel?> _getUserFromPersistentStorage() async {
    try {
      final path = await _persistentFilePath;
      if (path == null) return null;

      final file = File(path);
      if (!await file.exists()) return null;

      final jsonData = await file.readAsString();
      return UserModel.fromJson(jsonDecode(jsonData));
    } catch (e) {
      print('❌ Error getting user from persistent storage: $e');
      return null;
    }
  }

  Future<void> _clearFromPersistentStorage() async {
    try {
      final path = await _persistentFilePath;
      if (path == null) return;

      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('❌ Error clearing persistent storage: $e');
    }
  }

  Future<bool> _hasUserInPersistentStorage() async {
    try {
      final path = await _persistentFilePath;
      if (path == null) return false;

      final file = File(path);
      return await file.exists();
    } catch (e) {
      print('❌ Error checking persistent storage: $e');
      return false;
    }
  }

  // ===== UTILITY METHODS =====

  /// Get storage information for debugging
  Future<Map<String, dynamic>> getStorageInfo() async {
    return {
      'hasSharedPrefs': await _hasUserInSharedPrefs(),
      'hasPersistentStorage': await _hasUserInPersistentStorage(),
      'persistentPath': await _persistentFilePath,
      'storagePermission': Platform.isAndroid ? 
        await Permission.storage.isGranted : true,
    };
  }

  /// Force restore from persistent storage
  Future<UserModel?> restoreFromBackup() async {
    try {
      final user = await _getUserFromPersistentStorage();
      if (user != null) {
        await _saveToSharedPrefs(user);
        print('🔄 User restored from backup');
      }
      return user;
    } catch (e) {
      print('❌ Error restoring from backup: $e');
      return null;
    }
  }
}