import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cinequizz/src/core/form_fields/_forms.dart';
import 'package:cinequizz/src/core/shared/enums/_enums.dart';
import 'package:cinequizz/src/features/auth/domain/repository/auth_repository_if.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthRepositoryIf authRepositoryIf})
      : _authRepositoryIf = authRepositoryIf,
        super(const LoginState.initial());
  final AuthRepositoryIf _authRepositoryIf;

  void reset() => emit(
        state.copyWith(
          email: const Email.pure(),
          password: const Password.pure(),
          submissionStatus: SubmissionStatus.idle,
        ),
      );

  Future<void> onSubmit({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
    try {
      final res = await _authRepositoryIf.loginWithPassword(
        email: email,
        password: password,
      );
      res.fold(
        (failure) {
          emit(
            state.copyWith(
              message: failure.message,
              submissionStatus: SubmissionStatus.error,
            ),
          );
        },
        (_) {
          emit(
            state.copyWith(
              submissionStatus: SubmissionStatus.success,
            ),
          );
        },
      );
    } catch (e, t) {
      addError(e, t);
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.error,
          message: 'An unexpected error occurred.',
        ),
      );
    }
  }

  Future<void> logOut() async {
    await _authRepositoryIf.logOut();
    emit(state.copyWith(submissionStatus: SubmissionStatus.idle));
  }
}
