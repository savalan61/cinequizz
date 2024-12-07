import 'package:fpdart/fpdart.dart';
import 'package:cinequizz/src/core/shared/class/failure.dart';
import 'package:cinequizz/src/core/shared/class/usecase.dart';
import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';
import 'package:cinequizz/src/features/app/domain/repositories/app_repo_if.dart';

class AllQuestionsUsecase implements UseCase<List<QuestionEntity>, NoParams> {
  AllQuestionsUsecase({required AppRepoIf appRepoIf}) : _appRepoIf = appRepoIf;

  final AppRepoIf _appRepoIf;
  @override
  Future<Either<Failure, List<QuestionEntity>>> call(NoParams params) async {
    return _appRepoIf.fetchAllQuestions();
  }
}
