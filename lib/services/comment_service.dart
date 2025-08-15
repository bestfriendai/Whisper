import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisperdate/models/user.dart';

class Comment {
  final String id;
  final String reviewId;
  final String authorId;
  final String content;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAnonymous;
  final String? parentCommentId; // For replies
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.reviewId,
    required this.authorId,
    required this.content,
    this.likes = 0,
    this.likedBy = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isAnonymous = false,
    this.parentCommentId,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      reviewId: json['reviewId'] ?? '',
      authorId: json['authorId'] ?? '',
      content: json['content'] ?? '',
      likes: json['likes'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: json['updatedAt']?.toDate() ?? DateTime.now(),
      isAnonymous: json['isAnonymous'] ?? false,
      parentCommentId: json['parentCommentId'],
      replies: (json['replies'] as List<dynamic>?)
          ?.map((r) => Comment.fromJson(r))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewId': reviewId,
      'authorId': authorId,
      'content': content,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isAnonymous': isAnonymous,
      'parentCommentId': parentCommentId,
      'replies': replies.map((r) => r.toJson()).toList(),
    };
  }

  Comment copyWith({
    String? content,
    int? likes,
    List<String>? likedBy,
    DateTime? updatedAt,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id,
      reviewId: reviewId,
      authorId: authorId,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isAnonymous: isAnonymous,
      parentCommentId: parentCommentId,
      replies: replies ?? this.replies,
    );
  }
}

class CommentService {
  static final CommentService _instance = CommentService._internal();
  factory CommentService() => _instance;
  CommentService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _commentsCollection = 'comments';

  // Create a comment
  Future<String> createComment(Comment comment) async {
    try {
      final docRef = await _firestore.collection(_commentsCollection).add(comment.toJson());
      
      // Update the comment with its generated ID
      await docRef.update({'id': docRef.id});
      
      // Update review comment count
      await _updateReviewCommentCount(comment.reviewId, 1);
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  // Get comments for a review
  Future<List<Comment>> getComments(String reviewId, {int limit = 50}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_commentsCollection)
          .where('reviewId', isEqualTo: reviewId)
          .where('parentCommentId', isNull: true) // Only top-level comments
          .orderBy('createdAt', descending: false)
          .limit(limit)
          .get();

      final comments = <Comment>[];
      
      for (final doc in querySnapshot.docs) {
        final comment = Comment.fromJson(doc.data());
        
        // Get replies for this comment
        final replies = await getReplies(comment.id);
        
        comments.add(comment.copyWith(replies: replies));
      }

      return comments;
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  // Get replies for a comment
  Future<List<Comment>> getReplies(String commentId, {int limit = 20}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_commentsCollection)
          .where('parentCommentId', isEqualTo: commentId)
          .orderBy('createdAt', descending: false)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Comment.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get replies: $e');
    }
  }

  // Stream comments for a review
  Stream<List<Comment>> streamComments(String reviewId) {
    return _firestore
        .collection(_commentsCollection)
        .where('reviewId', isEqualTo: reviewId)
        .where('parentCommentId', isNull: true)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .asyncMap((snapshot) async {
      final comments = <Comment>[];
      
      for (final doc in snapshot.docs) {
        final comment = Comment.fromJson({
          ...doc.data(),
          'id': doc.id,
        });
        
        // Get replies for this comment
        final replies = await getReplies(comment.id);
        
        comments.add(comment.copyWith(replies: replies));
      }

      return comments;
    });
  }

  // Update comment
  Future<void> updateComment(Comment comment) async {
    try {
      await _firestore.collection(_commentsCollection).doc(comment.id).update(comment.toJson());
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  // Delete comment
  Future<void> deleteComment(String commentId, String reviewId) async {
    try {
      final batch = _firestore.batch();
      
      // Delete the comment
      final commentRef = _firestore.collection(_commentsCollection).doc(commentId);
      batch.delete(commentRef);
      
      // Delete all replies to this comment
      final repliesSnapshot = await _firestore
          .collection(_commentsCollection)
          .where('parentCommentId', isEqualTo: commentId)
          .get();
      
      for (final doc in repliesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      
      // Update review comment count
      await _updateReviewCommentCount(reviewId, -1 - repliesSnapshot.docs.length);
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  // Like/Unlike comment
  Future<void> likeComment(String commentId, String userId) async {
    try {
      await _firestore.collection(_commentsCollection).doc(commentId).update({
        'likedBy': FieldValue.arrayUnion([userId]),
        'likes': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to like comment: $e');
    }
  }

  Future<void> unlikeComment(String commentId, String userId) async {
    try {
      await _firestore.collection(_commentsCollection).doc(commentId).update({
        'likedBy': FieldValue.arrayRemove([userId]),
        'likes': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to unlike comment: $e');
    }
  }

  // Report comment
  Future<void> reportComment(String commentId, String userId, String reason) async {
    try {
      await _firestore.collection('reports').add({
        'commentId': commentId,
        'reporterId': userId,
        'reason': reason,
        'type': 'comment',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to report comment: $e');
    }
  }

  // Get comment count for review
  Future<int> getCommentCount(String reviewId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_commentsCollection)
          .where('reviewId', isEqualTo: reviewId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  // Update review comment count
  Future<void> _updateReviewCommentCount(String reviewId, int increment) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).update({
        'stats.comments': FieldValue.increment(increment),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignore errors for now
    }
  }

  // Get mock comments for development
  List<Comment> getMockComments(String reviewId) {
    return [
      Comment(
        id: '1',
        reviewId: reviewId,
        authorId: 'user1',
        content: 'This is such a detailed and honest review! Thanks for sharing your experience 👏',
        likes: 12,
        likedBy: ['user2', 'user3', 'user4'],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        replies: [
          Comment(
            id: '2',
            reviewId: reviewId,
            authorId: 'user2',
            content: 'I completely agree! This kind of honesty is exactly what we need more of.',
            parentCommentId: '1',
            likes: 5,
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      ),
      Comment(
        id: '3',
        reviewId: reviewId,
        authorId: 'user3',
        content: 'I had a similar experience at that same coffee shop! The ambiance really does make a difference for first dates.',
        likes: 8,
        likedBy: ['user1', 'user4'],
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      Comment(
        id: '4',
        reviewId: reviewId,
        authorId: 'user4',
        content: 'Great tip about arriving early to get a good table! That\'s actually genius 🧠',
        likes: 15,
        likedBy: ['user1', 'user2', 'user3'],
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Comment(
        id: '5',
        reviewId: reviewId,
        authorId: 'user5',
        content: 'This person sounds like a keeper! Hope it works out for you both 💕',
        likes: 20,
        likedBy: ['user1', 'user2', 'user3', 'user4'],
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        isAnonymous: true,
      ),
    ];
  }
}