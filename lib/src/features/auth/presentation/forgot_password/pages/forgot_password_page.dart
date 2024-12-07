import 'package:cinequizz/src/core/shared/widgets/_widgets.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/auth/presentation/forgot_password/cubit/cubit/forgot_cubit.dart';
import 'package:cinequizz/src/features/auth/presentation/forgot_password/widgets/forgot_footer.dart';
import 'package:cinequizz/src/features/auth/presentation/forgot_password/widgets/forgot_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotCubit(authRepositoryIf: sl()),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

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
            SizedBox(height: AppSpacing.lg),
            ForgotForm(),
            Spacer(),
            ForgotFooter(),
          ],
        ),
      ),
    );
  }
}
