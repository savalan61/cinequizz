import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cinequizz/src/core/form_fields/_forms.dart';
import 'package:cinequizz/src/core/shared/enums/_enums.dart';
import 'package:cinequizz/src/features/auth/domain/repository/auth_repository_if.dart';

part 'forgot_state.dart';

class ForgotCubit extends Cubit<ForgotState> {
  ForgotCubit({required AuthRepositoryIf authRepositoryIf})
      : _authRepositoryIf = authRepositoryIf,
        super(const ForgotState.initial());
  final AuthRepositoryIf _authRepositoryIf;

  void reset() => emit(
        state.copyWith(
          email: const Email.pure(),
          submissionStatus: SubmissionStatus.idle,
        ),
      );

  Future<void> onSubmit({
    required String email,
  }) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
    try {
      await _authRepositoryIf.forgotPassword(
        email: email,
      );
      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
    } catch (e, t) {
      addError(e, t);
      final submissionStatus = switch (e) {
        const (TimeoutException) => SubmissionStatus.timeoutError,
        _ => SubmissionStatus.error,
      };
      emit(state.copyWith(submissionStatus: submissionStatus));
    }
  }
}
