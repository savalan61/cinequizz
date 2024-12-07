part of 'forgot_cubit.dart';

class ForgotState {
  const ForgotState._({
    this.email = const Email.pure(),
    this.submissionStatus = SubmissionStatus.idle,
  });

  const ForgotState.initial() : this._();

  final Email email;
  final SubmissionStatus submissionStatus;

  ForgotState copyWith({
    Email? email,
    SubmissionStatus? submissionStatus,
  }) {
    return ForgotState._(
      email: email ?? this.email,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }
}
