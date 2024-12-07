part of 'examination_bloc.dart';

abstract class NumberEvent {}

final class BuildExam extends NumberEvent {}

class SelectNumber extends NumberEvent {
  SelectNumber(this.number);
  final int number;
}
