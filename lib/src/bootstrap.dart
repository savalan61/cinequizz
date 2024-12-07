import 'dart:async';
import 'dart:developer';

import 'package:cinequizz/src/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> bootstrap(FutureOr<Widget> Function() app) async {
  await runZonedGuarded(
    () async {
      await init();
      // sl<AuthRepoImpl>().logOut(); //!LOGOUT,

      Bloc.observer = const AppBlocObserver();
      runApp(await app());
    },
    (error, stack) => log(
      '$error',
      name: 'Error',
      stackTrace: stack,
    ),
  );
}

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
