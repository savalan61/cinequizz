import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:formz/formz.dart' show FormzInput;
import 'package:cinequizz/src/core/form_fields/_forms.dart';

@immutable
class Password extends FormzInput<String, PasswordValidationError>
    with EquatableMixin, FormzValidationMixin {
  /// {@macro password.pure}
  const Password.pure([super.value = '']) : super.pure();

  /// {@macro password.dirty}
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 6 || value.length > 120) {
      return PasswordValidationError.invalid;
    } else {
      return null;
    }
  }

  @override
  Map<PasswordValidationError?, String?> get validationErrorMessage => {
        PasswordValidationError.empty: 'This field is required',
        PasswordValidationError.invalid:
            'Password should contain at least 6 characters',
        null: null,
      };

  @override
  List<Object?> get props => [value, pure];
}

/// Validation errors for [Password]. It can be empty or invalid.
enum PasswordValidationError {
  /// Empty password.
  empty,

  /// Invalid password.
  invalid,
}
