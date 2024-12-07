import 'package:fpdart/fpdart.dart';
import 'package:cinequizz/src/core/shared/class/failure.dart';
import 'package:cinequizz/src/core/shared/class/usecase.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/domain/repositories/app_repo_if.dart';

class AllSeriesUsecase implements UseCase<List<SeriesEntity>, NoParams> {
  AllSeriesUsecase({required AppRepoIf appRepoIf}) : _appRepoIf = appRepoIf;

  final AppRepoIf _appRepoIf;
  @override
  Future<Either<Failure, List<SeriesEntity>>> call(NoParams params) async {
    return _appRepoIf.fetchAllSeries();
  }
}
