import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/connection_management/connectivity_cubit.dart';
import 'package:cinequizz/src/core/shared/widgets/app_scaffold.dart';
import 'package:cinequizz/src/core/shared/widgets/drawer_view.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/widgets/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectivityCubit, ConnectivityStatus>(
      listener: (context, state) {
        final isDisconnected = state == ConnectivityStatus.disconnected;

        if (isDisconnected) {
          ShadToaster.of(context).show(
            const ShadToast(
              description: Text('Disconnected from the Internet'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        final isConnected = state == ConnectivityStatus.connected;
        return !isConnected
            ? const AppScaffold(
                body: Center(
                  child: Text('Disconnected from the Internet'),
                ),
              )
            : AppScaffold(
                releaseFocus: true,
                drawer: const DrawerView(),
                bottomNavigationBar:
                    BottomNavBar(navigationShell: navigationShell),
                body: navigationShell,
              );
      },
    );
  }
}
