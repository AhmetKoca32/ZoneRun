import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/profile/data/services/firestore_user_service.dart';
import 'firebase_service.dart';

/// Authentication service for Email/Password and Google Sign-in
class AuthService {
  FirebaseAuth? _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  FirestoreUserService? _firestoreUserService;

  AuthService() {
    _auth = FirebaseService.auth;
    if (_auth != null) {
      try {
        _firestoreUserService = FirestoreUserService();
      } catch (e) {
        // FirestoreUserService initialization failed
      }
    }
  }

  /// Get current user
  User? get currentUser => _auth?.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _auth?.currentUser != null;

  /// Auth state stream
  Stream<User?> get authStateChanges {
    if (_auth == null) {
      return Stream.value(null);
    }
    return _auth!.authStateChanges();
  }

  // ==================== Email/Password Authentication ====================

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String userName,
  }) async {
    if (_auth == null) {
      throw Exception('Firebase Auth not initialized');
    }
    
    try {
      // Create user account
      final userCredential = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(userName);

      // Create user profile in Firestore
      if (userCredential.user != null && _firestoreUserService != null) {
        await _firestoreUserService!.createUserProfile(
          userName: userName,
          avatarIndex: 0,
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error signing up: $e');
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (_auth == null) {
      throw Exception('Firebase Auth not initialized');
    }
    
    try {
      return await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  // ==================== Google Sign-in ====================

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    if (_auth == null) {
      throw Exception('Firebase Auth not initialized');
    }
    
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth!.signInWithCredential(credential);

      // Create or update user profile in Firestore
      if (userCredential.user != null && _firestoreUserService != null) {
        final existingProfile = await _firestoreUserService!.getUserProfile(
          userCredential.user!.uid,
        );
        if (existingProfile == null) {
          // Create new profile with Google display name
          await _firestoreUserService!.createUserProfile(
            userName: userCredential.user!.displayName ?? 'Kullanıcı',
            avatarIndex: 0,
          );
        } else {
          // Update existing profile if name is missing or default
          final googleDisplayName = userCredential.user!.displayName;
          if (googleDisplayName != null && 
              (existingProfile.userName.isEmpty || 
               existingProfile.userName == 'Kullanıcı' ||
               existingProfile.userName == 'Ahmet Koca')) {
            await _firestoreUserService!.updateUserProfile(
              userName: googleDisplayName,
            );
          }
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  // ==================== Password Reset ====================

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    if (_auth == null) {
      throw Exception('Firebase Auth not initialized');
    }
    
    try {
      await _auth!.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error sending password reset email: $e');
    }
  }

  // ==================== Sign Out ====================

  /// Sign out
  Future<void> signOut() async {
    try {
      final futures = <Future>[];
      if (_auth != null) {
        futures.add(_auth!.signOut());
      }
      futures.add(_googleSignIn.signOut());
      await Future.wait(futures);
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  // ==================== Helper Methods ====================

  /// Handle Firebase Auth exceptions and return user-friendly messages
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('Şifre çok zayıf. Daha güçlü bir şifre seçin.');
      case 'email-already-in-use':
        return Exception('Bu e-posta adresi zaten kullanılıyor.');
      case 'invalid-email':
        return Exception('Geçersiz e-posta adresi.');
      case 'user-disabled':
        return Exception('Bu kullanıcı hesabı devre dışı bırakılmış.');
      case 'user-not-found':
        return Exception('Kullanıcı bulunamadı.');
      case 'wrong-password':
        return Exception('Yanlış şifre.');
      case 'too-many-requests':
        return Exception('Çok fazla deneme. Lütfen daha sonra tekrar deneyin.');
      case 'operation-not-allowed':
        return Exception('Bu işlem izin verilmiyor.');
      default:
        return Exception('Bir hata oluştu: ${e.message}');
    }
  }
}
