import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/form_fields/_forms.dart';
import 'package:cinequizz/src/core/shared/widgets/_widgets.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';

class UserCredentialsForm extends StatefulWidget {
  const UserCredentialsForm(
      {required this.formKey, super.key, required this.onAvatarChanged});
  final GlobalKey<ShadFormState> formKey;
  final ValueChanged<String> onAvatarChanged;
  @override
  State<UserCredentialsForm> createState() => _UserCredentialsFormState();
}

class _UserCredentialsFormState extends State<UserCredentialsForm> {
  final List<String> avatarSeeds = List.generate(100, (index) => 'seed$index');
  var selectedIndex = 0;
  late String seedAvatar;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeriesCubit, SeriesState>(
      builder: (context, state) {
        // var currentUser = context.watch<SeriesCubit>().state.currentUserStats;
        seedAvatar = state.currentUserStats.avatarSeed;
        return Column(
          children: [
            ShadForm(
              key: widget.formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Column(
                  children: [
                    //Avatar Edit
                    Tappable.scaled(
                      onTap: () {
                        context.showScrollableModal(
                          pageBuilder: (ScrollController scrollController,
                              DraggableScrollableController
                                  draggableScrollController) {
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
                                      setState(() {
                                        selectedIndex = index;
                                        seedAvatar = avatarSeeds[index];
                                        widget.onAvatarChanged(
                                            avatarSeeds[index]);
                                      });

                                      context.pop();
                                    },
                                    child: RandomAvatar(avatarSeeds[index],
                                        height: 70, width: 70),
                                  );
                                },
                              ),
                            );
                          },
                        );
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
                          child: RandomAvatar(
                            selectedIndex == 0
                                ? seedAvatar
                                : avatarSeeds[selectedIndex],
                            height: 70,
                            width: 70,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    //User name textfield
                    ShadInputFormField(
                      initialValue: state.currentUserStats.userName,
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
                    const SizedBox(height: AppSpacing.xxlg),
                    ShadInputFormField(
                      id: 'password',
                      validator: (value) {
                        final password = Password.dirty(value);
                        return password.errorMessage;
                      },
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
                      label: const Text('Please enter your password'),
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
