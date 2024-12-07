part of 'question_cubit.dart';

enum Status {
  idl,
  finished,
  loaded,
  loading;
}

class QuestionsState {
  QuestionsState({
    required this.questions,
    required this.status,
    required this.colors,
    required this.currentQuestionNo,
    required this.correctNo,
    required this.wrongNo,
    required this.enableBtn,
  });
  QuestionsState.initial({
    this.questions = const [],
    this.status = Status.idl,
    this.colors = const [false, false, false, false],
    this.currentQuestionNo = 0,
    this.correctNo = 0,
    this.wrongNo = 0,
    this.enableBtn = true,
  });
  final List<QuestionEntity> questions;
  final int correctNo;
  final int wrongNo;
  final Status status;
  final List<bool> colors;
  final int currentQuestionNo;
  final bool enableBtn;
  QuestionsState copyWith({
    List<QuestionEntity>? questions,
    Status? status,
    int? correctNo,
    int? wrongNo,
    List<bool>? colors,
    int? currentQuestionNo,
    bool? enableBtn,
  }) {
    return QuestionsState(
      wrongNo: wrongNo ?? this.wrongNo,
      questions: questions ?? this.questions,
      status: status ?? this.status,
      correctNo: correctNo ?? this.correctNo,
      colors: colors ?? this.colors,
      currentQuestionNo: currentQuestionNo ?? this.currentQuestionNo,
      enableBtn: enableBtn ?? this.enableBtn,
    );
  }
}
