import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase initialization and core services
class FirebaseService {
  static FirebaseFirestore? _firestore;
  static FirebaseAuth? _auth;

  /// Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  /// Get Firestore instance
  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception('Firebase not initialized. Call FirebaseService.initialize() first.');
    }
    return _firestore!;
  }

  /// Get Auth instance
  static FirebaseAuth get auth {
    if (_auth == null) {
      throw Exception('Firebase not initialized. Call FirebaseService.initialize() first.');
    }
    return _auth!;
  }

  /// Get current user
  static User? get currentUser => _auth?.currentUser;

  /// Check if user is logged in
  static bool get isLoggedIn => _auth?.currentUser != null;
}
