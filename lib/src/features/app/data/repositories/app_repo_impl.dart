import 'package:fpdart/fpdart.dart';
import 'package:cinequizz/src/core/shared/class/failure.dart';
import 'package:cinequizz/src/features/app/data/datasource/app_datasource.dart';
import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/user_stats.dart';
import 'package:cinequizz/src/features/app/domain/entities/user_total_stats.dart';
import 'package:cinequizz/src/features/app/domain/repositories/app_repo_if.dart';

class AppRepoImpl implements AppRepoIf {
  AppRepoImpl({required AppDataSource appDataSource})
      : _appDataSource = appDataSource;

  final AppDataSource _appDataSource;
  @override
  Future<Either<Failure, List<QuestionEntity>>> fetchAllQuestions() async {
    try {
      return right(await _appDataSource.fetchAllQuestions());
    } catch (e) {
      return left(Failure('Failed to fetch Questions: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SeriesEntity>>> fetchAllSeries() async {
    try {
      return right(await _appDataSource.fetchAllSeries());
    } catch (e) {
      return left(Failure('Failed to fetch Series: $e'));
    }
  }

  @override
  Future<Either<Failure, List<QuestionEntity>>> fetchUnansweredQuestions({
    required String userId,
    required String seriesId,
  }) async {
    try {
      return right(
        await _appDataSource.fetchUnansweredQuestions(
          seriesId: seriesId,
          userId: userId,
        ),
      );
    } catch (e) {
      return left(Failure('Failed to fetch Series: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveAnsweredQuestion({
    required String userId,
    required String seriesId,
    required String questionId,
    required bool? isCorrect,
    required String userName,
  }) async {
    try {
      return right(
        await _appDataSource.saveAnsweredQuestion(
          userId: userId,
          seriesId: seriesId,
          questionId: questionId,
          isCorrect: isCorrect,
          userName: userName,
        ),
      );
    } catch (e) {
      return left(Failure('Failed to save Answers :$e'));
    }
  }

  @override
  Stream<List<UserStats>> fetchUserStats({
    required String userId,
  }) {
    return _appDataSource.fetchUserStats(
      userId: userId,
    );
  }

  @override
  Stream<List<UserTotalStats>> fetchAllUsersStats() {
    return _appDataSource.fetchAllUsersStats();
  }
}
