// ignore_for_file: lines_longer_than_80_chars

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';
import 'package:cinequizz/src/features/app/domain/usecases/_usecases.dart';
import 'package:cinequizz/src/features/auth/domain/models/auth_user_model.dart';
import 'package:cinequizz/src/features/auth/presentation/app/presentation/bloc/app_bloc.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionsState> {
  QuestionCubit({
    required SeriesQuestionsUsecase seriesQuestionsUsecase,
    required SaveAnsweredQuestionsUsecase saveAnsweredQuestionsUsecase,
  })  : _seriesQuestionsUsecase = seriesQuestionsUsecase,
        _answeredQuestionsUsecase = saveAnsweredQuestionsUsecase,
        super(QuestionsState.initial());
  final SeriesQuestionsUsecase _seriesQuestionsUsecase;
  final SaveAnsweredQuestionsUsecase _answeredQuestionsUsecase;
  // final user = (sl<AppBloc>().state as Authenticated).user;

  void submitAnswer({required int selectedOption, required AuthUser user}) {
    final isCorrect =
        selectedOption == state.questions[state.currentQuestionNo].answerNo;
    final seriesId = state.questions[state.currentQuestionNo].seriesId;
    final questionId = state.questions[state.currentQuestionNo].questionId;

    saveAnswer(
      Answer(
          userId: user.id,
          seriesId: seriesId,
          questionId: questionId,
          isCorrect: selectedOption < 0 ? null : isCorrect,
          userName: user.name ?? user.email!,
          avatarSeed: user.avatarSeed ?? 'mahsa'),
    );
    emit(
      state.copyWith(
        enableBtn: false,
        correctNo: isCorrect ? state.correctNo + 1 : state.correctNo,
        wrongNo: isCorrect ? state.wrongNo : state.wrongNo + 1,
        colors: [
          for (int i = 0; i < state.colors.length; i++)
            if (i == state.questions[state.currentQuestionNo].answerNo - 1)
              true
            else
              state.colors[i],
        ],
      ),
    );
    if (state.currentQuestionNo != state.questions.length - 1) {
      log(state.currentQuestionNo.toString());

      Future.delayed(
        const Duration(seconds: 1),
        () {
          emit(
            state.copyWith(
              enableBtn: true,
              colors: [false, false, false, false],
              currentQuestionNo: state.currentQuestionNo + 1,
            ),
          );
        },
      );
    } else {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          emit(state.copyWith(status: Status.finished));
        },
      );
    }
  }

  Future<void> saveAnswer(Answer answer) async {
    log('Answers saved');
    await _answeredQuestionsUsecase(answer);
  }

  void resetQuestionCubit() => emit(QuestionsState.initial());

  Future<void> getSeriesQuestions({
    required String seriesId,
    required String userId,
  }) async {
    emit(state.copyWith(status: Status.loading));
    final res = await _seriesQuestionsUsecase(
      UnAnsweredQuestions(userId: userId, seriesId: seriesId),
    );
    res.fold(
      (l) => log(l.message),
      (r) {
        emit(
          state.copyWith(
            questions: r,
            status: Status.loaded,
          ),
        );
      },
    );
  }
}











// // Function to find series name by seriesId
// String findSeriesNameById(List<SeriesEntity> seriesData, String seriesId) {
//   return seriesData.firstWhere((series) => series.seriesId == seriesId).name;
// }

// Future<void> uploadSampleData() async {
//   final db = FirebaseFirestore.instance;

//   // Sample Series Data
//   final seriesData = <SeriesEntity>[
//     const SeriesEntity(
//       seriesId: 's1',
//       name: 'Breaking Bad',
//       imgUrl:
//           'https://firebasestorage.googleapis.com/v0/b/store-65e6b.appspot.com/o/movie%2Fseries_images%2FBreaking%20Bad.png?alt=media&token=5d29f876-a600-4d20-a6fc-d27af3eb4cc7',
//     ),
//     const SeriesEntity(
//       seriesId: 's2',
//       name: 'Better Call Saul',
//       imgUrl:
//           'https://firebasestorage.googleapis.com/v0/b/store-65e6b.appspot.com/o/movie%2Fseries_images%2FBetter%20Call%20Saul.png?alt=media&token=43a90a8e-ed77-43f2-91a9-0f62730da527',
//     ),
//     // Additional series
//     const SeriesEntity(
//       seriesId: 's3',
//       name: 'The Sopranos',
//       imgUrl:
//           'https://firebasestorage.googleapis.com/v0/b/store-65e6b.appspot.com/o/movie%2Fseries_images%2FThe%20Sopranos.png?alt=media&token=9718319f-ebbf-43f2-ab30-2f587178a11a',
//     ),
//     const SeriesEntity(
//       seriesId: 's4',
//       name: 'The Wire',
//       imgUrl:
//           'https://firebasestorage.googleapis.com/v0/b/store-65e6b.appspot.com/o/movie%2Fseries_images%2Fthe%20wire.png?alt=media&token=d6edcff3-c237-47db-b591-d0416626a5b2',
//     ),
//   ];
// }
