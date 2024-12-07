abstract class AuthenticationException implements Exception {
  const AuthenticationException(this.error);

  final Object error;

  @override
  String toString() => 'Authentication exception error: $error';
}

class SendLoginEmailLinkFailure extends AuthenticationException {
  const SendLoginEmailLinkFailure(super.error);
}

class IsLogInWithEmailLinkFailure extends AuthenticationException {
  const IsLogInWithEmailLinkFailure(super.error);
}

class LogInWithEmailLinkFailure extends AuthenticationException {
  const LogInWithEmailLinkFailure(super.error);
}

class LogInWithPasswordFailure extends AuthenticationException {
  const LogInWithPasswordFailure(super.error);
}

class LogInWithPasswordCanceled extends AuthenticationException {
  const LogInWithPasswordCanceled(super.error);
}

class LogInWithAppleFailure extends AuthenticationException {
  const LogInWithAppleFailure(super.error);
}

class LogInWithGoogleFailure extends AuthenticationException {
  const LogInWithGoogleFailure(super.error);
}

class LogInWithGoogleCanceled extends AuthenticationException {
  const LogInWithGoogleCanceled(super.error);
}

class SignUpWithPasswordFailure extends AuthenticationException {
  const SignUpWithPasswordFailure(super.error);
}

class SignUpWithPasswordCanceled extends AuthenticationException {
  const SignUpWithPasswordCanceled(super.error);
}

class SendPasswordResetEmailFailure extends AuthenticationException {
  const SendPasswordResetEmailFailure(super.error);
}

class ResetPasswordFailure extends AuthenticationException {
  const ResetPasswordFailure(super.error);
}

class LogOutFailure extends AuthenticationException {
  const LogOutFailure(super.error);
}

class UpdateProfileFailure extends AuthenticationException {
  const UpdateProfileFailure(super.error);
}

class UpdateEmailFailure extends AuthenticationException {
  const UpdateEmailFailure(super.error);
}

class DeleteAccountFailure extends AuthenticationException {
  const DeleteAccountFailure(super.error);
}
