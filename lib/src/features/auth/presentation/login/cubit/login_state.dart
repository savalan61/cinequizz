part of 'login_cubit.dart';

class LoginState {
  const LoginState._({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.submissionStatus = SubmissionStatus.idle,
    this.message = '',
  });

  const LoginState.initial() : this._();

  final Email email;
  final Password password;
  final SubmissionStatus submissionStatus;
  final String message;

  LoginState copyWith({
    Email? email,
    Password? password,
    SubmissionStatus? submissionStatus,
    String? message,
  }) {
    return LoginState._(
      email: email ?? this.email,
      password: password ?? this.password,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }
}
