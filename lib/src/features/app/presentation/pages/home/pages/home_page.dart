import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/connection_management/connectivity_cubit.dart';
import 'package:cinequizz/src/core/routes/app_routes.dart';
import 'package:cinequizz/src/core/shared/widgets/_widgets.dart';
import 'package:cinequizz/src/core/shared/widgets/app_scaffold.dart';
import 'package:cinequizz/src/core/theme/app_colors.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/user_stats.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:cinequizz/src/features/app/presentation/pages/home/widgets/series_card.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';

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
    user = (sl<AppBloc>().state as Authenticated).user;
    sl<SeriesCubit>()
      ..fetchAllSeries()
      ..fetchUserStats(userId: user.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
      builder: (context, state) {
        return BlocBuilder<SeriesCubit, SeriesState>(
          builder: (context, state) {
            if (state.series.isEmpty) {
              return const Center(child: Text('No series available'));
            }
            return AppScaffold(
              appBar: AppBar(
                backgroundColor: AppColors.background,
                title: Text('Score: ${state.totalScore}'),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: state.series.length,
                  itemBuilder: (context, index) {
                    final serie = state.series[index];
                    final userStats = state.userStats.firstWhere(
                      (element) => element.seriesId == serie.seriesId,
                      orElse: UserStats.empty,
                    );

                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: SeriesCard(
                        onTap: () => _onSeriesCardTap(context, serie),
                        imageUrl: serie.imgUrl,
                        title: serie.name,
                        trailing: serie.info,
                        rating: double.parse(serie.rating),
                        completedRatio: userStats.answeredQuestions.length /
                            serie.questionNo,
                        correctNo: userStats.correctNo,
                        wrongNo: userStats.wrongNo,
                      ).animate().fadeIn(
                            duration: const Duration(milliseconds: 500),
                            delay: Duration(milliseconds: 500 * index),
                          ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onSeriesCardTap(BuildContext context, SeriesEntity series) {
    Dialogs.materialDialog(
      msg: "Are you sure? You can't undo this",
      title: series.name,
      color: AppColors.background,
      context: context,
      actionsBuilder: (BuildContext context) {
        return [
          ShadButton.outline(
            backgroundColor: Colors.transparent,
            pressedBackgroundColor: Colors.transparent,
            onPressed: () => context.pop(),
            child:
                const Text('Cancel', style: TextStyle(color: AppColors.white)),
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
        ];
      },
    );
  }
}
