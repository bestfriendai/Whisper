import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisperdate/models/user.dart';
import 'package:whisperdate/services/auth_service.dart';
import 'package:whisperdate/services/user_service.dart';

class AppStateProvider extends ChangeNotifier {
  static final AppStateProvider _instance = AppStateProvider._internal();
  factory AppStateProvider() => _instance;
  AppStateProvider._internal() {
    _init();
  }

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  // Authentication state
  User? _firebaseUser;
  AppUser? _currentUser;
  bool _isLoading = true;
  bool _isGuest = false;

  // App state
  int _currentNavIndex = 0;
  bool _isDarkMode = false;
  String _currentLocation = '';

  // Getters
  User? get firebaseUser => _firebaseUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _firebaseUser != null && !_isGuest;
  bool get isGuest => _isGuest;
  int get currentNavIndex => _currentNavIndex;
  bool get isDarkMode => _isDarkMode;
  String get currentLocation => _currentLocation;

  void _init() {
    // Listen to auth state changes
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _firebaseUser = user;
    _isLoading = true;
    notifyListeners();

    if (user != null && !_isGuest) {
      // Load user data
      try {
        _currentUser = await _userService.getUser(user.uid);
        if (_currentUser == null) {
          // Create user if doesn't exist (shouldn't happen normally)
          _currentUser = AppUser(
            id: user.uid,
            email: user.email ?? '',
            username: user.displayName?.replaceAll(' ', '').toLowerCase() ?? 'user${DateTime.now().millisecondsSinceEpoch}',
            displayName: user.displayName ?? 'Anonymous',
            profileImageUrl: user.photoURL ?? '',
            datingPreference: [DatingPreference.all],
            location: Location(city: '', state: '', country: ''),
            preferences: UserPreferences(
              notifications: NotificationSettings(),
              privacy: PrivacySettings(),
              display: DisplaySettings(),
            ),
            stats: UserStats(),
            emailVerified: user.emailVerified,
            isPremium: false,
            lastSeen: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _userService.createUser(_currentUser!);
        }
      } catch (e) {
        debugPrint('Error loading user data: $e');
      }
    } else {
      _currentUser = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Authentication methods
  Future<bool> signInWithEmailPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _authService.signInWithEmailPassword(email, password);
      return user != null;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUpWithEmailPassword(String email, String password, String username) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _authService.signUpWithEmailPassword(email, password, username);
      return user != null;
    } catch (e) {
      debugPrint('Sign up error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _authService.signInWithGoogle();
      return user != null;
    } catch (e) {
      debugPrint('Google sign in error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _isGuest = false;
      _currentNavIndex = 0;
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  void continueAsGuest() {
    _isGuest = true;
    _firebaseUser = null;
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  void exitGuestMode() {
    _isGuest = false;
    notifyListeners();
  }

  // User profile methods
  Future<bool> updateUserProfile(AppUser updatedUser) async {
    try {
      await _userService.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Update profile error: $e');
      return false;
    }
  }

  Future<bool> updateUserPreferences(UserPreferences preferences) async {
    try {
      if (_currentUser != null) {
        await _userService.updateUserPreferences(_currentUser!.id, preferences);
        _currentUser = _currentUser!.copyWith(preferences: preferences);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Update preferences error: $e');
      return false;
    }
  }

  // Navigation methods
  void setCurrentNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // Theme methods
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    // TODO: Save to preferences
  }

  void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
    // TODO: Save to preferences
  }

  // Location methods
  void updateLocation(String location) {
    _currentLocation = location;
    notifyListeners();
  }

  // User interaction methods
  Future<bool> followUser(String userId) async {
    try {
      if (_currentUser != null) {
        await _userService.followUser(_currentUser!.id, userId);
        // Update local state
        final updatedFollowing = List<String>.from(_currentUser!.following ?? []);
        updatedFollowing.add(userId);
        _currentUser = _currentUser!.copyWith(followingUsers: updatedFollowing);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Follow user error: $e');
      return false;
    }
  }

  Future<bool> unfollowUser(String userId) async {
    try {
      if (_currentUser != null) {
        await _userService.unfollowUser(_currentUser!.id, userId);
        // Update local state
        final updatedFollowing = List<String>.from(_currentUser!.following ?? []);
        updatedFollowing.remove(userId);
        _currentUser = _currentUser!.copyWith(followingUsers: updatedFollowing);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Unfollow user error: $e');
      return false;
    }
  }

  Future<bool> blockUser(String userId) async {
    try {
      if (_currentUser != null) {
        await _userService.blockUser(_currentUser!.id, userId);
        // Update local state
        final updatedBlocked = List<String>.from(_currentUser!.blockedUsers ?? []);
        updatedBlocked.add(userId);
        _currentUser = _currentUser!.copyWith(blockedUsers: updatedBlocked);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Block user error: $e');
      return false;
    }
  }

  Future<bool> unblockUser(String userId) async {
    try {
      if (_currentUser != null) {
        await _userService.unblockUser(_currentUser!.id, userId);
        // Update local state
        final updatedBlocked = List<String>.from(_currentUser!.blockedUsers ?? []);
        updatedBlocked.remove(userId);
        _currentUser = _currentUser!.copyWith(blockedUsers: updatedBlocked);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Unblock user error: $e');
      return false;
    }
  }

  // Helper methods
  bool isFollowing(String userId) {
    return _currentUser?.following?.contains(userId) ?? false;
  }

  bool isBlocked(String userId) {
    return _currentUser?.blockedUsers?.contains(userId) ?? false;
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    if (_firebaseUser != null && !_isGuest) {
      try {
        _currentUser = await _userService.getUser(_firebaseUser!.uid);
        notifyListeners();
      } catch (e) {
        debugPrint('Refresh user data error: $e');
      }
    }
  }
}