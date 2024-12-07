import 'package:animations/animations.dart';
import 'package:cinequizz/src/features/auth/presentation/forgot_password/pages/forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinequizz/src/features/auth/presentation/credential_handler/cubit/cred_handler_cubit.dart';
import 'package:cinequizz/src/features/auth/presentation/login/pages/login_page.dart';
import 'package:cinequizz/src/features/auth/presentation/sign_up/pages/sign_up_page.dart';

class CredHandlerPage extends StatelessWidget {
  const CredHandlerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CredHandlerCubit(),
      child: const CredHandlerView(),
    );
  }
}

class CredHandlerView extends StatelessWidget {
  const CredHandlerView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPage = context.select((CredHandlerCubit cubit) => cubit.state);
    return PageTransitionSwitcher(
      reverse: currentPage == CredPage.login,
      transitionBuilder: (
        child,
        primaryAnimation,
        secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: _getPage(currentPage),
    );
  }

  Widget _getPage(CredPage page) {
    switch (page) {
      case CredPage.login:
        return const LoginPage();
      case CredPage.signUp:
        return const SignUpPage();
      case CredPage.forgotPassword:
        return const ForgotPasswordPage();
      default:
        return const LoginPage();
    }
  }
}
