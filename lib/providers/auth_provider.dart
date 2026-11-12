import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:techlaunchpad/services/auth_service.dart';
import 'package:techlaunchpad/services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAdmin = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _isAdmin;

  AuthProvider() {
    _authService.userStream.listen((user) {
      _user = user;
      if (user != null) _checkAdmin();
      notifyListeners();
    });
  }

  void _setLoading(bool v) {
    _isLoading = v;
    _error = null;
    notifyListeners();
  }

  Future<void> _checkAdmin() async {
    if (_user == null) {
      _isAdmin = false;
      return;
    }
    try {
      final doc = await _firestoreService.getUserData(_user!.uid);
      final data = doc.data() as Map<String, dynamic>?;
      _isAdmin = data?['isAdmin'] == true;
    } catch (_) {
      _isAdmin = false;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signInWithEmail(email, password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _setLoading(true);
    try {
      final cred = await _authService.signUpWithEmail(email, password, name);
      if (cred.user != null) {
        await _firestoreService.updateUserData(cred.user!.uid, {
          'name': name,
          'email': email,
          'photoUrl': '',
          'isAdmin': false,
          'createdAt': DateTime.now().toIso8601String(),
          'bookmarks': [],
        });
      }
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> googleSignIn() async {
    _setLoading(true);
    try {
      final cred = await _authService.signInWithGoogle();
      if (cred == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final u = cred.user!;
      final doc = await _firestoreService.getUserData(u.uid);
      if (!doc.exists) {
        await _firestoreService.updateUserData(u.uid, {
          'name': u.displayName ?? '',
          'email': u.email ?? '',
          'photoUrl': u.photoURL ?? '',
          'isAdmin': false,
          'createdAt': DateTime.now().toIso8601String(),
          'bookmarks': [],
        });
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Google sign-in failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    await _authService.signOut();
    _user = null;
    _isAdmin = false;
    _setLoading(false);
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
