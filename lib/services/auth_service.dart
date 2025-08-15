import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whisperdate/models/user.dart';
import 'package:whisperdate/services/user_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn? _googleSignIn;
  final UserService _userService = UserService();
  
  GoogleSignIn get googleSignIn {
    _googleSignIn ??= GoogleSignIn(
      scopes: ['email', 'profile'],
    );
    return _googleSignIn!;
  }

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email (simplified method for modern auth screen)
  Future<AppUser?> signInWithEmail(String email, String password) async {
    return signInWithEmailPassword(email, password);
  }
  
  // Sign up with email (simplified method for modern auth screen)
  Future<AppUser?> signUpWithEmail(String email, String password, String name) async {
    return signUpWithEmailPassword(email, password, name);
  }
  
  // Sign in with email and password
  Future<AppUser?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        return await _userService.getUser(result.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<AppUser?> signUpWithEmailPassword(String email, String password, String username) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        // Create user profile
        final newUser = AppUser(
          id: result.user!.uid,
          email: email,
          username: username,
          displayName: username,
          profileImageUrl: '',
          datingPreference: [DatingPreference.all], // Default preference
          location: Location(city: '', state: '', country: ''),
          preferences: UserPreferences(
            notifications: NotificationSettings(),
            privacy: PrivacySettings(),
            display: DisplaySettings(),
          ),
          stats: UserStats(),
          emailVerified: false,
          isPremium: false,
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _userService.createUser(newUser);
        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);
      
      if (result.user != null) {
        // Check if user exists, if not create new user
        AppUser? existingUser = await _userService.getUser(result.user!.uid);
        
        if (existingUser == null) {
          final newUser = AppUser(
            id: result.user!.uid,
            email: result.user!.email ?? '',
            username: result.user!.displayName?.replaceAll(' ', '').toLowerCase() ?? 'user${DateTime.now().millisecondsSinceEpoch}',
            displayName: result.user!.displayName ?? 'Anonymous',
            profileImageUrl: result.user!.photoURL ?? '',
            datingPreference: [DatingPreference.all],
            location: Location(city: '', state: '', country: ''),
            preferences: UserPreferences(
              notifications: NotificationSettings(),
              privacy: PrivacySettings(),
              display: DisplaySettings(),
            ),
            stats: UserStats(),
            emailVerified: result.user!.emailVerified,
            isPremium: false,
            lastSeen: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          await _userService.createUser(newUser);
          return newUser;
        }
        
        return existingUser;
      }
      return null;
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn?.signOut();
    await _auth.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
      } on FirebaseAuthException catch (e) {
        throw _handleAuthException(e);
      }
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Delete user data from Firestore
        await _userService.deleteUser(user.uid);
        // Delete Firebase Auth user
        await user.delete();
      } on FirebaseAuthException catch (e) {
        throw _handleAuthException(e);
      }
    }
  }

  // Handle authentication exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not allowed.';
      case 'requires-recent-login':
        return 'Please log in again to perform this action.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}