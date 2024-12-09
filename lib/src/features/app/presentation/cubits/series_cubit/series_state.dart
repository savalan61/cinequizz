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
    this.userStats = const UserStats.empty(),
    this.totalScore = 0,
    this.filteredSeries = const [],
    this.totalStats = const [],
  });

  SeriesState copyWith({
    SeriesStatus? status,
    List<SeriesEntity>? series,
    UserStats? currentUserStats,
    int? totalScore,
    List<SeriesEntity>? filteredSeries,
    List<UserStats>? totalStats,
  }) {
    return SeriesState(
        status: status ?? this.status,
        series: series ?? this.series,
        userStats: currentUserStats ?? this.userStats,
        totalScore: totalScore ?? this.totalScore,
        filteredSeries: filteredSeries ?? this.filteredSeries,
        totalStats: totalStats ?? this.totalStats);
  }

  final SeriesStatus status;
  final List<SeriesEntity> series;
  final UserStats userStats;
  final int totalScore;
  final List<SeriesEntity> filteredSeries;
  final List<UserStats> totalStats;
}
