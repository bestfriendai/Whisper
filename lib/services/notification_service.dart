import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  like,
  comment,
  follow,
  message,
  review,
  system,
}

class NotificationData {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  NotificationData({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      data: json['data'],
      isRead: json['isRead'] ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'title': title,
      'body': body,
      'data': data,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  NotificationData copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _notificationsCollection = 'notifications';

  // Create a notification
  Future<void> createNotification(NotificationData notification) async {
    try {
      await _firestore.collection(_notificationsCollection).add(notification.toJson());
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  // Get user notifications
  Future<List<NotificationData>> getUserNotifications(
    String userId, {
    int limit = 50,
    bool unreadOnly = false,
  }) async {
    try {
      Query query = _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId);

      if (unreadOnly) {
        query = query.where('isRead', isEqualTo: false);
      }

      query = query.orderBy('createdAt', descending: true).limit(limit);

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => NotificationData.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user notifications: $e');
    }
  }

  // Stream user notifications
  Stream<List<NotificationData>> streamUserNotifications(
    String userId, {
    int limit = 50,
    bool unreadOnly = false,
  }) {
    Query query = _firestore
        .collection(_notificationsCollection)
        .where('userId', isEqualTo: userId);

    if (unreadOnly) {
      query = query.where('isRead', isEqualTo: false);
    }

    query = query.orderBy('createdAt', descending: true).limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationData.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    });
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection(_notificationsCollection).doc(notificationId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Mark all notifications as read for a user
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      
      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection(_notificationsCollection).doc(notificationId).delete();
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  // Delete all notifications for a user
  Future<void> deleteAllNotifications(String userId) async {
    try {
      final batch = _firestore.batch();
      
      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete all notifications: $e');
    }
  }

  // Get unread count
  Future<int> getUnreadCount(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  // Stream unread count
  Stream<int> streamUnreadCount(String userId) {
    return _firestore
        .collection(_notificationsCollection)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Helper methods for creating specific notification types

  // Like notification
  Future<void> sendLikeNotification({
    required String toUserId,
    required String fromUserId,
    required String fromUsername,
    required String reviewId,
    required String reviewTitle,
  }) async {
    // Don't send notification to self
    if (toUserId == fromUserId) return;

    final notification = NotificationData(
      id: '',
      userId: toUserId,
      type: NotificationType.like,
      title: 'New Like!',
      body: '$fromUsername liked your review "$reviewTitle"',
      data: {
        'fromUserId': fromUserId,
        'reviewId': reviewId,
        'action': 'like',
      },
      createdAt: DateTime.now(),
    );

    await createNotification(notification);
  }

  // Comment notification
  Future<void> sendCommentNotification({
    required String toUserId,
    required String fromUserId,
    required String fromUsername,
    required String reviewId,
    required String reviewTitle,
    required String commentText,
  }) async {
    // Don't send notification to self
    if (toUserId == fromUserId) return;

    final notification = NotificationData(
      id: '',
      userId: toUserId,
      type: NotificationType.comment,
      title: 'New Comment!',
      body: '$fromUsername commented on your review "$reviewTitle": ${commentText.length > 50 ? '${commentText.substring(0, 50)}...' : commentText}',
      data: {
        'fromUserId': fromUserId,
        'reviewId': reviewId,
        'action': 'comment',
      },
      createdAt: DateTime.now(),
    );

    await createNotification(notification);
  }

  // Follow notification
  Future<void> sendFollowNotification({
    required String toUserId,
    required String fromUserId,
    required String fromUsername,
  }) async {
    // Don't send notification to self
    if (toUserId == fromUserId) return;

    final notification = NotificationData(
      id: '',
      userId: toUserId,
      type: NotificationType.follow,
      title: 'New Follower!',
      body: '$fromUsername started following you',
      data: {
        'fromUserId': fromUserId,
        'action': 'follow',
      },
      createdAt: DateTime.now(),
    );

    await createNotification(notification);
  }

  // Message notification
  Future<void> sendMessageNotification({
    required String toUserId,
    required String fromUserId,
    required String fromUsername,
    required String chatRoomId,
    required String messageText,
  }) async {
    // Don't send notification to self
    if (toUserId == fromUserId) return;

    final notification = NotificationData(
      id: '',
      userId: toUserId,
      type: NotificationType.message,
      title: 'New Message!',
      body: '$fromUsername: ${messageText.length > 50 ? '${messageText.substring(0, 50)}...' : messageText}',
      data: {
        'fromUserId': fromUserId,
        'chatRoomId': chatRoomId,
        'action': 'message',
      },
      createdAt: DateTime.now(),
    );

    await createNotification(notification);
  }

  // System notification
  Future<void> sendSystemNotification({
    required String toUserId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final notification = NotificationData(
      id: '',
      userId: toUserId,
      type: NotificationType.system,
      title: title,
      body: body,
      data: data,
      createdAt: DateTime.now(),
    );

    await createNotification(notification);
  }

  // Review notification (when someone posts a review about you)
  Future<void> sendReviewNotification({
    required String toUserId,
    required String fromUserId,
    required String fromUsername,
    required String reviewId,
    required String reviewTitle,
  }) async {
    // Don't send notification to self
    if (toUserId == fromUserId) return;

    final notification = NotificationData(
      id: '',
      userId: toUserId,
      type: NotificationType.review,
      title: 'New Review About You!',
      body: '$fromUsername posted a review about you: "$reviewTitle"',
      data: {
        'fromUserId': fromUserId,
        'reviewId': reviewId,
        'action': 'review',
      },
      createdAt: DateTime.now(),
    );

    await createNotification(notification);
  }
}