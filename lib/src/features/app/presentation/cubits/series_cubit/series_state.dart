part of 'series_cubit.dart';

enum SeriesStatus {
  idl,
  loading,
  success,
  failed;
}

class SeriesState {
  SeriesState({
    required this.status,
    required this.series,
    required this.userStats,
    required this.totalScore,
    required this.filteredSeries,
    required this.totalStats,
  });

  SeriesState.initial({
    this.series = const [],
    this.status = SeriesStatus.idl,
    this.userStats = const [],
    this.totalScore = 0,
    this.filteredSeries = const [],
    this.totalStats = const [],
  });

  SeriesState copyWith({
    SeriesStatus? status,
    List<SeriesEntity>? series,
    List<UserStats>? userStats,
    int? totalScore,
    List<SeriesEntity>? filteredSeries,
    List<UserTotalStats>? totalStats,
  }) {
    return SeriesState(
        status: status ?? this.status,
        series: series ?? this.series,
        userStats: userStats ?? this.userStats,
        totalScore: totalScore ?? this.totalScore,
        filteredSeries: filteredSeries ?? this.filteredSeries,
        totalStats: totalStats ?? this.totalStats);
  }

  final SeriesStatus status;
  final List<SeriesEntity> series;
  final List<UserStats> userStats;
  final int totalScore;
  final List<SeriesEntity> filteredSeries;
  final List<UserTotalStats> totalStats;
}
