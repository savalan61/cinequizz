import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:flutter/material.dart';
import 'package:cinequizz/src/features/app/domain/entities/answered_questions.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/presentation/pages/home/widgets/series_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SeriesCardItem extends StatelessWidget {
  final SeriesEntity series;
  final SeriesState seriesState;
  final int index;
  final void Function(BuildContext, SeriesEntity) onTap;

  const SeriesCardItem({
    super.key,
    required this.series,
    required this.seriesState,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final userStats = seriesState.currentUserStats.answeredQuestions.firstWhere(
      (element) => element.seriesId == series.seriesId,
      orElse: () => AnsweredQuestions.empty(),
    );
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SeriesCard(
        onTap: () => userStats.questions.length / series.totalQuestionNo != 1
            ? onTap(context, series)
            : null,
        imageUrl: series.imgUrl,
        userId: seriesState.currentUserStats.userId,
        title: series.name,
        trailing: series.info,
        rating: double.parse(series.rating),
        completedRatio: userStats.questions.length / series.totalQuestionNo,
        correctNo: userStats.correctCount,
        wrongNo: userStats.wrongCount,
        totalQuestionNo: series.totalQuestionNo,
      ).animate().fadeIn(
            duration: const Duration(milliseconds: 500),
            delay: Duration(milliseconds: 500 * index),
          ),
    );
  }
}
