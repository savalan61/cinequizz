// ignore_for_file: flutter_style_todos

import 'package:cinequizz/src/core/exceptions/auth_exceptions.dart';
import 'package:cinequizz/src/features/auth/data/datasource/auth_datasource.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:cinequizz/src/features/auth/domain/repository/auth_repository_if.dart';

class AuthRepoImpl implements AuthRepositoryIf {
  AuthRepoImpl({required AuthDatasource authDatasource})
      : _authDatasource = authDatasource;

  final AuthDatasource _authDatasource;
  @override
  Future<void> deleteAccount() async {
    try {
      await _authDatasource.deleteAccount();
    } on DeleteAccountFailure {
      rethrow;
    } catch (e, t) {
      Error.throwWithStackTrace(DeleteAccountFailure(e), t);
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _authDatasource.logOut();
    } on LogOutFailure {
      rethrow;
    } catch (e, t) {
      Error.throwWithStackTrace(LogOutFailure(e), t);
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    try {
      await _authDatasource.loginWithGoogle();
    } on LogInWithGoogleFailure {
      rethrow;
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (e, t) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(e), t);
    }
  }

  @override
  Future<void> loginWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authDatasource.loginWithPassword(
        email: email,
        password: password,
      );
    } on LogInWithPasswordCanceled {
      rethrow;
    } on LogInWithPasswordFailure {
      rethrow;
    } catch (e, t) {
      Error.throwWithStackTrace(LogInWithPasswordFailure(e), t);
    }
  }

  @override
  Future<void> signUpWithPassword({
    required String username,
    required String email,
    required String password,
    String? photo,
  }) async {
    try {
      await _authDatasource.signUpWithPassword(
        username: username,
        email: email,
        password: password,
      );
    } on SignUpWithPasswordCanceled {
      rethrow;
    } on SignUpWithPasswordFailure {
      rethrow;
    } catch (e, t) {
      Error.throwWithStackTrace(SignUpWithPasswordFailure(e), t);
    }
  }

  @override
  Future<void> updateProfile({
    required String email,
    required String password,
    String? userName,
  }) async {
    try {
      await _authDatasource.updateProfile(
        email: email,
        password: password,
        userName: userName,
      );
    } on UpdateProfileFailure {
      rethrow;
    } catch (e, t) {
      Error.throwWithStackTrace(UpdateProfileFailure(e), t);
    }
  }

  // @override
  // Future<void> updateProfile({String? userName}) async {
  //   try {
  //     await _authDatasource.updateProfile(userName: userName);
  //   } on UpdateProfileFailure {
  //     rethrow;
  //   } catch (e, t) {
  //     Error.throwWithStackTrace(UpdateProfileFailure(e), t);
  //   }
  // }

  @override
  Stream<AuthUser> get user => _authDatasource.user;
}

// extension on User {
//   AuthUser get toAuthUserModel {
//     return AuthUser(
//       id: uid,
//       email: email,
//       name: displayName,
//       photo: photoURL,
//       isNewUser: metadata.creationTime == metadata.lastSignInTime,
//     );
//   }
// }
