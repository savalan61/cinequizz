enum AppRoutes {
  auth('/auth'),
  splash('/splash'),
  home('/home'),
  discover('/discover'),
  question('/question', path: '/question/:series_id'),
  leaderboard('/leaderboard'),
  profile('/profile');

  const AppRoutes(this.route, {this.path});

  final String route;
  final String? path;

  String get name => route.replaceAll('/', '');
}
