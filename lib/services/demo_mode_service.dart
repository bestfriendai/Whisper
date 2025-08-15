import 'dart:async';
import 'package:lockerroomtalk/models/user.dart';
import 'package:lockerroomtalk/models/review.dart';
import 'package:lockerroomtalk/services/demo_data_service.dart';

// Type alias for compatibility
typedef User = AppUser;

/// Service that manages demo mode functionality.
/// Provides fallback data and functionality when Firebase is not configured.
class DemoModeService {
  static final DemoModeService _instance = DemoModeService._internal();
  factory DemoModeService() => _instance;
  DemoModeService._internal();

  static bool _isDemoMode = false;
  static bool _isFirebaseAvailable = false;
  
  // Cache for demo data
  static List<User>? _cachedUsers;
  static List<Review>? _cachedReviews;
  static User? _currentDemoUser;

  /// Initialize demo mode service and check Firebase availability
  static Future<void> initialize() async {
    try {
      // Try to detect if Firebase is properly configured
      // This is a simple check - in production you might want more robust detection
      await _checkFirebaseAvailability();
    } catch (e) {
      print('Firebase not available, enabling demo mode: $e');
      _isDemoMode = true;
      _isFirebaseAvailable = false;
    }
    
    if (_isDemoMode) {
      _initializeDemoData();
    }
  }

  /// Check if Firebase is available and properly configured
  static Future<void> _checkFirebaseAvailability() async {
    // This is a placeholder - you can implement more sophisticated checks
    // For now, we'll assume if we have demo keys, we're in demo mode
    _isFirebaseAvailable = true;
    _isDemoMode = false;
  }

  /// Force enable demo mode (useful for testing or when Firebase fails)
  static void enableDemoMode() {
    _isDemoMode = true;
    _isFirebaseAvailable = false;
    _initializeDemoData();
  }

  /// Check if currently in demo mode
  static bool get isDemoMode => _isDemoMode;

  /// Check if Firebase is available
  static bool get isFirebaseAvailable => _isFirebaseAvailable;

  /// Initialize demo data
  static void _initializeDemoData() {
    _cachedUsers = DemoDataService.generateDemoUsers(count: 25);
    _cachedReviews = DemoDataService.generateDemoReviews(
      count: 40, 
      users: _cachedUsers
    );
    
    // Set a demo user as current user
    if (_cachedUsers != null && _cachedUsers!.isNotEmpty) {
      _currentDemoUser = _cachedUsers!.first;
    }
  }

  /// Get demo users
  static List<User> getDemoUsers() {
    if (_cachedUsers == null) {
      _initializeDemoData();
    }
    return _cachedUsers ?? [];
  }

  /// Get demo reviews
  static List<Review> getDemoReviews() {
    if (_cachedReviews == null) {
      _initializeDemoData();
    }
    return _cachedReviews ?? [];
  }

  /// Get current demo user
  static User? getCurrentDemoUser() {
    return _currentDemoUser;
  }

  /// Set current demo user (for demo login)
  static void setCurrentDemoUser(User user) {
    _currentDemoUser = user;
  }

  /// Create demo user for login
  static User createDemoUser({
    String? username,
    String? email,
  }) {
    final demoUsers = getDemoUsers();
    
    if (username != null) {
      // Try to find existing user by username
      final existingUser = demoUsers.where((u) => 
        u.displayName.toLowerCase().contains(username.toLowerCase())
      ).firstOrNull;
      
      if (existingUser != null) {
        return existingUser;
      }
    }
    
    // Create new demo user
    final now = DateTime.now();
    final newUser = User(
      id: 'demo_user_${now.millisecondsSinceEpoch}',
      email: email ?? 'demo@lockerroomtalk.com',
      displayName: username ?? 'Demo User',
      profileImageUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=400',
      bio: 'Demo user exploring the LockerRoom Talk experience. Love trying new activities and meeting active people!',
      age: 28,
      datingPreference: [DatingPreference.all],
      location: Location(
        city: 'San Francisco',
        state: 'CA',
        country: 'US',
        coords: Coordinates(lat: 37.7749, lng: -122.4194),
      ),
      preferences: UserPreferences(
        notifications: NotificationSettings(),
        privacy: PrivacySettings(),
        display: DisplaySettings(),
      ),
      stats: UserStats(
        reviewsPosted: 3,
        commentsPosted: 7,
        likesReceived: 45,
        helpfulVotes: 32,
        reputation: 4.5,
      ),
      isPremium: false,
      lastSeen: now,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );
    
    // Add to cached users
    _cachedUsers?.add(newUser);
    
    return newUser;
  }

  /// Simulate async operations with delay (to mimic network calls)
  static Future<T> _simulateAsync<T>(T data, {int delayMs = 500}) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    return data;
  }

  /// Demo review operations
  static Future<List<Review>> getDemoReviewsAsync({
    int limit = 20,
    String? category,
    String? sortBy = 'createdAt',
    bool descending = true,
  }) async {
    var reviews = getDemoReviews();
    
    // Apply category filter
    if (category != null && category != 'all') {
      reviews = reviews.where((r) => r.category.toString() == category).toList();
    }
    
    // Apply sorting
    if (sortBy == 'createdAt') {
      reviews.sort((a, b) => descending 
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));
    } else if (sortBy == 'rating') {
      reviews.sort((a, b) => descending 
        ? b.rating.compareTo(a.rating)
        : a.rating.compareTo(b.rating));
    } else if (sortBy == 'stats.likes') {
      reviews.sort((a, b) => descending 
        ? b.stats.likes.compareTo(a.stats.likes)
        : a.stats.likes.compareTo(b.stats.likes));
    }
    
    // Apply limit
    if (reviews.length > limit) {
      reviews = reviews.take(limit).toList();
    }
    
    return _simulateAsync(reviews);
  }

  /// Get demo review by ID
  static Future<Review?> getDemoReviewById(String reviewId) async {
    final reviews = getDemoReviews();
    final review = reviews.where((r) => r.id == reviewId).firstOrNull;
    return _simulateAsync(review);
  }

  /// Search demo reviews
  static Future<List<Review>> searchDemoReviews(String query, {int limit = 20}) async {
    final reviews = getDemoReviews();
    final searchResults = reviews.where((review) =>
      review.title.toLowerCase().contains(query.toLowerCase()) ||
      review.content.toLowerCase().contains(query.toLowerCase()) ||
      review.subjectName.toLowerCase().contains(query.toLowerCase())
    ).take(limit).toList();
    
    return _simulateAsync(searchResults);
  }

  /// Get popular demo reviews
  static Future<List<Review>> getPopularDemoReviews({int limit = 20}) async {
    final reviews = getDemoReviews();
    reviews.sort((a, b) => b.stats.likes.compareTo(a.stats.likes));
    return _simulateAsync(reviews.take(limit).toList());
  }

  /// Get recent demo reviews
  static Future<List<Review>> getRecentDemoReviews({int limit = 20}) async {
    final reviews = getDemoReviews();
    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _simulateAsync(reviews.take(limit).toList());
  }

  /// Get reviews by demo user
  static Future<List<Review>> getDemoReviewsByUser(String userId, {int limit = 20}) async {
    final reviews = getDemoReviews();
    final userReviews = reviews
      .where((r) => r.authorId == userId)
      .take(limit)
      .toList();
    return _simulateAsync(userReviews);
  }

  /// Like/unlike demo review
  static Future<void> likeDemoReview(String reviewId, String userId) async {
    await _simulateAsync(null, delayMs: 200);
    // In demo mode, we just simulate the action
    // Real implementation would update local cache
  }

  static Future<void> unlikeDemoReview(String reviewId, String userId) async {
    await _simulateAsync(null, delayMs: 200);
    // In demo mode, we just simulate the action
  }

  /// Demo user operations
  static Future<User?> getDemoUserById(String userId) async {
    final users = getDemoUsers();
    final user = users.where((u) => u.id == userId).firstOrNull;
    return _simulateAsync(user);
  }

  /// Create demo review
  static Future<String> createDemoReview(Review review) async {
    await _simulateAsync(null, delayMs: 800);
    
    // Add to cached reviews
    final newReview = review.copyWith(
      id: 'demo_review_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _cachedReviews?.insert(0, newReview);
    return newReview.id;
  }

  /// Get trending topics
  static List<String> getTrendingTopics() {
    return DemoDataService.getTrendingTopics();
  }

  /// Get activity suggestions
  static List<Map<String, String>> getActivitySuggestions() {
    return DemoDataService.getActivitySuggestions();
  }

  /// Demo authentication simulation
  static Future<User?> demoSignIn(String email, String password) async {
    await _simulateAsync(null, delayMs: 1000);
    
    if (email.toLowerCase().contains('demo') || password == 'demo123') {
      final demoUser = createDemoUser(
        username: email.split('@').first,
        email: email,
      );
      setCurrentDemoUser(demoUser);
      return demoUser;
    }
    
    // Try to find existing demo user by email
    final users = getDemoUsers();
    final existingUser = users.where((u) => 
      u.email.toLowerCase() == email.toLowerCase()
    ).firstOrNull;
    
    if (existingUser != null) {
      setCurrentDemoUser(existingUser);
      return existingUser;
    }
    
    return null;
  }

  /// Demo sign up
  static Future<User?> demoSignUp(String email, String password, String username) async {
    await _simulateAsync(null, delayMs: 1200);
    
    final newUser = createDemoUser(
      username: username,
      email: email,
    );
    
    setCurrentDemoUser(newUser);
    return newUser;
  }

  /// Demo sign out
  static Future<void> demoSignOut() async {
    await _simulateAsync(null, delayMs: 300);
    _currentDemoUser = null;
  }

  /// Get demo mode info for display
  static Map<String, dynamic> getDemoModeInfo() {
    return {
      'isDemoMode': _isDemoMode,
      'isFirebaseAvailable': _isFirebaseAvailable,
      'totalUsers': _cachedUsers?.length ?? 0,
      'totalReviews': _cachedReviews?.length ?? 0,
      'currentUser': _currentDemoUser?.displayName ?? 'None',
    };
  }

  /// Reset demo data
  static void resetDemoData() {
    _cachedUsers = null;
    _cachedReviews = null;
    _currentDemoUser = null;
    _initializeDemoData();
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}