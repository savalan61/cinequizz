// ignore_for_file: cascade_invocations

import 'package:cinequizz/src/core/data/dummy_users.dart';
import 'package:cinequizz/src/core/shared/widgets/_widgets.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  void initState() {
    sl<SeriesCubit>().fetchAllUserStats();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Leader Board'),
        centerTitle: true,
      ),
      body: BlocBuilder<SeriesCubit, SeriesState>(
        builder: (context, state) {
          final currentUserStats = state.currentUserStats;
          if (state.status == SeriesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == SeriesStatus.failed) {
            return const Center(child: Text('Failed to load user stats'));
          } else {
            final userTotalStats = [...state.totalStats, ...dummyUsers];
            userTotalStats.sort((a, b) {
              final aScore = a.correctNo * AppConstants.correctAnsScore -
                  a.wrongNo * AppConstants.wrongAnsScore;
              final bScore = b.correctNo * AppConstants.correctAnsScore -
                  b.wrongNo * AppConstants.wrongAnsScore;
              return bScore.compareTo(aScore);
            });

            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: userTotalStats.length,
                itemBuilder: (context, index) {
                  final userStats = userTotalStats[index];
                  final totalScore =
                      userStats.correctNo * AppConstants.correctAnsScore -
                          userStats.wrongNo * AppConstants.wrongAnsScore;
                  final userName = userStats.userName;
                  final isMe = currentUserStats.userId == userStats.userId;
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    shadowColor: isMe ? Colors.red : AppColors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}',
                          ),
                          const SizedBox(width: 10),
                          RandomAvatar(userStats.avatarSeed,
                              width: 30, height: 30),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              userName,
                              style: context.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            LucideIcons.trophy,
                            color: index == 0
                                ? Colors.yellow
                                : index == 1
                                    ? Colors.grey
                                    : index == 2
                                        ? Colors.brown
                                        : Colors.transparent,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            totalScore.toString(),
                            style: context.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
