import 'error_fields/error_fields.dart';

enum AuthErrorEnum implements ErrorFields {
  UNEXPECTED_ERROR_SIGN_IN,
  UNEXPECTED_ERROR_SIGN_UP,
  UNEXPECTED_ERROR_GOOGLE_SIGNIN,
  ERROR_GOOGLE_SIGNIN,
  GOOGLE_ACCOUNT_ALREADY_LINKED,
  ERROR_RESET_PASSWORD,
  ERROR_ANONYMOUS_SIGNIN,
  USER_NOT_LOGGED;

  @override
  String get message {
    switch (this) {
      case AuthErrorEnum.UNEXPECTED_ERROR_SIGN_IN:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AuthErrorEnum.UNEXPECTED_ERROR_SIGN_UP:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AuthErrorEnum.UNEXPECTED_ERROR_GOOGLE_SIGNIN:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AuthErrorEnum.ERROR_GOOGLE_SIGNIN:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AuthErrorEnum.GOOGLE_ACCOUNT_ALREADY_LINKED:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AuthErrorEnum.ERROR_RESET_PASSWORD:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AuthErrorEnum.ERROR_ANONYMOUS_SIGNIN:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AuthErrorEnum.USER_NOT_LOGGED:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
