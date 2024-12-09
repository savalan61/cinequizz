import 'dart:math';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/shared/widgets/_widgets.dart';
import 'package:cinequizz/src/core/shared/widgets/drawer_view.dart';
import 'package:cinequizz/src/features/auth/presentation/sign_up/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/form_fields/_forms.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/features/auth/presentation/sign_up/cubit/sign_up_cubit.dart';
import 'package:random_avatar/random_avatar.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<ShadFormState>();
  late ValueNotifier<bool> _obscure;
  // late ValueNotifier<String> _selectedAvatar;
  final List<String> avatarSeeds = List.generate(100, (index) => 'seed$index');

  @override
  void initState() {
    super.initState();
    _obscure = ValueNotifier(false);
    // _selectedAvatar = ValueNotifier(avatarSeeds[0]); // Default selection
  }

  @override
  void dispose() {
    _obscure.dispose();
    // _selectedAvatar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((SignUpCubit bloc) => bloc.state);
    final isLoading = state.submissionStatus.isLoading;
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        final status = state.submissionStatus;

        const timeoutMessage = 'Client ran out of time. Please try again later';

        if (status.isSuccess) {
          return context.closeSnackBars();
        }

        final snackMessage = switch ('') {
          _ when status.isTimeoutError => timeoutMessage,
          _ when status.isError => 'Something went wrong!',
          _ => null,
        };
        if (snackMessage == null) return;
        context.showSnackBar(snackMessage);
      },
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      child: ShadForm(
        key: _formKey,
        enabled: !isLoading,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 350,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar Selection
              Tappable.scaled(
                onTap: () {
                  context.showScrollableModal(pageBuilder: (ScrollController
                          scrollController,
                      DraggableScrollableController draggableScrollController) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: avatarSeeds.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                                crossAxisCount: 7),
                        itemBuilder: (context, index) {
                          return Tappable.scaled(
                            onTap: () {
                              context
                                  .read<SignUpCubit>()
                                  .onSelectAvatar(avatarSeeds[index]);
                              context.pop();
                            },
                            child: RandomAvatar(avatarSeeds[index],
                                height: 70, width: 70),
                          );
                        },
                      ),
                    );
                  });
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Badge(
                      alignment: Alignment.bottomRight,
                      label: const Icon(
                        Icons.add,
                        size: 15,
                      ),
                      backgroundColor: AppColors.background,
                      child: RandomAvatar(state.avatarSeed,
                          height: 70, width: 70)),
                ),
              ),
              const SizedBox(height: AppSpacing.md), // User name Text Field
              ShadInputFormField(
                id: 'userName',
                label: const Text('User Name'),
                keyboardType: TextInputType.name,
                placeholder: const Text('Enter your user name'),
                prefix: const Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: ShadImage.square(
                    LucideIcons.user,
                    size: AppSpacing.lg,
                  ),
                ),
                validator: (value) {
                  final userName = Username.dirty(value);

                  return userName.errorMessage;
                },
              ),
              const SizedBox(height: AppSpacing.md), // Email Text Field
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
                builder:
                    (BuildContext context, bool isObscure, Widget? prefix) {
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
              ShadButton(
                enabled: !isLoading,
                width: double.infinity,
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
                child: Text(isLoading ? 'Please wait' : 'Sign Up'),
                onPressed: () {
                  if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
                    return;
                  }
                  final fields = _formKey.currentState!;
                  final email = fields.value['email'] as String;
                  final password = fields.value['password'] as String;
                  final userName = fields.value['userName'] as String;
                  // final avatarSeed = _selectedAvatar.value;
                  // Use avatarSeed as needed for profile creation
                  context.read<SignUpCubit>().onSubmit(
                        username: userName,
                        email: email,
                        password: password,
                        // avatarSeed: avatarSeed,
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
