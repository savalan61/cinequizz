import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';

abstract class AuthRepositoryIf {
  ///Stream User
  Stream<AuthUser> get user;

  Future<void> signUpWithPassword({
    required String username,
    required String email,
    required String password,
    String? photo,
  });

  Future<void> loginWithPassword({
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
