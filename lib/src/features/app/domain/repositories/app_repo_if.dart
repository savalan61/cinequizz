// ignore_for_file: one_member_abstracts

import 'package:fpdart/fpdart.dart';
import 'package:cinequizz/src/core/shared/class/failure.dart';
import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/user_stats.dart';

abstract interface class AppRepoIf {
  Future<Either<Failure, List<SeriesEntity>>> fetchAllSeries();
  Future<Either<Failure, List<QuestionEntity>>> fetchUnansweredQuestions({
    required String userId,
    required String seriesId,
  });

  Future<Either<Failure, void>> saveAnsweredQuestion({
    required String userId,
    required String seriesId,
    required String questionId,
    required bool? isCorrect,
    required String userName,
    required String avatarSeed,
  });

  Stream<UserStats> fetchUserStats({
    required String userId,
  });

  Stream<List<UserStats>> fetchAllUsersStats();
}
