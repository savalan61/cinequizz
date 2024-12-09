// ignore_for_file: unused_local_variable

import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/features/auth/presentation/credential_handler/cubit/cred_handler_cubit.dart';
import 'package:cinequizz/src/features/auth/presentation/forgot_password/cubit/cubit/forgot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/form_fields/_forms.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';

class ForgotForm extends StatefulWidget {
  const ForgotForm({super.key});

  @override
  State<ForgotForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final _formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = context
        .select((ForgotCubit bloc) => bloc.state.submissionStatus.isLoading);

    void forgotPressed() {
      if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
        return;
      }
      final fields = _formKey.currentState!;
      final email = fields.value['email'] as String;
      context.read<ForgotCubit>().onSubmit(
            email: email,
          );
      context.showSnackBar(
          'Please check your email for instructions to reset your password.');
      context.read<CredHandlerCubit>().changeAuthPage(CredPage.login);
    }

    return ShadForm(
      key: _formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Email Text Field
            ShadInputFormField(
              id: 'email',
              label: const Text('Email'),
              keyboardType: TextInputType.emailAddress,
              placeholder: const Text('Enter your email'),
              prefix: const Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: ShadImage.square(
                  LucideIcons.mail,
                  size: AppSpacing.lg,
                ),
              ),
              validator: (value) {
                final email = Email.dirty(value);

                return email.errorMessage;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            // Password Text Field

            const SizedBox(height: AppSpacing.lg),

            const SizedBox(height: AppSpacing.xlg),
            ShadButton(
              width: double.infinity,
              enabled: !isLoading,
              icon: !isLoading
                  ? const SizedBox.shrink()
                  : const Padding(
                      padding: EdgeInsets.only(right: AppSpacing.md),
                      child: SizedBox.square(
                        dimension: AppSpacing.lg,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
              onPressed: forgotPressed,
              child: Text(isLoading ? 'Please wait' : 'Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
