// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:cinequizz/src/core/generated/assets.gen.dart';
// import 'package:cinequizz/src/core/routes/app_routes.dart';
// import 'package:cinequizz/src/core/shared/widgets/_widgets.dart';
// import 'package:cinequizz/src/core/theme/colors_theme.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotationAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     _animationController.forward().then((_) {
//       // Navigate to the home page after the animation completes
//       Future.delayed(const Duration(seconds: 1), () {
//         GoRouter.of(context).goNamed(AppRoutes.home.name);
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//         body: Center(
//       child: Image.asset(
//         Assets.images.appLogo.path,
//         // height: size,
//       ),
//     ));
//   }
// }
