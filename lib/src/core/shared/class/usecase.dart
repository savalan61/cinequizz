// ignore_for_file: one_member_abstracts

import 'package:fpdart/fpdart.dart';
import 'package:cinequizz/src/core/shared/class/failure.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
