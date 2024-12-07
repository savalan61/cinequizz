part of 'app_bloc.dart';

// enum AppStatus {
//   authenticated,

//   unauthenticated,

//   onboardingRequired,
// }

// class AppState extends Equatable {
//   const AppState({
//     required this.status,
//     this.user = AuthUser.anonymous,
//   });

//   const AppState.authenticated(AuthUser user)
//       : this(status: AppStatus.authenticated, user: user);

//   const AppState.onboardingRequired(AuthUser user)
//       : this(status: AppStatus.onboardingRequired, user: user);

//   const AppState.unauthenticated()
//       : this(status: AppStatus.unauthenticated, user: AuthUser.anonymous);

//   final AppStatus status;
//   final AuthUser user;

//   AppState copyWith({
//     AuthUser? user,
//     AppStatus? status,
//   }) {
//     return AppState(
//       user: user ?? this.user,
//       status: status ?? this.status,
//     );
//   }

//   @override
//   List<Object> get props => [
//         status,
//         user,
//       ];
// }

@immutable
sealed class AppState extends Equatable {}

final class Authenticated extends AppState {
  Authenticated({required this.user});

  final AuthUser user;

  @override
  List<Object?> get props => [user];
}

final class AppLoading extends Authenticated {
  AppLoading({required super.user});

  @override
  List<Object?> get props => [];
}

final class AppFailure extends Authenticated {
  AppFailure(this.message, {required super.user});
  final String message;

  @override
  List<Object?> get props => [message];
}

final class AppSuccessState extends Authenticated {
  AppSuccessState({required super.user});

  @override
  List<Object?> get props => [];
}

final class UnAuthenticated extends AppState {
  @override
  List<Object?> get props => [];
}

final class OnBoardingRequired extends AppState {
  OnBoardingRequired({required this.user});

  final AuthUser user;

  @override
  List<Object?> get props => [user];
}
