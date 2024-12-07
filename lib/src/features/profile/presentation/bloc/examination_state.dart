part of 'examination_bloc.dart';

enum SubmitStatus {
  idl,
  firstSubmitted,
  secondSubmitted;

  bool get isIdl => this == SubmitStatus.idl;
  bool get isFirstSubmit => this == SubmitStatus.firstSubmitted;
  bool get isSecondSubmit => this == SubmitStatus.secondSubmitted;
}

class AddState extends Equatable {
  const AddState({
    required this.status,
    required this.firstNumber,
    required this.secondNumber,
    required this.score,
    required this.exam,
    required this.shuffledExam,
    required this.crntExamNo,
  });

  const AddState.initial()
      : this(
          status: SubmitStatus.idl,
          firstNumber: 0,
          secondNumber: 0,
          score: 0,
          exam: const [],
          shuffledExam: const [],
          crntExamNo: 0,
        );

  final SubmitStatus status;
  final int firstNumber;
  final int secondNumber;
  final int score;
  final List<int> exam;
  final List<int> shuffledExam;
  final int crntExamNo;

  AddState copyWith({
    SubmitStatus? status,
    int? firstNumber,
    int? secondNumber,
    int? score,
    List<int>? exam,
    List<int>? shuffledExam,
    int? crntExamNo,
  }) =>
      AddState(
        status: status ?? this.status,
        firstNumber: firstNumber ?? this.firstNumber,
        secondNumber: secondNumber ?? this.secondNumber,
        score: score ?? this.score,
        exam: exam ?? this.exam,
        shuffledExam: shuffledExam ?? this.shuffledExam,
        crntExamNo: crntExamNo ?? this.crntExamNo,
      );

  @override
  List<Object?> get props => [
        status,
        firstNumber,
        secondNumber,
        score,
        exam,
        shuffledExam,
        crntExamNo,
      ];
}
