// ignore_for_file: cascade_invocations

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cinequizz/src/core/shared/class/usecase.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/user_stats.dart';
import 'package:cinequizz/src/features/app/domain/entities/user_total_stats.dart';
import 'package:cinequizz/src/features/app/domain/usecases/_usecases.dart';

part 'series_state.dart';

class SeriesCubit extends Cubit<SeriesState> {
  SeriesCubit({
    required AllSeriesUsecase allSeriesUseCase,
    required FetchUserStatsUsecase fetchUserStatsUsecase,
    required FetchAllUsersStatsUseCase fetchAllUsersStatsUseCase,
  })  : _allSeriesUsecase = allSeriesUseCase,
        _fetchUserStatsUsecase = fetchUserStatsUsecase,
        _fetchAllUsersStatsUseCase = fetchAllUsersStatsUseCase,
        super(SeriesState.initial());

  final AllSeriesUsecase _allSeriesUsecase;
  final FetchUserStatsUsecase _fetchUserStatsUsecase;
  final FetchAllUsersStatsUseCase _fetchAllUsersStatsUseCase;

  Future<void> fetchAllSeries() async {
    final res = await _allSeriesUsecase(NoParams());
    res.fold(
      (l) {
        log(l.message);
        emit(
          state.copyWith(
            status: SeriesStatus.failed,
          ),
        );
      },
      (series) {
        emit(
          state.copyWith(
            series: series,
            status: SeriesStatus.success,
          ),
        );
      },
    );
  }

  void fetchUserStats({required String userId}) {
    final userStatsStream = _fetchUserStatsUsecase(userId);

    userStatsStream.listen(
      (userStats) {
        final totalCorrectNo =
            userStats.fold(0, (sum, stats) => sum + stats.correctNo);
        final totalWrongNo =
            userStats.fold(0, (sum, stats) => sum + stats.wrongNo);

        final totalScore = (totalCorrectNo * 1000) - (totalWrongNo * 250);
        emit(
          state.copyWith(
            userStats: userStats,
            status: SeriesStatus.success,
            totalScore: totalScore,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: SeriesStatus.failed,
          ),
        );
      },
    );
  }

  void fetchAllUserStats() {
    final userStatsStream = _fetchAllUsersStatsUseCase();

    userStatsStream.listen(
      (userTotalStats) {
        emit(
          state.copyWith(
            totalStats: userTotalStats,
            status: SeriesStatus.success,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: SeriesStatus.failed,
          ),
        );
      },
    );
  }

  void getFilteredSeries({required String query}) {
    emit(state.copyWith(status: SeriesStatus.loading));
    emit(
      state.copyWith(
        status: SeriesStatus.success,
        filteredSeries: state.series
            .where(
              (element) =>
                  element.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      ),
    );
  }
}
