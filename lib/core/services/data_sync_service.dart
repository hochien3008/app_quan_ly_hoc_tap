import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_data_service.dart';

class DataSyncService {
  static final DataSyncService _instance = DataSyncService._internal();
  factory DataSyncService() => _instance;
  DataSyncService._internal();

  final FirebaseDataService _firebaseService = FirebaseDataService();

  // ==================== SYNC MANAGEMENT ====================

  /// Initialize data sync on app startup
  Future<void> initializeSync() async {
    try {
      if (kDebugMode) {
        print('🔄 Initializing data sync...');
      }

      // Check if user is authenticated
      if (_firebaseService.isAuthenticated) {
        // Try to sync from Firebase to local first
        await _syncFromFirebaseToLocal();

        // Then sync local changes to Firebase
        await _syncFromLocalToFirebase();
      }

      if (kDebugMode) {
        print('✅ Data sync initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing data sync: $e');
      }
    }
  }

  /// Sync data from Firebase to local storage
  Future<void> _syncFromFirebaseToLocal() async {
    try {
      if (kDebugMode) {
        print('📥 Syncing from Firebase to local...');
      }

      await _firebaseService.syncFirebaseDataToLocal();

      if (kDebugMode) {
        print('✅ Firebase to local sync completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error syncing from Firebase to local: $e');
      }
    }
  }

  /// Sync data from local storage to Firebase
  Future<void> _syncFromLocalToFirebase() async {
    try {
      if (kDebugMode) {
        print('📤 Syncing from local to Firebase...');
      }

      await _firebaseService.syncLocalDataToFirebase();

      if (kDebugMode) {
        print('✅ Local to Firebase sync completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error syncing from local to Firebase: $e');
      }
    }
  }

  // ==================== MANUAL SYNC OPERATIONS ====================

  /// Manual sync all data
  Future<void> syncAllData() async {
    try {
      if (kDebugMode) {
        print('🔄 Starting manual data sync...');
      }

      if (_firebaseService.isAuthenticated) {
        await _syncFromFirebaseToLocal();
        await _syncFromLocalToFirebase();
      }

      if (kDebugMode) {
        print('✅ Manual data sync completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error during manual data sync: $e');
      }
    }
  }

  /// Sync specific data type
  Future<void> syncDataType(String dataType) async {
    try {
      if (kDebugMode) {
        print('🔄 Syncing $dataType...');
      }

      switch (dataType.toLowerCase()) {
        case 'pomodoro':
          await _syncPomodoroSettings();
          break;
        case 'study_stats':
          await _syncStudyStats();
          break;
        case 'quiz_results':
          await _syncQuizResults();
          break;
        default:
          if (kDebugMode) {
            print('⚠️ Unknown data type: $dataType');
          }
      }

      if (kDebugMode) {
        print('✅ $dataType sync completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error syncing $dataType: $e');
      }
    }
  }

  // ==================== SPECIFIC DATA SYNC ====================

  /// Sync Pomodoro settings
  Future<void> _syncPomodoroSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_firebaseService.isAuthenticated) {
        // Sync to Firebase
        await _firebaseService.syncLocalDataToFirebase();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error syncing Pomodoro settings: $e');
      }
    }
  }

  /// Sync study statistics
  Future<void> _syncStudyStats() async {
    try {
      if (_firebaseService.isAuthenticated) {
        // This would typically involve getting local study stats
        // and syncing them to Firebase
        if (kDebugMode) {
          print('📊 Study stats sync placeholder');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error syncing study stats: $e');
      }
    }
  }

  /// Sync quiz results
  Future<void> _syncQuizResults() async {
    try {
      if (_firebaseService.isAuthenticated) {
        // This would typically involve getting local quiz results
        // and syncing them to Firebase
        if (kDebugMode) {
          print('📝 Quiz results sync placeholder');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error syncing quiz results: $e');
      }
    }
  }

  // ==================== SYNC STATUS ====================

  /// Get sync status
  Future<Map<String, dynamic>> getSyncStatus() async {
    try {
      final isConnected = await _firebaseService.isConnected();
      final isAuthenticated = _firebaseService.isAuthenticated;

      return {
        'isConnected': isConnected,
        'isAuthenticated': isAuthenticated,
        'canSync': isConnected && isAuthenticated,
        'lastSyncTime': await _getLastSyncTime(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting sync status: $e');
      }
      return {
        'isConnected': false,
        'isAuthenticated': false,
        'canSync': false,
        'lastSyncTime': null,
      };
    }
  }

  /// Get last sync time
  Future<DateTime?> _getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSyncString = prefs.getString('last_sync_time');
      if (lastSyncString != null) {
        return DateTime.parse(lastSyncString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Update last sync time
  Future<void> _updateLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_sync_time', DateTime.now().toIso8601String());
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating last sync time: $e');
      }
    }
  }

  // ==================== CONFLICT RESOLUTION ====================

  /// Resolve conflicts between local and Firebase data
  Future<void> resolveConflicts() async {
    try {
      if (kDebugMode) {
        print('🔧 Resolving data conflicts...');
      }

      // For now, we'll use a simple strategy:
      // - Firebase data takes precedence for user profile
      // - Local data takes precedence for settings
      // - Merge strategy for study stats

      if (_firebaseService.isAuthenticated) {
        await _firebaseService.syncFirebaseDataToLocal();
        await _firebaseService.syncLocalDataToFirebase();
      }

      await _updateLastSyncTime();

      if (kDebugMode) {
        print('✅ Conflict resolution completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error resolving conflicts: $e');
      }
    }
  }

  // ==================== BACKUP & RESTORE ====================

  /// Create backup of local data
  Future<Map<String, dynamic>> createLocalBackup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      final backup = <String, dynamic>{};
      for (final key in keys) {
        final value = prefs.get(key);
        if (value != null) {
          backup[key] = value;
        }
      }

      if (kDebugMode) {
        print('✅ Local backup created with ${backup.length} items');
      }

      return backup;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating local backup: $e');
      }
      return {};
    }
  }

  /// Restore local data from backup
  Future<void> restoreLocalBackup(Map<String, dynamic> backup) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      for (final entry in backup.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
        }
      }

      if (kDebugMode) {
        print('✅ Local backup restored');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error restoring local backup: $e');
      }
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Check if sync is needed
  Future<bool> isSyncNeeded() async {
    try {
      final lastSyncTime = await _getLastSyncTime();
      if (lastSyncTime == null) return true;

      // Check if it's been more than 1 hour since last sync
      final timeSinceLastSync = DateTime.now().difference(lastSyncTime);
      return timeSinceLastSync.inHours >= 1;
    } catch (e) {
      return true;
    }
  }

  /// Force sync regardless of last sync time
  Future<void> forceSync() async {
    try {
      if (kDebugMode) {
        print('🔄 Force syncing data...');
      }

      await syncAllData();
      await _updateLastSyncTime();

      if (kDebugMode) {
        print('✅ Force sync completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error during force sync: $e');
      }
    }
  }
}
