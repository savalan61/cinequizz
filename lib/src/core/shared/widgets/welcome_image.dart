import 'package:flutter/material.dart';
import 'package:cinequizz/src/core/generated/assets.gen.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.images.appLogo3.path,
      height: 100,
      // cacheHeight: 200,
    );
  }
}
