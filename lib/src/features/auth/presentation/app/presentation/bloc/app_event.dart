part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

final class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final AuthUser user;

  @override
  List<Object> get props => [user];
}

final class AppUpdateProfileRequested extends AppEvent {
  const AppUpdateProfileRequested(
      {this.userName, this.avatarSeed, required this.password});

  final String? avatarSeed;
  final String? userName;
  final String password;

  @override
  List<Object?> get props => [avatarSeed, userName];
}

final class AppDeleteAccountRequested extends AppEvent {
  const AppDeleteAccountRequested();
}
