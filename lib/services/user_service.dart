import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lockerroomtalk/models/user.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Create a new user
  Future<void> createUser(AppUser user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.id).set(user.toJson());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get user by ID
  Future<AppUser?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(userId).get();
      if (doc.exists) {
        return AppUser.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Update user
  Future<void> updateUser(AppUser user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.id).update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Search users by username
  Future<List<AppUser>> searchUsers(String query, {int limit = 20}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('username', isLessThan: '${query.toLowerCase()}z')
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => AppUser.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  // Get users by IDs
  Future<List<AppUser>> getUsersByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) return [];
      
      // Firestore has a limit of 10 for 'in' queries
      final batches = <Future<List<AppUser>>>[];
      for (int i = 0; i < userIds.length; i += 10) {
        final batch = userIds.skip(i).take(10).toList();
        batches.add(_getUserBatch(batch));
      }
      
      final results = await Future.wait(batches);
      return results.expand((batch) => batch).toList();
    } catch (e) {
      throw Exception('Failed to get users by IDs: $e');
    }
  }

  Future<List<AppUser>> _getUserBatch(List<String> userIds) async {
    final querySnapshot = await _firestore
        .collection(_usersCollection)
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    return querySnapshot.docs
        .map((doc) => AppUser.fromJson(doc.data()))
        .toList();
  }

  // Follow/Unfollow user
  Future<void> followUser(String currentUserId, String targetUserId) async {
    try {
      final batch = _firestore.batch();
      
      // Add to current user's following list
      final currentUserRef = _firestore.collection(_usersCollection).doc(currentUserId);
      batch.update(currentUserRef, {
        'following': FieldValue.arrayUnion([targetUserId]),
        'stats.following': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Add to target user's followers list
      final targetUserRef = _firestore.collection(_usersCollection).doc(targetUserId);
      batch.update(targetUserRef, {
        'followers': FieldValue.arrayUnion([currentUserId]),
        'stats.followers': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to follow user: $e');
    }
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      final batch = _firestore.batch();
      
      // Remove from current user's following list
      final currentUserRef = _firestore.collection(_usersCollection).doc(currentUserId);
      batch.update(currentUserRef, {
        'following': FieldValue.arrayRemove([targetUserId]),
        'stats.following': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Remove from target user's followers list
      final targetUserRef = _firestore.collection(_usersCollection).doc(targetUserId);
      batch.update(targetUserRef, {
        'followers': FieldValue.arrayRemove([currentUserId]),
        'stats.followers': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to unfollow user: $e');
    }
  }

  // Block/Unblock user
  Future<void> blockUser(String currentUserId, String targetUserId) async {
    try {
      await _firestore.collection(_usersCollection).doc(currentUserId).update({
        'blockedUsers': FieldValue.arrayUnion([targetUserId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  Future<void> unblockUser(String currentUserId, String targetUserId) async {
    try {
      await _firestore.collection(_usersCollection).doc(currentUserId).update({
        'blockedUsers': FieldValue.arrayRemove([targetUserId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }

  // Update user stats
  Future<void> updateUserStats(String userId, Map<String, dynamic> statUpdates) async {
    try {
      final updates = <String, dynamic>{};
      statUpdates.forEach((key, value) {
        updates['stats.$key'] = value;
      });
      updates['updatedAt'] = FieldValue.serverTimestamp();
      
      await _firestore.collection(_usersCollection).doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update user stats: $e');
    }
  }

  // Update user preferences
  Future<void> updateUserPreferences(String userId, UserPreferences preferences) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'preferences': preferences.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update user preferences: $e');
    }
  }

  // Get popular users
  Future<List<AppUser>> getPopularUsers({int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('isBlocked', isEqualTo: false)
          .orderBy('stats.reputation', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => AppUser.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get popular users: $e');
    }
  }

  // Get recent users
  Future<List<AppUser>> getRecentUsers({int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('isBlocked', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => AppUser.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent users: $e');
    }
  }

  // Stream user data
  Stream<AppUser?> streamUser(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return AppUser.fromJson(doc.data()!);
      }
      return null;
    });
  }

  // Check if username is available
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      throw Exception('Failed to check username availability: $e');
    }
  }

  // Update user location
  Future<void> updateUserLocation(String userId, Location location) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'location': location.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update user location: $e');
    }
  }
}