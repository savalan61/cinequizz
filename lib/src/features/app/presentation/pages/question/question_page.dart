// ignore_for_file: flutter_style_todos, prefer_const_constructors, avoid_redundant_argument_values, lines_longer_than_80_chars, use_build_context_synchronously, unnecessary_statements

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/routes/app_routes.dart';
import 'package:cinequizz/src/core/shared/widgets/_widgets.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/question_cubit/question_cubit.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({required this.seriesId, super.key});
  final String seriesId;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late QuestionCubit questionCubit;
  late AuthUser user;
  @override
  void initState() {
    super.initState();
    questionCubit = context.read<QuestionCubit>();
    user = (sl<AppBloc>().state as Authenticated).user;
    questionCubit.getSeriesQuestions(
      seriesId: widget.seriesId,
      userId: user.id,
    );
  }

  @override
  void dispose() {
    questionCubit.reset(); // Reset the cubit state
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuestionView(
      seriesId: widget.seriesId,
      user: user,
    );
  }
}

class QuestionView extends StatefulWidget {
  const QuestionView({
    required this.seriesId,
    required this.user,
    super.key,
  });
  final String seriesId;
  final AuthUser user;
  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  final CountDownController _controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    final serieState = context.select((SeriesCubit bloc) => bloc.state);
    final currentSeries = serieState.series.firstWhere(
      (element) => element.seriesId == widget.seriesId,
    );
    final totalScore = serieState.totalScore;
    return BlocConsumer<QuestionCubit, QuestionsState>(
      listener: (context, state) {
        if (state.status == Status.finished) {
          final score = state.correctNo / AppConstants.totalQuestions;

          scoreHandler(score, state, context);
        }
      },
      builder: (context, state) {
        return AppScaffold(
          safeArea: true,
          appBar: AppBar(
            centerTitle: true,
            title: Text('Total Score: $totalScore'),
          ),
          body: state.status == Status.loaded
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //* StepProgressIndicator
                      SizedBox(
                        height: 20,
                        child: StepProgressIndicator(
                          totalSteps: currentSeries.questionNo,
                          currentStep: 3,
                          selectedColor: AppColors.deepBlue,
                        ),
                      ),

                      //* Question Card
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: ShadCard(
                          key: ValueKey(
                            state.questions[state.currentQuestionNo].questionId,
                          ),
                          backgroundColor: AppColors.lightDark,
                          width: double.infinity,
                          title: Text(
                            state.questions[state.currentQuestionNo].seriesName,
                            style: context.titleLarge!.copyWith(),
                          ),
                          description: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              state.questions[state.currentQuestionNo].title,
                              style:
                                  const TextStyle(color: AppColors.brightGrey),
                            ),
                          ),
                          footer: Align(
                            alignment: Alignment.bottomRight,
                            child: ShadButton(
                              enabled: state.currentQuestionNo <
                                  AppConstants.totalQuestions - 1,
                              pressedBackgroundColor: Colors.transparent,
                              onPressed: () {
                                if (state.currentQuestionNo <
                                    AppConstants.totalQuestions - 1) {
                                  _controller.pause();
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    _controller.start,
                                  );
                                  context
                                      .read<QuestionCubit>()
                                      .submitAnswer(selectedOption: -1);
                                }
                              },
                              child: Text(
                                state.currentQuestionNo !=
                                        AppConstants.totalQuestions - 1
                                    ? 'Next'
                                    : 'Finished',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // LinearTimer(
                      //   duration: const Duration(seconds: 5),
                      //   onTimerEnd: () {
                      //     print("timer ended");
                      //   },
                      // ),
                      // const Spacer(),

                      //* Options
                      ...List.generate(
                        4,
                        (option) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Tappable(
                                throttle: true,
                                throttleDuration: const Duration(seconds: 1),
                                borderRadius: 5,
                                backgroundColor: !state.colors[option]
                                    ? AppColors.lightDark
                                    : Colors.green,
                                onTap: () {
                                  if (state.enableBtn) {
                                    _controller.pause();
                                    context
                                        .read<QuestionCubit>()
                                        .submitAnswer(selectedOption: option);
                                    if (state.currentQuestionNo <
                                        AppConstants.totalQuestions - 1) {
                                      Future.delayed(
                                        const Duration(seconds: 1),
                                        _controller.start,
                                      );
                                    }
                                  } else {}
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColors.deepBlue,
                                        child: Text(
                                          optionsHeaders[option],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        state.questions[state.currentQuestionNo]
                                            .opts[option],
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: AppColors.brightGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ).animate().fadeIn(
                                duration: const Duration(milliseconds: 500),
                                delay: Duration(milliseconds: 500 * option),
                              );
                        },
                      ), //* CircularCountDownTimer

                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox.square(
                          dimension: 70,
                          child: CircularCountDownTimer(
                            duration: 10,
                            initialDuration: 0,
                            controller: _controller,
                            width: 50,
                            height: 50,
                            ringColor: Colors.grey[300]!,
                            ringGradient: null,
                            fillColor: AppColors.borderOutline,
                            fillGradient: null,
                            backgroundColor: AppColors.lightDark,
                            backgroundGradient: null,
                            strokeWidth: 10,
                            strokeCap: StrokeCap.round,
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            textFormat: CountdownTextFormat.S,
                            isReverse: true,
                            isReverseAnimation: false,
                            isTimerTextShown: true,
                            autoStart: false,
                            onStart: () {
                              // debugPrint('Countdown Started');
                            },
                            onComplete: () {
                              if (state.currentQuestionNo <
                                  AppConstants.totalQuestions - 1) {
                                context
                                    .read<QuestionCubit>()
                                    .submitAnswer(selectedOption: -1);
                                Future.delayed(
                                  const Duration(seconds: 1),
                                  _controller.start,
                                );
                              } else {
                                _controller.pause();
                              }
                            },
                            onChange: (String timeStamp) {},
                            timeFormatterFunction:
                                (defaultFormatterFunction, duration) {
                              if (duration.inSeconds == 0) {
                                return '0';
                              } else {
                                return Function.apply(
                                  defaultFormatterFunction,
                                  [duration],
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
    // : SizedBox.shrink()
  }

  void scoreHandler(double score, QuestionsState state, BuildContext context) {
    String message;
    String title;
    String lottieAnimation;
    String buttonText;

    if (score >= 0.8) {
      message = 'Congratulations, you won ${state.correctNo} points';
      title = 'Congratulations';
      lottieAnimation = 'assets/images/win.json';
      buttonText = 'Claim';
    } else if (score >= 0.5) {
      message = 'Good job! You scored ${state.correctNo} points';
      title = 'Good Job';
      lottieAnimation = 'assets/images/win.json';
      buttonText = 'Okay';
    } else {
      message = 'You scored ${state.correctNo} points. Better luck next time!';
      title = 'Not Good';
      lottieAnimation = 'assets/images/lose.json';
      buttonText = 'Okay';
    }

    // Display the dialog
    Dialogs.materialDialog(
      color: AppColors.background,
      barrierDismissible: false,
      msg: message,
      title: title,
      lottieBuilder: Lottie.asset(
        lottieAnimation,
        fit: BoxFit.contain,
      ),
      context: context,
      actionsBuilder: (BuildContext context) {
        return [
          ShadButton(
            pressedBackgroundColor: Colors.transparent,
            onPressed: () {
              if (score >= 0.8) {
                GoRouter.of(context).goNamed(AppRoutes.home.name);
              } else {
                GoRouter.of(context).goNamed(AppRoutes.home.name);
              }
            },
            child: Text(
              buttonText,
            ),
          ),
        ];
      },
    );
  }
}

const optionsHeaders = ['A', 'B', 'C', 'D'];
