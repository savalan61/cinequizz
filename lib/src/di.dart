// ignore_for_file: cascade_invocations

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
import 'package:shared_preferences/shared_preferences.dart';

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
    final sharedPref = await SharedPreferences.getInstance();

    sl.registerSingleton<SharedPreferences>(sharedPref);

    // Datasources
    sl.registerFactory<AuthDatasource>(
      () => AuthDatasource(
        tokenStorage: tokenStorage,
        firebaseAuth: firebaseAuth,
        firebaseFirestore: firebaseFirestore,
      ),
    );

    sl.registerFactory<AppDataSource>(
      () => AppDataSource(db: firebaseFirestore),
    );

    // Repositories
    sl.registerLazySingleton<AuthRepositoryIf>(
      () => AuthRepoImpl(authDatasource: sl<AuthDatasource>()),
    );

    sl.registerLazySingleton<AppRepoIf>(
      () => AppRepoImpl(appDataSource: sl<AppDataSource>()),
    );

    // Use Cases
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

    // Cubits/Blocs
    sl.registerLazySingleton<SignUpCubit>(
      () => SignUpCubit(authRepositoryIf: sl<AuthRepositoryIf>()),
    );

    sl.registerLazySingleton<LoginCubit>(
      () => LoginCubit(authRepositoryIf: sl<AuthRepositoryIf>()),
    );

    final user = await sl<AuthRepositoryIf>().user.first;

    sl.registerLazySingleton<AppBloc>(
      () => AppBloc(user: user, authRepositoryIf: sl<AuthRepositoryIf>()),
    );

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
        fetchAllUsersStatsUseCase: sl<FetchAllUsersStatsUseCase>(),
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
