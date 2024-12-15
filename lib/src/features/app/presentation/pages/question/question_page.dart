// ignore_for_file: flutter_style_todos, prefer_const_constructors, avoid_redundant_argument_values, lines_longer_than_80_chars, use_build_context_synchronously, unnecessary_statements

import 'dart:developer';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cinequizz/src/features/app/domain/entities/answered_questions.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:just_audio/just_audio.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
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
    questionCubit.resetQuestionCubit();
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
  final CountDownController timer = CountDownController();
  final player = AudioPlayer();
  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bool autoStart = true;
    final serieState = context.select((SeriesCubit bloc) => bloc.state);
    final userStats = serieState.currentUserStats;
    player.setAudioSource(AudioSource.asset('assets/sounds/clock.mp3'));

    final answeredQuestions = userStats.answeredQuestions
        .firstWhere(
          (element) => element.seriesId == widget.seriesId,
          orElse: () => AnsweredQuestions.empty(),
        )
        .questions;

    final currentSeries = serieState.series.firstWhere(
      (element) => element.seriesId == widget.seriesId,
    );
    final isLastQuestion =
        answeredQuestions.length == currentSeries.totalQuestionNo;

    final totalScore = serieState.totalScore;
    return BlocConsumer<QuestionCubit, QuestionsState>(
      listener: (context, state) {
        if (isLastQuestion) {
          log('finished');
          context.pop();
        }
      },
      builder: (context, state) {
        return AppScaffold(
          safeArea: true,
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              children: [
                Text(
                  'Total Score: ',
                  style:
                      context.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                AnimatedFlipCounter(
                  duration: 1.seconds,
                  value: totalScore,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: totalScore > 0 ? AppColors.blue : AppColors.red,
                    shadows: [
                      BoxShadow(
                        color: totalScore > 0 ? AppColors.blue : AppColors.red,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                          totalSteps: currentSeries.totalQuestionNo,
                          currentStep: answeredQuestions.length + 1,
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
                                  currentSeries.totalQuestionNo - 1,
                              pressedBackgroundColor: Colors.transparent,
                              onPressed: () {
                                if (state.currentQuestionNo <
                                    currentSeries.totalQuestionNo - 1) {
                                  timer.pause();
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    timer.start,
                                  );
                                  context.read<QuestionCubit>().submitAnswer(
                                      selectedOption: -10, user: widget.user);
                                }
                              },
                              child: Text(
                                state.currentQuestionNo !=
                                        currentSeries.totalQuestionNo - 1
                                    ? 'Next'
                                    : 'Finished',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

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
                              child: Tappable.faded(
                                throttle: true,
                                throttleDuration: const Duration(seconds: 1),
                                borderRadius: 5,
                                backgroundColor: !state.colors[option]
                                    ? AppColors.lightDark
                                    : Colors.green,
                                onTap: () {
                                  if (state.enableBtn) {
                                    timer.pause();
                                    context.read<QuestionCubit>().submitAnswer(
                                        selectedOption: option + 1,
                                        user: widget.user);
                                    if (state.currentQuestionNo <
                                        currentSeries.totalQuestionNo - 1) {
                                      Future.delayed(
                                        const Duration(seconds: 1),
                                        timer.start,
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
                            duration: AppConstants.questionTimeLimit,
                            initialDuration: 0,
                            controller: timer,
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
                            autoStart: autoStart,
                            onStart: () {
                              player.play();
                            },
                            onComplete: () {
                              if (state.currentQuestionNo <
                                  currentSeries.totalQuestionNo - 1) {
                                context.read<QuestionCubit>().submitAnswer(
                                    selectedOption: -10, user: widget.user);
                                Future.delayed(
                                  const Duration(seconds: 1),
                                  timer.start,
                                );
                              } else {
                                timer.pause();
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
}

const optionsHeaders = ['A', 'B', 'C', 'D'];
