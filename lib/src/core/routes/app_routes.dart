enum AppRoutes {
  auth('/auth'),
  splash('/splash'),
  onboarding('/onboarding'),
  home('/home'),
  discover('/discover'),
  statistics('/statistics'),
  question('/question', path: '/question/:series_id'),
  leaderboard('/leaderboard'),
  profile('/profile');

  const AppRoutes(this.route, {this.path});

  final String route;
  final String? path;

  String get name => route.replaceAll('/', '');
}
