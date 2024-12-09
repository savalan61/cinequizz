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
      avatarSeed: answer.avatarSeed,
    );
  }
}

class Answer {
  Answer(
      {required this.userId,
      required this.seriesId,
      required this.questionId,
      required this.isCorrect,
      required this.userName,
      required this.avatarSeed});

  final String userId;
  final String seriesId;
  final String questionId;
  final bool? isCorrect;
  final String userName;
  final String avatarSeed;
}
