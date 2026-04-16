import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/profile/data/services/firestore_user_service.dart';
import 'firebase_service.dart';

/// Auth error with a localizable code (message resolved in UI via AuthL10n).
class AuthException implements Exception {
  final String code;
  AuthException(this.code);
  @override
  String toString() => code;
}

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
      throw Exception('Giriş sistemi hazır değil. Lütfen uygulamayı yeniden başlatın.');
    }

    try {
      // Create user account
      final userCredential = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(userName);

      // Email doğrulama maili gönder (başarısız olsa da kayıt tamamlanır)
      try {
        await userCredential.user?.sendEmailVerification();
      } catch (_) {}

      // Firestore'da da kullanıcı dökümanı oluştur (profil senkronu için)
      try {
        await _firestoreUserService?.createUserProfile(userName: userName);
      } catch (_) {
        // Firestore başarısız olsa da kayıt tamamlandı; profil yerelde tutulur
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException('authErrorSignUpFailed');
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (_auth == null) {
      throw AuthException('authErrorNotReady');
    }

    try {
      return await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Giriş yapılırken beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }

  // ==================== Google Sign-in ====================

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    if (_auth == null) {
      throw AuthException('authErrorNotReady');
    }

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw AuthException('authErrorGoogleCancelled');
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

      // Profil yerelde tutulur; ilk girişte ProfileProvider varsayılan oluşturur (displayName ile)

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Google ile giriş yapılırken bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }

  // ==================== Password Reset ====================

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    if (_auth == null) {
      throw AuthException('authErrorNotReady');
    }

    try {
      await _auth!.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException('authErrorPasswordResetFailed');
    }
  }

  // ==================== Email Verification ====================

  /// Doğrulama mailini tekrar gönder.
  Future<void> resendEmailVerification() async {
    final user = _auth?.currentUser;
    if (user == null) throw AuthException('authErrorSignInRequired');
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (_) {
      throw AuthException('authErrorGeneric');
    }
  }

  /// Kullanıcı verisini sunucudan yeniler (emailVerified güncellemesi için).
  Future<void> reloadUser() async {
    await _auth?.currentUser?.reload();
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
      throw AuthException('authErrorSignOutFailed');
    }
  }

  /// Hesabı kalıcı olarak sil (Firestore verisi + Auth). requires-recent-login hatası çıkarsa kullanıcı yeniden giriş yapmalı.
  Future<void> deleteAccount() async {
    if (_auth == null) {
      throw AuthException('authErrorNotReady');
    }
    final user = _auth!.currentUser;
    if (user == null) {
      throw AuthException('authErrorSignInRequired');
    }
    try {
      await _firestoreUserService?.deleteCurrentUserDocument();
      await user.delete();
      await signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== Helper Methods ====================

  /// Maps Firebase Auth error codes to AuthException codes for UI localization.
  AuthException _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return AuthException('authErrorWeakPassword');
      case 'email-already-in-use':
        return AuthException('authErrorEmailInUse');
      case 'invalid-email':
        return AuthException('authErrorInvalidEmail');
      case 'user-disabled':
        return AuthException('authErrorUserDisabled');
      case 'user-not-found':
        return AuthException('authErrorUserNotFound');
      case 'wrong-password':
        return AuthException('authErrorWrongPassword');
      case 'invalid-credential':
      case 'invalid-email-or-password':
        return AuthException('authErrorInvalidCredential');
      case 'too-many-requests':
        return AuthException('authErrorTooManyRequests');
      case 'operation-not-allowed':
        return AuthException('authErrorOperationNotAllowed');
      case 'requires-recent-login':
        return AuthException('authErrorRequiresRecentLogin');
      case 'network-request-failed':
        return AuthException('authErrorNetworkFailed');
      case 'expired-action-code':
        return AuthException('authErrorExpiredActionCode');
      case 'invalid-action-code':
        return AuthException('authErrorInvalidActionCode');
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return AuthException('authErrorPopupClosed');
      case 'popup-blocked':
        return AuthException('authErrorPopupBlocked');
      case 'account-exists-with-different-credential':
        return AuthException('authErrorAccountExistsDifferentCredential');
      default:
        return AuthException('authErrorGeneric');
    }
  }
}
