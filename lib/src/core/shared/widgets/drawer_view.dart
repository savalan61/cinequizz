// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/generated/assets.gen.dart';
import 'package:cinequizz/src/core/routes/_routes.dart';
import 'package:cinequizz/src/core/shared/enums/_enums.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.theme.canvasColor,
      width: context.screenWidth * .7,
      child: ListView(
        children: [
          DrawerHeader(
            child: Row(
              children: [
                Text(
                  'cinequizz',
                  style: context.headlineMedium,
                ),
                SizedBox.square(
                  dimension: 60,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.images.appLogo.path),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Eats',
                  style: context.headlineMedium,
                ),
              ],
            ),
          ),
          ...DrawerOption.values.map(
            (e) => ListTile(
              horizontalTitleGap: AppSpacing.sm,
              title: Text(e.name),
              leading: leadingSwitcher(e),
              onTap: () {
                Scaffold.of(context).closeDrawer();
                onTapSwitcher(e, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Icon leadingSwitcher(DrawerOption e) => switch (e) {
        DrawerOption.profile => Icon(LucideIcons.user),
        DrawerOption.orders => Icon(LucideIcons.user),
      };

  void onTapSwitcher(DrawerOption option, BuildContext context) =>
      switch (option) {
        DrawerOption.orders => context.pushNamed(AppRoutes.discover.name),
        DrawerOption.profile => context.pushNamed(AppRoutes.profile.name),
      };
}
