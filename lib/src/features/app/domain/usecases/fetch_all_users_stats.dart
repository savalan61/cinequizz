import 'package:cinequizz/src/features/app/domain/entities/user_total_stats.dart';
import 'package:cinequizz/src/features/app/domain/repositories/app_repo_if.dart';

class FetchAllUsersStatsUseCase {
  FetchAllUsersStatsUseCase({required AppRepoIf appRepoIf})
      : _appRepoIf = appRepoIf;

  final AppRepoIf _appRepoIf;
  Stream<List<UserTotalStats>> call() {
    return _appRepoIf.fetchAllUsersStats();
  }
}

class UserStatsParam {
  UserStatsParam({
    required this.userId,
    required this.seriesId,
  });

  final String userId;
  final String seriesId;
}
