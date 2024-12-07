import 'dart:developer';
import 'package:cinequizz/src/core/exceptions/_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cinequizz/src/core/exceptions/auth_exceptions.dart';
import 'package:cinequizz/src/core/utils/token_storage.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';

class AuthDatasource {
  AuthDatasource({
    required TokenStorage tokenStorage,
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _tokenStorage = tokenStorage,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard() {
    user.listen(_onUserChanged);
  }

  final TokenStorage _tokenStorage;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw DeleteAccountFailure(Exception('User is not authenticated'));
      }
      await user.delete();
    } catch (e, t) {
      Error.throwWithStackTrace(DeleteAccountFailure(e), t);
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      log('log outed');
    } catch (e, t) {
      Error.throwWithStackTrace(LogOutFailure(e), t);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw LogInWithGoogleCanceled(
          Exception('Sign in with Google canceled.'),
        );
      }
      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(cred);
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (e, t) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(e), t);
    }
  }

  Future<void> loginWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e, t) {
      Error.throwWithStackTrace(LogInWithPasswordFailure(e), t);
    }
  }

  Future<void> signUpWithPassword({
    required String username,
    required String email,
    required String password,
    String? photo,
  }) async {
    try {
      final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCred.user;
      if (user == null) {
        throw const SignUpWithPasswordCanceled('User is null');
      }
      await user.updateProfile(
        displayName: username,
        photoURL: photo,
      );
    } on FirebaseAuthException catch (e) {
      // Handling specific Firebase authentication errors
      throw SignUpWithPasswordFailure(e.message ?? 'An unknown error occurred');
    } catch (e, t) {
      // Handling any other exceptions
      Error.throwWithStackTrace(SignUpWithPasswordFailure(e.toString()), t);
    }
  }

  Future<void> updateProfile({
    required String email,
    required String password,
    String? userName,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const UpdateProfileFailure('User is not authenticated');
      }
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);
      await user.verifyBeforeUpdateEmail(email);
      if (userName != null) await user.updateDisplayName(userName);
    } catch (e, t) {
      Error.throwWithStackTrace(UpdateProfileFailure(e), t);
    }
  }

  Stream<AuthUser> get user {
    return _firebaseAuth.userChanges().map(
      (firebaseUser) {
        return firebaseUser == null
            ? AuthUser.anonymous
            : firebaseUser.toAuthUserModel;
      },
    );
  }

  Future<void> _onUserChanged(AuthUser user) async {
    if (!user.isAnonymous) {
      await _tokenStorage.saveToken(user.id);
    } else {
      await _tokenStorage.clearToken();
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e, t) {
      Error.throwWithStackTrace(ResetPasswordFailure(e), t);
    }
  }
}

extension on User {
  AuthUser get toAuthUserModel {
    return AuthUser(
      id: uid,
      email: email,
      name: displayName,
      photo: photoURL,
      isNewUser: metadata.creationTime == metadata.lastSignInTime,
    );
  }
}
