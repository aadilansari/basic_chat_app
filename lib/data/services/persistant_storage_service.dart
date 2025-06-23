// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../models/user_model.dart';

// class PersistentStorageService {
//   static const String fileName = 'user_data.json';
//   static const String appFolderName = 'basic_chat_app'; 

//   /// Get file path for persistent storage (survives uninstall)
//   Future<String?> get _persistentFilePath async {
//     try {
//       if (Platform.isAndroid) {
//         if (await _requestStoragePermission()) {
//           // For Android: Use public Documents directory or Downloads
//           final dir = await _getPublicDirectory();
//           if (dir != null) {
//             final appDir = Directory('${dir.path}/$appFolderName');
//             if (!await appDir.exists()) {
//               await appDir.create(recursive: true);
//             }
//             return '${appDir.path}/$fileName';
//           }
//         }
//       } else if (Platform.isIOS) {
//         // For iOS: Use Documents directory (gets backed up to iCloud)
//         final dir = await getApplicationDocumentsDirectory();
//         return '${dir.path}/$fileName';
//       }
//       return null;
//     } catch (e) {
//       print('Error getting persistent file path: $e');
//       return null;
//     }
//   }

//   /// Get public directory that survives app uninstall
//   Future<Directory?> _getPublicDirectory() async {
//     try {
//       // Try to get Downloads directory first (most reliable)
//       final downloadDir = Directory('/storage/emulated/0/Download');
//       if (await downloadDir.exists()) {
//         return downloadDir;
//       }

//       // Fallback to Documents
//       final documentsDir = Directory('/storage/emulated/0/Documents');
//       if (await documentsDir.exists()) {
//         return documentsDir;
//       }

//       // Last resort: External storage root
//       final externalDir = Directory('/storage/emulated/0');
//       if (await externalDir.exists()) {
//         return externalDir;
//       }

//       return null;
//     } catch (e) {
//       print('Error getting public directory: $e');
//       return null;
//     }
//   }

//   /// Request appropriate storage permissions based on Android version
//   Future<bool> _requestStoragePermission() async {
//     if (!Platform.isAndroid) return true;

//     try {
//       // For Android 13+ (API 33+)
//       if (await _isAndroid13OrHigher()) {
//         // Request specific media permissions instead of broad storage
//         var status = await Permission.photos.request();
//         if (!status.isGranted) {
//           status = await Permission.manageExternalStorage.request();
//         }
//         return status.isGranted;
//       } 
//       // For Android 11-12 (API 30-32)
//       else if (await _isAndroid11OrHigher()) {
//         var status = await Permission.manageExternalStorage.request();
//         if (!status.isGranted) {
//           // Fallback to legacy storage permission
//           status = await Permission.storage.request();
//         }
//         return status.isGranted;
//       }
//       // For Android 10 and below
//       else {
//         var status = await Permission.storage.request();
//         return status.isGranted;
//       }
//     } catch (e) {
//       print('Error requesting storage permission: $e');
//       return false;
//     }
//   }

//   /// Check if Android version is 13+ (API 33+)
//   Future<bool> _isAndroid13OrHigher() async {
//     // This is a simplified check - you might want to use device_info_plus for accurate version checking
//     return Platform.isAndroid; // Placeholder - implement proper version check
//   }

//   /// Check if Android version is 11+ (API 30+)
//   Future<bool> _isAndroid11OrHigher() async {
//     // This is a simplified check - you might want to use device_info_plus for accurate version checking
//     return Platform.isAndroid; // Placeholder - implement proper version check
//   }

//   /// Save user data to persistent storage
//   Future<bool> saveUser(UserModel user) async {
//     try {
//       final path = await _persistentFilePath;
//       if (path == null) {
//         print('Could not get persistent file path');
//         return false;
//       }

//       final file = File(path);
//       final jsonData = jsonEncode(user.toJson());
//       await file.writeAsString(jsonData);
      
//       print('User data saved to: $path');
//       return true;
//     } catch (e) {
//       print('Error saving user to persistent storage: $e');
//       return false;
//     }
//   }

//   /// Get user data from persistent storage
//   Future<UserModel?> getUser() async {
//     try {
//       final path = await _persistentFilePath;
//       if (path == null) return null;

//       final file = File(path);
//       if (!await file.exists()) {
//         print('User data file does not exist at: $path');
//         return null;
//       }

//       final jsonData = await file.readAsString();
//       final userData = UserModel.fromJson(jsonDecode(jsonData));
//       print('User data loaded from: $path');
//       return userData;
//     } catch (e) {
//       print('Error getting user from persistent storage: $e');
//       return null;
//     }
//   }

//   /// Clear user data from persistent storage
//   Future<bool> clearUser() async {
//     try {
//       final path = await _persistentFilePath;
//       if (path == null) return false;

//       final file = File(path);
//       if (await file.exists()) {
//         await file.delete();
//         print('User data cleared from: $path');
//       }
//       return true;
//     } catch (e) {
//       print('Error clearing user from persistent storage: $e');
//       return false;
//     }
//   }

//   /// Check if user data exists in persistent storage
//   Future<bool> hasUserData() async {
//     try {
//       final path = await _persistentFilePath;
//       if (path == null) return false;

//       final file = File(path);
//       return await file.exists();
//     } catch (e) {
//       print('Error checking user data existence: $e');
//       return false;
//     }
//   }

//   /// Get the actual file path (for debugging)
//   Future<String?> getStoragePath() async {
//     return await _persistentFilePath;
//   }
// }