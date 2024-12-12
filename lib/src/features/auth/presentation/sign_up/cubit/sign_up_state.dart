part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.name = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.avatarSeed = 'mahsa',
    this.submissionStatus = SubmissionStatus.idle,
    this.message = '',
  });

  final Email email;
  final Password password;
  final Username name;
  final SubmissionStatus submissionStatus;
  final String avatarSeed;
  final String message;

  SignUpState copyWith({
    Email? email,
    Password? password,
    Username? name,
    String? profilePicture,
    SubmissionStatus? submissionStatus,
    String? avatarSeed,
    String? message,
  }) =>
      SignUpState(
        email: email ?? this.email,
        password: password ?? this.password,
        name: name ?? this.name,
        avatarSeed: avatarSeed ?? this.avatarSeed,
        submissionStatus: submissionStatus ?? this.submissionStatus,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => <Object?>[
        email,
        password,
        name,
        avatarSeed,
        submissionStatus,
        message,
      ];
}
