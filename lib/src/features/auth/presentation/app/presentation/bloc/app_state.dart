part of 'app_bloc.dart';

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
