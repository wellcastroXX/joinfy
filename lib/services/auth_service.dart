// lib/services/auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// cria conta com email/senha
  Future<User?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user != null) {
      await _saveUserProfile(user.uid, {
        'name': name,
        'email': email,
        'provider': 'password',
      });
    }
    return user;
  }

  /// login com email/senha
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  /// login com Google
  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    final user = cred.user;

    if (user != null) {
      await _saveUserProfile(user.uid, {
        'name': user.displayName ?? '',
        'email': user.email,
        'photoURL': user.photoURL,
        'provider': 'google',
      });
    }
    return user;
  }

  /// login com Facebook
  /// login com Facebook
  Future<User?> signInWithFacebook() async {
    // peça as permissões mais comuns
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: const ['email', 'public_profile'],
    );

    if (result.status != LoginStatus.success) {
      // usuário cancelou ou erro
      return null;
    }

    // >>> mudança principal: tokenString (não mais "token")
    final AccessToken accessToken = result.accessToken!;
    final OAuthCredential credential = FacebookAuthProvider.credential(
      accessToken.tokenString,
    );

    final UserCredential cred = await _auth.signInWithCredential(credential);
    final user = cred.user;

    if (user != null) {
      await _saveUserProfile(user.uid, {
        'name': user.displayName ?? '',
        'email': user.email,
        'photoURL': user.photoURL,
        'provider': 'facebook',
      });
    }
    return user;
  }

  /// logout
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  /// observador de auth
  Stream<User?> get onAuthStateChanged => _auth.authStateChanges();

  /// salvar/atualizar perfil no Firestore
  Future<void> _saveUserProfile(String uid, Map<String, dynamic> data) async {
    final ref = _db.collection('users').doc(uid);
    await ref.set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
