// ignore_for_file: cascade_invocations

import 'dart:developer';

import 'package:cinequizz/src/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cinequizz/src/core/utils/token_storage.dart';
import 'package:cinequizz/src/features/app/data/datasource/app_datasource.dart';
import 'package:cinequizz/src/features/app/data/repositories/app_repo_impl.dart';
import 'package:cinequizz/src/features/app/domain/repositories/app_repo_if.dart';
import 'package:cinequizz/src/features/app/domain/usecases/_usecases.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/question_cubit/question_cubit.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:cinequizz/src/features/auth/data/datasource/auth_datasource.dart';
import 'package:cinequizz/src/features/auth/data/repository/auth_repo_impl.dart';
import 'package:cinequizz/src/features/auth/domain/repository/auth_repository_if.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';
import 'package:cinequizz/src/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:cinequizz/src/features/auth/presentation/sign_up/cubit/sign_up_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final firebaseAuth = FirebaseAuth.instance;
    final tokenStorage = InMemoryTokenStorage();
    final firebaseFirestore = FirebaseFirestore.instance;

    // AuthDatasource can be a factory as it doesn't hold state
    sl.registerFactory<AuthDatasource>(
      () => AuthDatasource(
        tokenStorage: tokenStorage,
        firebaseAuth: firebaseAuth,
      ),
    );

    // Repositories should be singletons as they interact with data
    // sources and maintain state
    sl.registerLazySingleton<AuthRepositoryIf>(
      () => AuthRepoImpl(authDatasource: sl<AuthDatasource>()),
    );

    final user = await sl<AuthRepositoryIf>().user.first;
    log(user.email.toString());

    // Cubits and Blocs should be singletons to maintain state across the app
    sl.registerLazySingleton<SignUpCubit>(
      () => SignUpCubit(authRepositoryIf: sl<AuthRepositoryIf>()),
    );

    sl.registerLazySingleton<LoginCubit>(
      () => LoginCubit(authRepositoryIf: sl<AuthRepositoryIf>()),
    );

    sl.registerLazySingleton<AppBloc>(
      () => AppBloc(user: user, authRepositoryIf: sl<AuthRepositoryIf>()),
    );

    // AppDataSource can be a factory as it doesn't hold state
    sl.registerFactory<AppDataSource>(
      () => AppDataSource(db: firebaseFirestore),
    );

    // AppRepoIf should be a singleton to maintain consistency
    //and state across the app
    sl.registerLazySingleton<AppRepoIf>(
      () => AppRepoImpl(appDataSource: sl<AppDataSource>()),
    );

    // Use cases can be factories as they don't hold state

    sl.registerFactory<FetchUserStatsUsecase>(
      () => FetchUserStatsUsecase(appRepoIf: sl<AppRepoIf>()),
    );

    sl.registerFactory<AllSeriesUsecase>(
      () => AllSeriesUsecase(appRepoIf: sl<AppRepoIf>()),
    );

    sl.registerFactory<FetchAllUsersStatsUseCase>(
      () => FetchAllUsersStatsUseCase(appRepoIf: sl<AppRepoIf>()),
    );

    sl.registerFactory<SeriesQuestionsUsecase>(
      () => SeriesQuestionsUsecase(appRepoIf: sl<AppRepoIf>()),
    );
    sl.registerFactory<SaveAnsweredQuestionsUsecase>(
      () => SaveAnsweredQuestionsUsecase(appRepoIf: sl<AppRepoIf>()),
    );

    // Cubits should be singletons to maintain state across the app
    sl.registerLazySingleton<QuestionCubit>(
      () => QuestionCubit(
        saveAnsweredQuestionsUsecase: sl<SaveAnsweredQuestionsUsecase>(),
        seriesQuestionsUsecase: sl<SeriesQuestionsUsecase>(),
      ),
    );

    sl.registerLazySingleton<SeriesCubit>(
      () => SeriesCubit(
        allSeriesUseCase: sl<AllSeriesUsecase>(),
        fetchUserStatsUsecase: sl<FetchUserStatsUsecase>(),
        fetchAllUsersStatsUseCase: sl(),
      ),
    );

    if (kDebugMode) {
      print('Initialization completed successfully!');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Initialization failed: $e');
    }
  }
}
