import 'dart:developer';
import 'package:cinequizz/src/core/exceptions/_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cinequizz/src/core/exceptions/auth_exceptions.dart';
import 'package:cinequizz/src/core/utils/token_storage.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';

class AuthDatasource {
  AuthDatasource({
    required TokenStorage tokenStorage,
    required FirebaseAuth firebaseAuth,
    GoogleSignIn? googleSignIn,
    required FirebaseFirestore firebaseFirestore,
  })  : _tokenStorage = tokenStorage,
        _firebaseAuth = firebaseAuth,
        _db = firebaseFirestore,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard() {
    user.listen(_onUserChanged);
  }

  final TokenStorage _tokenStorage;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _db;

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
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw const LogInWithPasswordFailure(
              'The email address is not valid.');
        case 'user-disabled':
          throw const LogInWithPasswordFailure('This user has been disabled.');
        case 'user-not-found':
          throw const LogInWithPasswordFailure('No user found for this email.');
        case 'wrong-password':
          throw const LogInWithPasswordFailure('Wrong password provided.');
        default:
          throw const LogInWithPasswordFailure('An unknown error occurred.');
      }
    } catch (e, t) {
      Error.throwWithStackTrace(LogInWithPasswordFailure(e.toString()), t);
    }
  }

  Future<void> signUpWithPassword({
    required String username,
    required String email,
    required String password,
    required String avatarSeed,
  }) async {
    try {
      final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCred.user;
      if (user == null) {
        throw const SignUpWithPasswordFailure('User is null');
      }
      await user.updateProfile(
        displayName: username,
        photoURL: avatarSeed,
      );

      // Add user to Firestore users collection
      await _db.collection('users').doc(user.uid).set({
        'userName': username,
        'email': email,
        'avatarSeed': avatarSeed,
        'correctNo': 0,
        'wrongNo': 0,
        'answers': {},
        'userId': user.uid,
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw const SignUpWithPasswordFailure(
              'The email address is already in use by another account.');
        case 'invalid-email':
          throw const SignUpWithPasswordFailure(
              'The email address is not valid.');
        case 'operation-not-allowed':
          throw const SignUpWithPasswordFailure(
              'Email/password accounts are not enabled.');
        case 'weak-password':
          throw const SignUpWithPasswordFailure('The password is too weak.');
        default:
          throw SignUpWithPasswordFailure(
              e.message ?? 'An unknown error occurred.');
      }
    } catch (e, t) {
      Error.throwWithStackTrace(SignUpWithPasswordFailure(e.toString()), t);
    }
  }

  Future<void> updateProfile({
    String? avatarSeed,
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

      if (userName != null) {
        await user.updateDisplayName(userName);
      }

      if (avatarSeed != null && avatarSeed.isNotEmpty) {
        await _db.collection('users').doc(user.uid).update({
          'avatarSeed': avatarSeed,
          'userName': userName ?? user.displayName,
        });
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw const UpdateProfileFailure(
              'No user found for the provided credentials.');
        case 'wrong-password':
          throw const UpdateProfileFailure(
              'The provided password is incorrect.');
        case 'invalid-credential':
          throw const UpdateProfileFailure(
              'The provided credential is malformed or has expired.');
        case 'user-mismatch':
          throw const UpdateProfileFailure(
              'The credential does not correspond to the user.');
        case 'requires-recent-login':
          throw const UpdateProfileFailure(
              'This operation is sensitive and requires recent authentication.');
        default:
          throw UpdateProfileFailure(e.message ?? 'An unknown error occurred.');
      }
    } catch (e, t) {
      Error.throwWithStackTrace(UpdateProfileFailure(e.toString()), t);
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
      avatarSeed: photoURL,
      isNewUser: metadata.creationTime == metadata.lastSignInTime,
    );
  }
}
