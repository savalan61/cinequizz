import 'dart:async';

import 'package:bloc/bloc.dart' show Cubit;
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:cinequizz/src/core/form_fields/_forms.dart';
import 'package:cinequizz/src/core/shared/enums/_enums.dart';
import 'package:cinequizz/src/features/auth/domain/repository/auth_repository_if.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required AuthRepositoryIf authRepositoryIf,
  })  : _userRepository = authRepositoryIf,
        super(const SignUpState());
  late AuthUser user;
  final AuthRepositoryIf _userRepository;
  // Future<void> _initializeUser() async {
  //   user = await sl<AuthRepositoryIf>().user.first;
  //   emit(state.copyWith(avatarSeed: user.avatarSeed));
  // }

  void reset() {
    const password = Password.pure();
    const name = Username.pure();

    final newState = state.copyWith(
      password: password,
      name: name,
      submissionStatus: SubmissionStatus.idle,
      message: '',
      // avatarSeed: '',
    );
    emit(newState);
  }

  Future<void> onSubmit({
    required String username,
    required String email,
    required String password,
    required String avatarSeed,
  }) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));

    try {
      final res = await _userRepository.signUpWithPassword(
        username: username,
        email: email,
        password: password,
        avatarSeed: avatarSeed,
      );
      res.fold(
        (l) => emit(state.copyWith(
            submissionStatus: SubmissionStatus.error, message: l.message)),
        (r) {
          emit(state.copyWith(
            submissionStatus: SubmissionStatus.success,
            // avatarSeed: state.avatarSeed,
          ));
        },
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      final submissionStatus = switch (error) {
        final TimeoutException _ => SubmissionStatus.timeoutError,
        _ => SubmissionStatus.error,
      };
      emit(state.copyWith(submissionStatus: submissionStatus));
    }
  }

  // onSelectAvatar(String avatarSeed) =>
  //     emit(state.copyWith(avatarSeed: avatarSeed));
}
