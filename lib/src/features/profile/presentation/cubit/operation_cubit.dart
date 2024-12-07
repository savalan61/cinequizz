import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'operation_state.dart';

class OperationCubit extends Cubit<OperationState> {
  OperationCubit() : super(const OperationInitial(correctAnswersCount: 0));

  void setFirstAnswer(int firstAnswer) =>
      emit(FirstOperationAnswer(firstAnswer: firstAnswer));
  void setSecondsAnswer(int secondAnswer) => emit(
        SecondsOperationAnswer(
          secondAnswer: secondAnswer,
          firstAnswer: (state as FirstOperationAnswer).firstAnswer,
        ),
      );
  int correctAnswersCount = 0;
  void addCorrectAnswersCount() {
    correctAnswersCount++;
    // emit(CorrectAnswersCount());
  }
}
