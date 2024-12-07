import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';

class UserCredentialsForm extends StatelessWidget {
  const UserCredentialsForm({required this.formKey, super.key});
  final GlobalKey<ShadFormState> formKey;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final user = state is Authenticated ? state.user : AuthUser.anonymous;
        return Column(
          children: [
            ShadForm(
              key: formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Column(
                  children: [
                    //Email Textfield
                    ShadInputFormField(
                      label: const Text('Email'),
                      id: 'email',
                      initialValue: user.email,
                      prefix: const Padding(
                        padding: EdgeInsets.all(
                          AppSpacing.sm,
                        ),
                        child: ShadImage.square(
                          LucideIcons.mail,
                          size: AppSpacing.lg,
                        ),
                      ),
                      // onPressed: () =>
                      //     context.pushNamed(AppRoutes.updateEmail.name),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    //User name textfield
                    ShadInputFormField(
                      initialValue: user.name,
                      id: 'userName',
                      prefix: const Padding(
                        padding: EdgeInsets.all(
                          AppSpacing.sm,
                        ),
                        child: ShadImage.square(
                          LucideIcons.user,
                          size: AppSpacing.lg,
                        ),
                      ),
                      label: const Text('User name'),
                    ),
                    const SizedBox(height: AppSpacing.xlg),
                    ShadInputFormField(
                      id: 'password',
                      placeholder: const Text('your password'),
                      prefix: const Padding(
                        padding: EdgeInsets.all(
                          AppSpacing.sm,
                        ),
                        child: ShadImage.square(
                          LucideIcons.user,
                          size: AppSpacing.lg,
                        ),
                      ),
                      label: const Text('password'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
