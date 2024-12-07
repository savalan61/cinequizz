// ignore_for_file: unused_local_variable

import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/extensions/build_context_extension.dart';
import 'package:cinequizz/src/features/auth/presentation/credential_handler/cubit/cred_handler_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/form_fields/_forms.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/auth/presentation/login/cubit/login_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<ShadFormState>();
  late ValueNotifier<bool> _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = ValueNotifier(false);
  }

  @override
  void dispose() {
    _obscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context
        .select((LoginCubit bloc) => bloc.state.submissionStatus.isLoading);
    void loginPressed() {
      if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
        return;
      }
      final fields = _formKey.currentState!;
      final email = fields.value['email'] as String;
      final password = fields.value['password'] as String;
      sl<LoginCubit>().onSubmit(
        email: email,
        password: password,
      );
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
            ValueListenableBuilder<bool>(
              valueListenable: _obscure,
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: ShadImage.square(
                  LucideIcons.lock,
                  size: AppSpacing.lg,
                ),
              ),
              builder: (BuildContext context, bool isObscure, Widget? prefix) {
                return ShadInputFormField(
                  id: 'password',
                  label: const Text('Password'),
                  placeholder: const Text('Enter your password'),
                  obscureText: !isObscure,
                  prefix: prefix,
                  suffix: ShadButton.secondary(
                    width: AppSpacing.sm * 3,
                    height: AppSpacing.sm * 3,
                    padding: EdgeInsets.zero,
                    decoration: const ShadDecoration(
                      secondaryBorder: ShadBorder.none,
                      secondaryFocusedBorder: ShadBorder.none,
                    ),
                    onPressed: () => _obscure.value = !_obscure.value,
                    icon: ShadImage.square(
                      isObscure ? LucideIcons.eye : LucideIcons.eyeOff,
                      size: AppSpacing.lg,
                    ),
                  ),
                  validator: (value) {
                    final password = Password.dirty(value);
                    return password.errorMessage;
                  },
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Tappable.scaled(
              onTap: () {
                context
                    .read<CredHandlerCubit>()
                    .changeAuthPage(CredPage.forgotPassword);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'forgot password?',
                  style: context.bodyMedium!.copyWith(color: AppColors.blue),
                ),
              ),
            ),
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
              onPressed: loginPressed,
              child: Text(isLoading ? 'Please wait' : 'Login'),
            ),
          ],
        ),
      ),
    );
  }
}
