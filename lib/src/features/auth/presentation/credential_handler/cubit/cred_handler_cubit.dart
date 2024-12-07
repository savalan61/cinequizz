import 'package:bloc/bloc.dart';

class CredHandlerCubit extends Cubit<CredPage> {
  CredHandlerCubit() : super(CredPage.login);
  void changeAuthPage(CredPage page) => emit(page);
}

enum CredPage {
  login,
  signUp,
  forgotPassword;
}
