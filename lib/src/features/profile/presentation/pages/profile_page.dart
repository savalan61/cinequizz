import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide TextDirection;
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/shared/widgets/_widgets.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';
import 'package:cinequizz/src/features/profile/presentation/widgets/user_credentials_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final _formKey = GlobalKey<ShadFormState>();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Profile'),
        titleTextStyle: context.headlineSmall,
        centerTitle: false,
        actions: [
          AppIcon.button(
            icon: LucideIcons.check,
            onTap: () {
              context.confirmAction(
                fn: () {
                  context.read<AppBloc>().add(
                        AppUpdateProfileRequested(
                          _formKey.currentState!.value['userName'] as String,
                          email:
                              _formKey.currentState!.value['email'] as String,
                          password: _formKey.currentState!.value['password']
                              as String,
                        ),
                      );
                },
                title: 'Edit Profile',
                content: 'Are you sure?',
                yesText: 'Yes',
                noText: 'No, cancel',
              );
            },
          ),
          AppIcon.button(
            icon: LucideIcons.alignJustify,
            onTap: () {
              showMenu(
                context: context,
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                position: RelativeRect.fromDirectional(
                  textDirection: TextDirection.ltr,
                  start: AppSpacing.md,
                  top: AppSpacing.md,
                  end: 0,
                  bottom: 0,
                ),
                items: [
                  PopupMenuItem<void>(
                    onTap: () => context.confirmAction(
                      fn: () {
                        context.read<AppBloc>().add(const AppLogoutRequested());
                      },
                      title: 'Logout',
                      content: 'Are you sure to logout from your account?',
                      yesText: 'Yes, logout',
                      noText: 'No, cancel',
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.logOut,
                          size: AppSize.xs,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Log out',
                          style: context.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            UserCredentialsForm(formKey: _formKey),
          ],
        ),
      ),
    );
  }
}
