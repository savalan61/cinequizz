import 'package:fpdart/fpdart.dart';
import 'package:cinequizz/src/core/shared/class/failure.dart';
import 'package:cinequizz/src/core/shared/class/usecase.dart';
import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';
import 'package:cinequizz/src/features/app/domain/repositories/app_repo_if.dart';

class SeriesQuestionsUsecase
    implements UseCase<List<QuestionEntity>, UnAnsweredQuestions> {
  SeriesQuestionsUsecase({required AppRepoIf appRepoIf})
      : _appRepoIf = appRepoIf;

  final AppRepoIf _appRepoIf;

  @override
  Future<Either<Failure, List<QuestionEntity>>> call(
    UnAnsweredQuestions questions,
  ) {
    return _appRepoIf.fetchUnansweredQuestions(
      seriesId: questions.seriesId,
      userId: questions.userId,
    );
  }
}

class UnAnsweredQuestions {
  UnAnsweredQuestions({required this.userId, required this.seriesId});

  final String userId;
  final String seriesId;
}
