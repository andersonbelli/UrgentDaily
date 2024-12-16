import 'dart:developer';

import 'package:flutter/material.dart';

import '../../helpers/enums/error_fields/sign_in_error_fields.enum.dart';
import '../../helpers/typedefs/error_messages.typedef.dart';
import '../../services/auth/auth.service.dart';
import '../base_controller.dart';

class SignInController extends BaseController {
  final AuthService _auth;

  ErrorMessagesMap<SignInErrorFieldsEnum> validationErrorMessages = {};

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInController({required AuthService auth}) : _auth = auth;

  Future<void> loginWithEmail(String email, String password) async {
    await apiCall(
      callHandler: () => _auth.loginWithEmail(
        email.trim(),
        password.trim(),
      ),
      errorHandler: (error, stack) {
        log('Login Error: $error\n$stack');
        throw validateError(error);
      },
    );
  }

  Future<void> loginWithGoogle() async {
    await apiCall(
      callHandler: () => _auth.loginWithGoogle(),
      errorHandler: (error, stack) {
        log('Login with Google Error: $error\n$stack');
        throw validateError(error);
      },
    );
  }

  Future<void> resetPassword(String email) async {
    await apiCall(
      callHandler: () => _auth.resetPassword(email.trim()),
      errorHandler: (error, stack) {
        log('Reset password Error: $error\n$stack');
        throw validateError(error);
      },
    );
  }

  Future<void> logout() async {
    await _auth.logout();
    notifyListeners();
  }

  void validateFields() {
    if (emailController.text.isEmpty &&
        !validationErrorMessages
            .containsKey(SignInErrorFieldsEnum.EMAIL_CANT_BE_EMPTY)) {
      validationErrorMessages[SignInErrorFieldsEnum.EMAIL_CANT_BE_EMPTY] =
          SignInErrorFieldsEnum.EMAIL_CANT_BE_EMPTY.message;
    }
    if (passwordController.text.isEmpty &&
        !validationErrorMessages
            .containsKey(SignInErrorFieldsEnum.PASSWORD_CANT_BE_EMPTY)) {
      validationErrorMessages[SignInErrorFieldsEnum.PASSWORD_CANT_BE_EMPTY] =
          SignInErrorFieldsEnum.PASSWORD_CANT_BE_EMPTY.message;
    }

    notifyListeners();
  }

  void removeValidationError(SignInErrorFieldsEnum field) {
    validationErrorMessages.remove(field);
    notifyListeners();
  }

  String validateError(String errorMessage) {
    errorMessage = errorMessage.toLowerCase();

    if (errorMessage.contains('internal error')) {
      validationErrorMessages.clear();
      validationErrorMessages[SignInErrorFieldsEnum.INTERNAL_SERVER_ERROR] =
          SignInErrorFieldsEnum.INTERNAL_SERVER_ERROR.message;
    } else if (errorMessage.contains('password')) {
      validationErrorMessages.clear();
      validationErrorMessages[
              SignInErrorFieldsEnum.INCORRECT_EMAIL_OR_PASSWORD] =
          SignInErrorFieldsEnum.INCORRECT_EMAIL_OR_PASSWORD.message;
    }
    return validationErrorMessages.values.first;
  }
}
