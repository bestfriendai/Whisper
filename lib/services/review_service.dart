import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whisperdate/models/review.dart';

class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _reviewsCollection = 'reviews';

  // Create a new review
  Future<String> createReview(Review review) async {
    try {
      final docRef = await _firestore.collection(_reviewsCollection).add(review.toJson());
      
      // Update the review with its generated ID
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  // Get review by ID
  Future<Review?> getReview(String reviewId) async {
    try {
      final doc = await _firestore.collection(_reviewsCollection).doc(reviewId).get();
      if (doc.exists) {
        return Review.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get review: $e');
    }
  }

  // Update review
  Future<void> updateReview(Review review) async {
    try {
      await _firestore.collection(_reviewsCollection).doc(review.id).update(review.toJson());
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  // Delete review
  Future<void> deleteReview(String reviewId) async {
    try {
      await _firestore.collection(_reviewsCollection).doc(reviewId).delete();
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }

  // Get reviews with pagination
  Future<List<Review>> getReviews({
    int limit = 20,
    DocumentSnapshot? startAfterDoc,
    String? category,
    String? sortBy = 'createdAt',
    bool descending = true,
  }) async {
    try {
      Query query = _firestore.collection(_reviewsCollection);

      // Apply category filter if specified
      if (category != null && category != 'all') {
        query = query.where('category', isEqualTo: category);
      }

      // Apply sorting
      query = query.orderBy(sortBy!, descending: descending);

      // Apply pagination
      if (startAfterDoc != null) {
        query = query.startAfterDocument(startAfterDoc);
      }

      query = query.limit(limit);

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => Review.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get reviews: $e');
    }
  }

  // Get reviews by user ID
  Future<List<Review>> getReviewsByUser(String userId, {int limit = 20}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_reviewsCollection)
          .where('authorId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Review.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user reviews: $e');
    }
  }

  // Search reviews
  Future<List<Review>> searchReviews(String query, {int limit = 20}) async {
    try {
      // For basic text search, we'll search in title and content
      // In production, you might want to use Algolia or similar for advanced search
      final querySnapshot = await _firestore
          .collection(_reviewsCollection)
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: '${query}z')
          .orderBy('title')
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Review.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search reviews: $e');
    }
  }

  // Get popular reviews
  Future<List<Review>> getPopularReviews({int limit = 20}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_reviewsCollection)
          .where('isVisible', isEqualTo: true)
          .orderBy('stats.likes', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Review.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get popular reviews: $e');
    }
  }

  // Get recent reviews
  Future<List<Review>> getRecentReviews({int limit = 20}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_reviewsCollection)
          .where('isVisible', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Review.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent reviews: $e');
    }
  }

  // Get nearby reviews
  Future<List<Review>> getNearbyReviews(double lat, double lng, double radiusKm, {int limit = 20}) async {
    try {
      // For demonstration, we'll get all reviews and filter by distance
      // In production, use GeoFirestore or similar for efficient geo queries
      final querySnapshot = await _firestore
          .collection(_reviewsCollection)
          .where('isVisible', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit * 2) // Get more to account for filtering
          .get();

      final reviews = querySnapshot.docs
          .map((doc) => Review.fromJson(doc.data()))
          .where((review) {
            if (review.location.coords != null) {
              final distance = _calculateDistance(
                lat, lng,
                review.location.coords!.lat,
                review.location.coords!.lng,
              );
              return distance <= radiusKm;
            }
            return false;
          })
          .take(limit)
          .toList();

      return reviews;
    } catch (e) {
      throw Exception('Failed to get nearby reviews: $e');
    }
  }

  // Like/Unlike review
  Future<void> likeReview(String reviewId, String userId) async {
    try {
      final batch = _firestore.batch();
      
      final reviewRef = _firestore.collection(_reviewsCollection).doc(reviewId);
      batch.update(reviewRef, {
        'likedBy': FieldValue.arrayUnion([userId]),
        'stats.likes': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to like review: $e');
    }
  }

  Future<void> unlikeReview(String reviewId, String userId) async {
    try {
      final batch = _firestore.batch();
      
      final reviewRef = _firestore.collection(_reviewsCollection).doc(reviewId);
      batch.update(reviewRef, {
        'likedBy': FieldValue.arrayRemove([userId]),
        'stats.likes': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to unlike review: $e');
    }
  }

  // Save/Unsave review
  Future<void> saveReview(String reviewId, String userId) async {
    try {
      final reviewRef = _firestore.collection(_reviewsCollection).doc(reviewId);
      await reviewRef.update({
        'savedBy': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save review: $e');
    }
  }

  Future<void> unsaveReview(String reviewId, String userId) async {
    try {
      final reviewRef = _firestore.collection(_reviewsCollection).doc(reviewId);
      await reviewRef.update({
        'savedBy': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to unsave review: $e');
    }
  }

  // Get saved reviews by user
  Future<List<Review>> getSavedReviews(String userId, {int limit = 20}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_reviewsCollection)
          .where('savedBy', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Review.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get saved reviews: $e');
    }
  }

  // Increment view count
  Future<void> incrementViewCount(String reviewId) async {
    try {
      await _firestore.collection(_reviewsCollection).doc(reviewId).update({
        'stats.views': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to increment view count: $e');
    }
  }

  // Report review
  Future<void> reportReview(String reviewId, String userId, String reason) async {
    try {
      await _firestore.collection('reports').add({
        'reviewId': reviewId,
        'reporterId': userId,
        'reason': reason,
        'type': 'review',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to report review: $e');
    }
  }

  // Get reviews with advanced filters
  Future<List<Review>> getFilteredReviews({
    List<String>? categories,
    List<int>? ratings,
    String? location,
    DateTimeRange? dateRange,
    String? sortBy = 'createdAt',
    bool descending = true,
    int limit = 20,
  }) async {
    try {
      Query query = _firestore.collection(_reviewsCollection)
          .where('isVisible', isEqualTo: true);

      // Apply category filter
      if (categories != null && categories.isNotEmpty) {
        query = query.where('category', whereIn: categories);
      }

      // Apply rating filter
      if (ratings != null && ratings.isNotEmpty) {
        query = query.where('rating', whereIn: ratings);
      }

      // Apply location filter
      if (location != null && location.isNotEmpty) {
        query = query.where('location.city', isEqualTo: location);
      }

      // Apply date range filter
      if (dateRange != null) {
        query = query
            .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(dateRange.start))
            .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(dateRange.end));
      }

      // Apply sorting
      query = query.orderBy(sortBy!, descending: descending).limit(limit);

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => Review.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get filtered reviews: $e');
    }
  }

  // Stream reviews
  Stream<List<Review>> streamReviews({
    int limit = 20,
    String? category,
    String? sortBy = 'createdAt',
    bool descending = true,
  }) {
    Query query = _firestore.collection(_reviewsCollection)
        .where('isVisible', isEqualTo: true);

    if (category != null && category != 'all') {
      query = query.where('category', isEqualTo: category);
    }

    query = query.orderBy(sortBy!, descending: descending).limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Review.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Calculate distance between two coordinates (Haversine formula)
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final double dLat = _toRadians(lat2 - lat1);
    final double dLng = _toRadians(lng2 - lng1);
    
    final double a = 
        (dLat / 2) * (dLat / 2) * 1 +
        1 * (lat1) * 1 * (lat2) *
        (dLng / 2) * (dLng / 2) * 1;
    final double c = 2 * 1;
    
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (3.14159265359 / 180);
  }
}