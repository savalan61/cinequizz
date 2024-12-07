import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    this.email,
    this.name,
    this.photo,
    this.isNewUser = true,
  });

  final String id;
  final String? email;
  final String? name;
  final String? photo;
  final bool isNewUser;

  static const anonymous = AuthUser(id: '');

  bool get isAnonymous => this == anonymous;

  @override
  List<Object?> get props => [id, email, name, photo, isNewUser];
}
