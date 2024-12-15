import 'package:cinequizz/src/features/app/presentation/widgets/app_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/core/shared/widgets/app_constrained_scroll_view.dart';
import 'package:cinequizz/src/core/shared/widgets/app_scaffold.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int touchedUserIndex = -1;
  int touchedSeriesIndex = -1;

  @override
  void initState() {
    super.initState();
    context.read<SeriesCubit>().fetchUserStats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeriesCubit, SeriesState>(
      builder: (context, state) {
        if (state.status != SeriesStatus.success) {
          return const Center(child: CircularProgressIndicator());
        }

        final userStats = state.currentUserStats;

        final correctNo = userStats.correctNo;
        final wrongNo = userStats.wrongNo;
        final unAnsweredNo = userStats.totalNoAnswers - (correctNo + wrongNo);
        final totalNoAnswers = userStats.totalNoAnswers;

        final totalQuestions = state.series.fold<int>(
          0,
          (sum, element) => sum + element.totalQuestionNo,
        );

        return AppScaffold(
          appBar: AppAppbar(seriesState: state),
          body: AppConstrainedScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('User Statistics'),
                  _buildPieChart(
                    title: 'User Statistics',
                    sections: _buildUserSections(
                      correctNo,
                      wrongNo,
                      unAnsweredNo,
                      totalNoAnswers,
                    ),
                    touchedIndex: touchedUserIndex,
                    onSectionTouch: (index) {
                      setState(() => touchedUserIndex = index);
                    },
                  ),
                  _buildLegend([
                    _LegendData(AppColors.blue, 'Correct', correctNo),
                    _LegendData(AppColors.red, 'Wrong', wrongNo),
                    _LegendData(AppColors.grey, 'Skipped', unAnsweredNo),
                  ]),
                  const Divider(),
                  const Text('Series Statistics'),
                  _buildPieChart(
                    title: 'Series Statistics',
                    sections: _buildSeriesSections(
                      totalNoAnswers,
                      totalQuestions,
                    ),
                    touchedIndex: touchedSeriesIndex,
                    onSectionTouch: (index) {
                      setState(() => touchedSeriesIndex = index);
                    },
                  ),
                  _buildLegend([
                    _LegendData(
                        AppColors.blue, 'Total Questions', totalQuestions),
                    _LegendData(
                        AppColors.red, 'Total Answered', totalNoAnswers),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPieChart({
    required String title,
    required List<PieChartSectionData> sections,
    required int touchedIndex,
    required void Function(int index) onSectionTouch,
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              if (!event.isInterestedForInteractions ||
                  response?.touchedSection == null) {
                onSectionTouch(-1);
                return;
              }
              onSectionTouch(response!.touchedSection!.touchedSectionIndex);
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 30,
          sections: sections,
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildUserSections(
    int correctNo,
    int wrongNo,
    int unAnsweredNo,
    int totalNoAnswers,
  ) {
    return [
      _buildPieSection(0, touchedUserIndex, correctNo, AppColors.blue,
          'Correct', totalNoAnswers),
      _buildPieSection(
          1, touchedUserIndex, wrongNo, AppColors.red, 'Wrong', totalNoAnswers),
      _buildPieSection(2, touchedUserIndex, unAnsweredNo, AppColors.grey,
          'Skipped', totalNoAnswers),
    ];
  }

  List<PieChartSectionData> _buildSeriesSections(
    int totalNoAnswers,
    int totalQuestions,
  ) {
    return [
      _buildPieSection(0, touchedSeriesIndex, totalNoAnswers, AppColors.red,
          'Answered', totalQuestions),
      _buildPieSection(1, touchedSeriesIndex, totalQuestions, AppColors.blue,
          'Total', totalQuestions + totalNoAnswers),
    ];
  }

  PieChartSectionData _buildPieSection(
    int index,
    int touchedIndex,
    int value,
    Color color,
    String title,
    int total,
  ) {
    final isTouched = index == touchedIndex;
    final percentage = total == 0 ? 0 : (value / total) * 100;

    return PieChartSectionData(
      color: color,
      value: value.toDouble(),
      title: '${percentage.toStringAsFixed(1)}%',
      radius: isTouched ? 60 : 50,
      titleStyle: TextStyle(
        fontSize: isTouched ? 18 : 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLegend(List<_LegendData> data) {
    return Column(
      children: data.map((item) {
        return Row(
          children: [
            Icon(Icons.square, color: item.color),
            const SizedBox(width: 8),
            Text('${item.title}: ${item.value}'),
          ],
        );
      }).toList(),
    );
  }
}

class _LegendData {
  final Color color;
  final String title;
  final int value;

  _LegendData(this.color, this.title, this.value);
}
