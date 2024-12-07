import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:cinequizz/src/features/auth/domain/repository/auth_repository_if.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthUser user,
    required AuthRepositoryIf authRepositoryIf,
  })  : _authRepositoryIf = authRepositoryIf,
        super(
          user.isAnonymous ? UnAuthenticated() : Authenticated(user: user),
        ) {
    on<AppUserChanged>(_onAppUserChanged);
    on<AppLogoutRequested>(_onAppLogOut);
    on<AppUpdateProfileRequested>(_onAppUpdateProfileRequested);
    _userSubscription =
        _authRepositoryIf.user.listen(_userChanged, onError: addError);
  }

  void _userChanged(AuthUser user) => add(AppUserChanged(user));
  final AuthRepositoryIf _authRepositoryIf;
  StreamSubscription<AuthUser>? _userSubscription;

  void _onAppUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final user = event.user;

    user.isAnonymous
        ? emit(UnAuthenticated())
        : emit(Authenticated(user: user));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  void _onAppLogOut(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authRepositoryIf.logOut());
  }

  FutureOr<void> _onAppUpdateProfileRequested(
    AppUpdateProfileRequested event,
    Emitter<AppState> emit,
  ) async {
    final user = (state as Authenticated).user;
    emit(AppLoading(user: user));
    try {
      await _authRepositoryIf.updateProfile(
        email: event.email,
        password: event.password,
        userName: event.userName,
      );
      emit(AppSuccessState(user: user));
    } catch (e) {
      emit(AppFailure(e.toString(), user: user));
    }
  }
}
