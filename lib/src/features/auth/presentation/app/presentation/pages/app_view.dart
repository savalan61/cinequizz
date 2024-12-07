import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/routes/_routes.dart';
import 'package:cinequizz/src/core/theme/app_theme.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router(context.read<AppBloc>());

    return ShadApp.materialRouter(
      themeMode: ThemeMode.dark,
      theme: AppTheme().theme,
      darkTheme: AppDarkTheme().theme,
      materialThemeBuilder: (context, theme) {
        return theme.copyWith(
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.transparent,
          ),
          textTheme: theme.brightness == Brightness.light
              ? AppTheme().textTheme
              : AppDarkTheme().textTheme,
          snackBarTheme:
              const SnackBarThemeData(behavior: SnackBarBehavior.floating),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'cinequizz',
      routerConfig: router,
    );
  }
}
