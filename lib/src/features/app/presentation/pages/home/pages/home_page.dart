import 'package:cinequizz/src/core/data/questions/saveFunction.dart';
import 'package:cinequizz/src/core/extensions/tappable_extension.dart';
import 'package:cinequizz/src/core/theme/app_spacing.dart';
import 'package:cinequizz/src/features/app/domain/entities/answered_questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/connection_management/connectivity_cubit.dart';
import 'package:cinequizz/src/core/routes/app_routes.dart';
import 'package:cinequizz/src/core/shared/widgets/app_scaffold.dart';
import 'package:cinequizz/src/core/theme/app_colors.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:cinequizz/src/features/app/presentation/pages/home/widgets/series_card.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthUser user;

  @override
  void initState() {
    super.initState();
    final appBloc = sl<AppBloc>();
    final seriesCubit = sl<SeriesCubit>();

    user = (appBloc.state as Authenticated).user;
    seriesCubit
      ..fetchAllSeries()
      ..fetchUserStats(userId: user.id);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            if (state is Authenticated) {
              setState(() {
                user = state.user;
              });
            }
          },
        ),
      ],
      child: BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
        builder: (context, connectivityState) {
          return BlocBuilder<SeriesCubit, SeriesState>(
            builder: (context, seriesState) {
              if (seriesState.series.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return AppScaffold(
                appBar: _buildAppBar(seriesState),
                body: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: seriesState.series.length,
                    itemBuilder: (context, index) => _buildSeriesCard(
                      context,
                      seriesState.series[index],
                      seriesState.currentUserStats.answeredQuestions.firstWhere(
                        (element) =>
                            element.seriesId ==
                            seriesState.series[index].seriesId,
                        orElse: () => AnsweredQuestions.empty(),
                      ),
                      index,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(SeriesState seriesState) {
    return AppBar(
      backgroundColor: AppColors.background,
      title: Row(
        children: [
          Tappable(
              onTap: () {
                saveAllQuestions();
              },
              child: RandomAvatar('${user.avatarSeed}', width: 50)),
          const SizedBox(width: AppSpacing.md),
          Text(user.name.toString()),
          const Spacer(),
          AnimatedFlipCounter(
            duration: 4.seconds,
            value: seriesState.totalScore,
            // prefix: "Score ",
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
          )
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildSeriesCard(
    BuildContext context,
    SeriesEntity series,
    AnsweredQuestions userStats,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SeriesCard(
        onTap: () => userStats.questions.length / series.questionNo != 1
            ? _onSeriesCardTap(context, series)
            : null,
        imageUrl: series.imgUrl,
        title: series.name,
        trailing: series.info,
        rating: double.parse(series.rating),
        completedRatio: userStats.questions.length / series.questionNo,
        correctNo: userStats.correctCount,
        wrongNo: userStats.wrongCount,
      ).animate().fadeIn(
            duration: const Duration(milliseconds: 500),
            delay: Duration(milliseconds: 500 * index),
          ),
    );
  }

  void _onSeriesCardTap(BuildContext context, SeriesEntity series) {
    Dialogs.materialDialog(
      msg: "Are you sure? You can't undo this",
      title: series.name,
      color: AppColors.background,
      context: context,
      actionsBuilder: (BuildContext context) => [
        ShadButton.outline(
          backgroundColor: Colors.transparent,
          pressedBackgroundColor: Colors.transparent,
          onPressed: () => context.pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.white)),
        ),
        ShadButton(
          pressedBackgroundColor: Colors.transparent,
          onPressed: () {
            context
              ..pushNamed(
                AppRoutes.question.name,
                pathParameters: {'series_id': series.seriesId},
              )
              ..pop();
          },
          child: const Text('Start'),
        ),
      ],
    );
  }
}
