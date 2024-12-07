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
      await _authRepositoryIf.loginWithPassword(
        email: email,
        password: password,
      );
      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
    } catch (e, t) {
      addError(e, t);
      final submissionStatus = switch (e) {
        TimeoutException => SubmissionStatus.timeoutError,
        _ => SubmissionStatus.error,
      };
      emit(state.copyWith(submissionStatus: submissionStatus));
    }
  }

  Future<void> logOut() async {
    await _authRepositoryIf.logOut();
    emit(state.copyWith(submissionStatus: SubmissionStatus.idle));
  }
}
