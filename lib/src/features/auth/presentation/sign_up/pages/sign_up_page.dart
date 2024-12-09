import 'package:flutter/material.dart';
import 'package:cinequizz/src/core/shared/widgets/_widgets.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/features/auth/presentation/sign_up/widgets/_widgets.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignUpView();
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      body: AppConstrainedScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            WelcomeImage(),
            SizedBox(height: AppSpacing.xxlg),
            SignUpForm(),
            Spacer(),
            SignUpFooter(),
          ],
        ),
      ),
    );
  }
}
