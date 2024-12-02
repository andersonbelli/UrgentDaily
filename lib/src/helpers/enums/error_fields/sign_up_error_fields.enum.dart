// ignore_for_file: constant_identifier_names

import '../../../localization/localization.dart';
import 'error_fields.dart';

enum SignUpErrorFieldsEnum implements ErrorFields {
  EMAIL_CANT_BE_EMPTY,
  INVALID_EMAIL,
  EMAIL_ALREADY_EXISTS,
  PASSWORDS_DO_NOT_MATCH,
  PASSWORD_TOO_SHORT,
  PASSWORD_REQUIRES_UPPERCASE,
  PASSWORD_REQUIRES_LOWERCASE,
  PASSWORD_REQUIRES_NUMBER,
  PASSWORD_REQUIRES_SPECIAL_CHARACTER;

  @override
  String get message {
    switch (this) {
      case EMAIL_CANT_BE_EMPTY:
        return t.emailCantBeEmpty;
      case INVALID_EMAIL:
        return t.invalidEmail;
      case EMAIL_ALREADY_EXISTS:
        return t.emailAlreadyExists;
      case PASSWORDS_DO_NOT_MATCH:
        return t.passwordsDoNotMatch;
      case PASSWORD_TOO_SHORT:
        return t.passwordTooShort;
      case PASSWORD_REQUIRES_UPPERCASE:
        return t.passwordRequiresUppercase;
      case PASSWORD_REQUIRES_LOWERCASE:
        return t.passwordRequiresLowercase;
      case PASSWORD_REQUIRES_NUMBER:
        return t.passwordRequiresNumber;
      case PASSWORD_REQUIRES_SPECIAL_CHARACTER:
        return t.passwordRequiresSpecialCharacter;
      default:
        return '';
    }
  }
}
