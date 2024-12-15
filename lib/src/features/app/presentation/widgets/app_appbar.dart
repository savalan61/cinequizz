import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:flutter/material.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppbar({super.key, required this.seriesState});
  final SeriesState seriesState;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      title: Row(
        children: [
          Tappable(
            onTap: () {
              // run();
              // sl<SharedPreferences>().clear();
            },
            child: RandomAvatar(seriesState.currentUserStats.avatarSeed,
                width: 40),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            seriesState.currentUserStats.userName.toString(),
            style: context.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          AnimatedFlipCounter(
            duration: 2.seconds,
            value: seriesState.totalScore,
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:
                  seriesState.totalScore > 0 ? AppColors.blue : AppColors.red,
              shadows: [
                BoxShadow(
                  color: seriesState.totalScore > 0
                      ? AppColors.blue
                      : AppColors.red,
                  offset: const Offset(0, 20),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(
            LucideIcons.trophy,
            size: 20,
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
