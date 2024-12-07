import 'package:bloc/bloc.dart';

class CredHandlerCubit extends Cubit<bool> {
  CredHandlerCubit() : super(true);
  void changeAuthPage() => emit(!state);
}
