part of 'operation_cubit.dart';

sealed class OperationState extends Equatable {
  const OperationState();

  @override
  List<Object> get props => [];
}

final class OperationInitial extends OperationState {
  const OperationInitial({required this.correctAnswersCount});

  final int correctAnswersCount;
}

final class FirstOperationAnswer extends OperationState {
  const FirstOperationAnswer({required this.firstAnswer});

  final int firstAnswer;
}

final class SecondsOperationAnswer extends FirstOperationAnswer {
  const SecondsOperationAnswer({
    required this.secondAnswer,
    required super.firstAnswer,
  });

  final int secondAnswer;
}

final class CorrectAnswersCount extends OperationState {}
