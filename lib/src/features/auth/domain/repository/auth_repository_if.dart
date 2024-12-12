import 'package:cinequizz/src/core/shared/class/failure.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepositoryIf {
  ///Stream User
  Stream<AuthUser> get user;

  Future<Either<Failure, void>> signUpWithPassword({
    required String username,
    required String email,
    required String password,
    required String avatarSeed,
  });

  Future<Either<Failure, void>> loginWithPassword({
    required String email,
    required String password,
  });

  Future<void> loginWithGoogle();

  // Future<void> updateProfile({
  //   String? userName,
  // });

  Future<void> updateProfile({
    required String email,
    required String password,
    String? userName,
  });

  Future<void> logOut();

  Future<void> deleteAccount();

  Future<void> forgotPassword({required String email});
}
