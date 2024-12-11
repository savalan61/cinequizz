import 'package:cinequizz/src/core/extensions/build_context_extension.dart';
import 'package:cinequizz/src/core/shared/widgets/app_constrained_scroll_view.dart';
import 'package:cinequizz/src/core/shared/widgets/app_scaffold.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:cinequizz/src/features/app/presentation/widgets/app_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    sl<SeriesCubit>().fetchUserStats();
  }

  @override
  Widget build(BuildContext context) {
    final userStats =
        context.select((SeriesCubit bloc) => bloc.state).currentUserStats;

    final correctNo = userStats.correctNo;
    final wrongNo = userStats.wrongNo;
    final unAnsweredNo = userStats.totalNoAnswers - (correctNo + wrongNo);
    final totalNoAnswers = userStats.totalNoAnswers;

    return BlocBuilder<SeriesCubit, SeriesState>(
      builder: (context, state) {
        return state.status == SeriesStatus.success
            ? AppScaffold(
                appBar: AppAppbar(seriesState: state),
                body: AppConstrainedScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: context.screenHeight / 3,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: showingSections(correctNo, wrongNo,
                                  unAnsweredNo, totalNoAnswers),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: context.screenHeight / 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildLegendItem(AppColors.blue, 'Correct ',
                                        correctNo, LucideIcons.squareCheck),
                                    const SizedBox(height: AppSpacing.md),
                                    _buildLegendItem(AppColors.red, 'Wrong ',
                                        wrongNo, LucideIcons.squareX),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildLegendItem(AppColors.grey, 'skipped ',
                                        unAnsweredNo, LucideIcons.rows2),
                                    const SizedBox(height: AppSpacing.md),
                                    _buildLegendItem(
                                        AppColors.darkGrey,
                                        'Answered ',
                                        totalNoAnswers,
                                        LucideIcons.rows4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  List<PieChartSectionData> showingSections(
      int correctNo, int wrongNo, int unAnsweredNo, int totalNoAnswers) {
    return [
      _buildPieChartSection(0, touchedIndex, correctNo.toDouble(),
          AppColors.blue, 'Correct', totalNoAnswers),
      _buildPieChartSection(1, touchedIndex, wrongNo.toDouble(), AppColors.red,
          'Wrong', totalNoAnswers),
      _buildPieChartSection(2, touchedIndex, unAnsweredNo.toDouble(),
          AppColors.grey, 'Unanswered', totalNoAnswers),
    ];
  }

  PieChartSectionData _buildPieChartSection(int index, int? touchedIndex,
      double value, Color color, String title, int totalNoAnswers) {
    final isTouched = index == touchedIndex;
    final fontSize = isTouched ? 25.0 : 16.0;
    final radius = isTouched ? 60.0 : 50.0;
    final percentage = (value / totalNoAnswers) * 100;
    return PieChartSectionData(
      color: color,
      value: value,
      title: '${percentage.toStringAsFixed(0)}%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLegendItem(
    Color color,
    String title,
    int value,
    IconData icon,
  ) {
    return Row(
      children: [
        // Container(
        //   width: 20,
        //   height: 20,
        //   color: color,
        // ),
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(width: 8),
        Text('$title: $value'),
      ],
    );
  }
}
