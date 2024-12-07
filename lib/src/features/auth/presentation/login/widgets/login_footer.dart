import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/theme/app_font_weight.dart';
import 'package:cinequizz/src/features/auth/presentation/credential_handler/cubit/cred_handler_cubit.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        Tappable.faded(
          fadeStrength: FadeStrength.lg,
          onTap: () {
            context.read<CredHandlerCubit>().changeAuthPage();
          },
          child: Text(
            ' Sign Up ',
            style: context.bodyMedium?.copyWith(
              fontWeight: AppFontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
