import 'package:cinequizz/src/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:cinequizz/src/features/auth/presentation/sign_up/cubit/sign_up_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinequizz/src/bootstrap.dart';
import 'package:cinequizz/src/core/connection_management/connectivity_cubit.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/question_cubit/question_cubit.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/pages/app_view.dart';

void main() async {
  await bootstrap(() async {
    // uploadSampleData();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AppBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<QuestionCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SeriesCubit>(),
        ),
        BlocProvider(
          create: (context) => ConnectivityCubit(Connectivity()),
        ),
        BlocProvider(
          create: (context) => sl<SignUpCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<LoginCubit>(),
        ),
      ],
      child: const AppView(),
    );
  });
}
