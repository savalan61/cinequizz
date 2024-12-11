import 'dart:async';

import 'package:cinequizz/src/features/app/presentation/pages/statistics/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinequizz/src/core/routes/app_routes.dart';
import 'package:cinequizz/src/features/app/presentation/pages/home/pages/home_page.dart';
import 'package:cinequizz/src/features/app/presentation/pages/leaderboard/leaderboard.dart';
import 'package:cinequizz/src/features/app/presentation/pages/question/question_page.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/pages/home_view.dart';
import 'package:cinequizz/src/features/auth/presentation/credential_handler/pages/cred_handler_page.dart';
import 'package:cinequizz/src/features/profile/presentation/pages/profile_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  GoRouter router(AppBloc appBloc) => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: AppRoutes.home.route,
        routes: [
          GoRoute(
            path: AppRoutes.auth.route,
            name: AppRoutes.auth.name,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const CredHandlerPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.question.path!,
            name: AppRoutes.question.name,
            pageBuilder: (context, state) {
              final seriesId = state.pathParameters['series_id']!;
              return CustomTransitionPage(
                key: state.pageKey,
                child: QuestionPage(seriesId: seriesId),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            },
          ),
          StatefulShellRoute.indexedStack(
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state, navigationShell) {
              return HomeView(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.home.route,
                    name: AppRoutes.home.name,
                    builder: (context, state) {
                      return const HomePage();
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.statistics.route,
                    name: AppRoutes.statistics.name,
                    builder: (context, state) => const StatisticsPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.leaderboard.route,
                    name: AppRoutes.leaderboard.name,
                    builder: (context, state) => const Leaderboard(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.profile.route,
                    name: AppRoutes.profile.name,
                    builder: (context, state) => const ProfilePage(),
                  ),
                ],
              ),
            ],
          ),
        ],
        redirect: (context, state) {
          final authenticated = appBloc.state is Authenticated;
          final isInAuth = state.matchedLocation == AppRoutes.auth.route;

          if (state.matchedLocation == AppRoutes.splash.route) {
            return null;
          }

          if (!authenticated && !isInAuth) {
            return AppRoutes.auth.route;
          }

          if (authenticated && isInAuth) {
            return AppRoutes.home.route;
          }

          return null;
        },
        refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream),
      );
}

class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AppState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
