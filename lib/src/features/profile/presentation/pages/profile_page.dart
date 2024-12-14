import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/question_cubit/question_cubit.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:cinequizz/src/features/auth/presentation/sign_up/cubit/sign_up_cubit.dart';
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
    final seedAvatar = context
        .select((SeriesCubit bloc) => bloc)
        .state
        .currentUserStats
        .avatarSeed;
    return ProfileView(
      seedAvatar: seedAvatar,
    );
  }
}

class ProfileView extends StatelessWidget {
  ProfileView({super.key, required this.seedAvatar});
  String seedAvatar;
  final _formKey = GlobalKey<ShadFormState>();

  var isLoading = false;

  void onAvatarSeed(String newAvatarSeed) => seedAvatar = newAvatarSeed;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AppSuccessState) {
          context.showSnackBar('Profile edited successfully');
        } else if (state is AppFailure) {
          context.showSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return AppScaffold(
          releaseFocus: true,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: const Text('Edit Profile'),
            titleTextStyle: context.headlineSmall,
            centerTitle: true,
            actions: [
              AppIcon.button(
                icon: LucideIcons.check,
                onTap: () {
                  if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
                    return;
                  }
                  context.confirmAction(
                      fn: () {
                        context.read<AppBloc>().add(
                              AppUpdateProfileRequested(
                                  userName: _formKey.currentState!
                                      .value['userName'] as String,
                                  password: _formKey.currentState!
                                      .value['password'] as String,
                                  avatarSeed: seedAvatar),
                            );
                        context.read<SeriesCubit>().fetchUserStats();
                      },
                      title: 'Edit Profile',
                      content: 'Are you sure?',
                      yesText: 'Yes',
                      noText: 'No, cancel',
                      yesTextStyle: const TextStyle(color: AppColors.blue));
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
                            context
                                .read<AppBloc>()
                                .add(const AppLogoutRequested());
                            sl<QuestionCubit>().resetQuestionCubit();
                            sl<SeriesCubit>().resetSeriesCubit();
                            // sl<SharedPreferences>().remove(AppConstants.isNewUser);
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
          body: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              state is AppLoading ? isLoading = true : isLoading = false;
              return Stack(
                children: [
                  AppConstrainedScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        UserCredentialsForm(
                            formKey: _formKey, onAvatarChanged: onAvatarSeed),
                      ],
                    ),
                  ),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox()
                ],
              );
            },
          ),
        );
      },
    );
  }
}
