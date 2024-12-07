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

// final class AppUpdateAccountRequested extends AppEvent {
//   const AppUpdateAccountRequested({this.username});

//   final String? username;

//   @override
//   List<Object?> get props => [username];
// }

final class AppUpdateProfileRequested extends AppEvent {
  const AppUpdateProfileRequested(
    this.userName, {
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
  final String? userName;

  @override
  List<Object?> get props => [email, password, userName];
}

// final class AppUserLocationChanged extends AppEvent {
//   const AppUserLocationChanged(this.location);

//   final Location location;

//   @override
//   List<Object> get props => [location];
// }

final class AppDeleteAccountRequested extends AppEvent {
  const AppDeleteAccountRequested();
}
