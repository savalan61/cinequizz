import 'package:fpdart/fpdart.dart';
import 'package:cinequizz/src/core/shared/class/failure.dart';
import 'package:cinequizz/src/core/shared/class/usecase.dart';
import 'package:cinequizz/src/features/app/domain/repositories/app_repo_if.dart';

class SaveAnsweredQuestionsUsecase implements UseCase<void, Answer> {
  SaveAnsweredQuestionsUsecase({required AppRepoIf appRepoIf})
      : _appRepoIf = appRepoIf;

  final AppRepoIf _appRepoIf;
  @override
  Future<Either<Failure, void>> call(Answer answer) async {
    return _appRepoIf.saveAnsweredQuestion(
      userId: answer.userId,
      seriesId: answer.seriesId,
      questionId: answer.questionId,
      isCorrect: answer.isCorrect,
      userName: answer.userName,
    );
  }
}

class Answer {
  Answer({
    required this.userId,
    required this.seriesId,
    required this.questionId,
    required this.isCorrect,
    required this.userName,
  });

  final String userId;
  final String seriesId;
  final String questionId;
  final bool? isCorrect;
  final String userName;
}
