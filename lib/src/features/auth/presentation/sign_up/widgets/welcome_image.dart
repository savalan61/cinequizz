import 'package:flutter/material.dart';
import 'package:cinequizz/src/core/generated/assets.gen.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'welcome',
      child: Image.asset(
        Assets.images.appLogo.path,
        height: 200,
      ),
    );
  }
}
