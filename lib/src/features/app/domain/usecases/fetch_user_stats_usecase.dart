import 'package:cinequizz/src/features/app/domain/entities/user_stats.dart';
import 'package:cinequizz/src/features/app/domain/repositories/app_repo_if.dart';

class FetchUserStatsUsecase {
  FetchUserStatsUsecase({required AppRepoIf appRepoIf})
      : _appRepoIf = appRepoIf;

  final AppRepoIf _appRepoIf;
  Stream<List<UserStats>> call(String userId) {
    return _appRepoIf.fetchUserStats(
      userId: userId,
    );
  }
}
