// ignore_for_file: flutter_style_todos

import 'package:cinequizz/src/core/exceptions/_exceptions.dart';
import 'package:cinequizz/src/core/exceptions/auth_exceptions.dart';
import 'package:cinequizz/src/core/shared/class/failure.dart';
import 'package:cinequizz/src/features/auth/data/datasource/auth_datasource.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:cinequizz/src/features/auth/domain/repository/auth_repository_if.dart';
import 'package:fpdart/fpdart.dart';

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
  Future<Either<Failure, void>> loginWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authDatasource.loginWithPassword(
        email: email,
        password: password,
      );
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signUpWithPassword({
    required String username,
    required String email,
    required String password,
    required String avatarSeed,
  }) async {
    try {
      await _authDatasource.signUpWithPassword(
          username: username,
          email: email,
          password: password,
          avatarSeed: avatarSeed);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(
      {required String password, String? userName, String? avatarSeed}) async {
    try {
      await _authDatasource.updateProfile(
        avatarSeed: avatarSeed,
        password: password,
        userName: userName,
      );
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
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

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _authDatasource.forgotPassword(
        email: email,
      );
    } on ResetPasswordFailure {
      rethrow;
    } catch (e, t) {
      Error.throwWithStackTrace(ResetPasswordFailure(e), t);
    }
  }
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
