// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/data/questions.dart';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/generated/assets.gen.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

late AuthUser currentUser;

class _LeaderboardState extends State<Leaderboard> {
  @override
  void initState() {
    sl<SeriesCubit>().fetchAllUserStats();
    currentUser = (sl<AppBloc>().state as Authenticated).user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scoreboard'),
      ),
      body: BlocBuilder<SeriesCubit, SeriesState>(
        builder: (context, state) {
          if (state.status == SeriesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == SeriesStatus.failed) {
            return const Center(child: Text('Failed to load user stats'));
          } else {
            final userTotalStats = [...state.totalStats, ...dummyUsers];
            userTotalStats.sort((a, b) {
              final aScore = a.correctNo * 1000 - a.wrongNo * 250;
              final bScore = b.correctNo * 1000 - b.wrongNo * 250;
              return bScore.compareTo(aScore);
            });

            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: userTotalStats.length,
                itemBuilder: (context, index) {
                  final userStats = userTotalStats[index];
                  final totalScore =
                      userStats.correctNo * 1000 - userStats.wrongNo * 250;
                  final isMe = currentUser.id == userStats.userId;
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    shadowColor: isMe ? Colors.red : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}',
                          ),
                          const SizedBox(width: 10),
                          ShadAvatar(
                            Assets.images.profilePhoto.path,
                            placeholder:
                                Image.asset(Assets.images.profilePhoto.path),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              userStats.userName,
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
                              color: Colors.blue,
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
