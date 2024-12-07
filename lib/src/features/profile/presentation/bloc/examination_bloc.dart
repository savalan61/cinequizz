import 'dart:async';
import 'dart:math' hide log;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'examination_event.dart';
part 'examination_state.dart';

class NumberBloc extends Bloc<NumberEvent, AddState> {
  NumberBloc() : super(const AddState.initial()) {
    on<SelectNumber>(_onSelectNumber);
    on<BuildExam>(_onBuildExam);
  }

  Future<void> _onSelectNumber(
    SelectNumber event,
    Emitter<AddState> emit,
  ) async {
    emit(
      state.firstNumber == 0
          ? state.copyWith(
              status: SubmitStatus.firstSubmitted,
              firstNumber: event.number,
            )
          : state.copyWith(
              status: SubmitStatus.secondSubmitted,
              secondNumber: event.number,
              score: state.firstNumber + event.number == state.exam[0]
                  ? state.copyWith(score: state.score + 1).score
                  : state.score,
            ),
    );
  }

  Future<void> _onBuildExam(BuildExam event, Emitter<AddState> emit) async {
    emit(
      const AddState.initial().copyWith(
        score: state.score,
        crntExamNo: state.crntExamNo,
      ),
    );
    final exam = createEquation();
    final shuffledExam = List<int>.from(exam.sublist(1))..shuffle(Random());

    emit(
      state.copyWith(
        exam: exam,
        shuffledExam: shuffledExam,
        crntExamNo: state.copyWith(crntExamNo: state.crntExamNo + 1).crntExamNo,
      ),
    );
  }

  List<int> createEquation() {
    const maxNumber = 5;
    final random = Random();
    final x = random.nextInt(maxNumber) + 1;
    final y = random.nextInt(maxNumber) + 1;
    final answer = x + y;
    return [
      answer,
      y,
      x,
      random.nextInt(maxNumber) + 1,
      random.nextInt(maxNumber) + 1,
      random.nextInt(maxNumber) + 1,
      random.nextInt(maxNumber) + 1,
    ];
  }
}
