import 'package:cinequizz/src/core/generated/assets.gen.dart';
import 'package:cinequizz/src/core/routes/_routes.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/di.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to CineQuizz",
          body: "The best place to test your movie knowledge!",
          image: Center(
              child: Image.asset(Assets.images.appLogo3.path, height: 275.0)),
        ),
        PageViewModel(
          title: "Compete with others",
          body: "Challenge your friends and see who scores the highest.",
          image: Center(
              child: Lottie.asset('assets/images/friends.json', height: 300.0)),
        ),
        PageViewModel(
          title: "Track your progress",
          body: "Keep track of your progress and improve your skills.",
          image: Center(
              child:
                  Lottie.asset('assets/images/progress.json', height: 300.0)),
        ),
      ],
      onDone: () {
        sl<SharedPreferences>().setBool(AppConstants.isNewUser, false);
        GoRouter.of(context).pushReplacementNamed(AppRoutes.home.name);
      },
      onSkip: () {
        sl<SharedPreferences>().setBool(AppConstants.isNewUser, false);
        // You can also override onSkip callback
        GoRouter.of(context).pushReplacementNamed(AppRoutes.home.name);
      },
      showSkipButton: true,
      skip: const Icon(Icons.skip_next),
      next: const Icon(LucideIcons.moveRight),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
