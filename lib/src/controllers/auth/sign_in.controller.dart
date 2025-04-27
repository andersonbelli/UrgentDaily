import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../helpers/di/di.dart';
import '../../helpers/enums/error_fields/sign_in_error_fields.enum.dart';
import '../../helpers/enums/firebase_auth_error.enum.dart';
import '../../helpers/typedefs/error_messages.typedef.dart';
import '../../services/auth/auth.local.service.dart';
import '../../services/auth/auth.remote.service.dart';
import '../base_controller.dart';
import '../snackbar.controller.dart';

class SignInController extends BaseController {
  final AuthRemoteService _remoteAuth;
  final AuthLocalService _localAuth;

  SignInController({
    required AuthRemoteService remoteAuth,
    required AuthLocalService localAuth,
  })  : _remoteAuth = remoteAuth,
        _localAuth = localAuth;

  ErrorMessagesMap<SignInErrorFieldsEnum> validationErrorMessages = {};

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> verifyLocalUser() async {
    try {
      if (await _localAuth.getLocalUser() == null) {
        await _remoteAuth.signInAnonymously().timeout(
              const Duration(seconds: 10),
            );
      }
    } catch (e) {
      debugPrint('❌ Anonymous sign-in failed or timed out: $e');
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    await apiCall(
      callHandler: () => _remoteAuth.loginWithEmail(
        email.trim(),
        password.trim(),
      ),
      errorHandler: (errorCode, stack) {
        log(
          'Login Error:',
          name: '$runtimeType',
          error: errorCode,
          stackTrace: stack,
        );
        final errorMessage = FirebaseAuthError.fromCode(errorCode).message;

        log(errorMessage);
        getIt.get<SnackbarController>().showSnackbar(
              message: errorMessage,
            );
      },
    );
  }

  Future<void> loginWithGoogle() async {
    await apiCall(
      callHandler: () => _remoteAuth.loginWithGoogle(),
      errorHandler: (error, stack) {
        log('Login with Google Error: $error\n$stack');
        throw validateError(error);
      },
    );
  }

  Future<void> resetPassword(String email) async {
    await apiCall(
      callHandler: () => _remoteAuth.resetPassword(email.trim()),
      errorHandler: (error, stack) {
        log('Reset password Error: $error\n$stack');
        throw validateError(error);
      },
    );
  }

  Future<void> logout() async {
    await _remoteAuth.logout();
    notifyListeners();
  }

  void validateFields() {
    if (emailController.text.isEmpty &&
        !validationErrorMessages.containsKey(SignInErrorFieldsEnum.EMAIL_CANT_BE_EMPTY)) {
      validationErrorMessages[SignInErrorFieldsEnum.EMAIL_CANT_BE_EMPTY] =
          SignInErrorFieldsEnum.EMAIL_CANT_BE_EMPTY.message;
    }
    if (passwordController.text.isEmpty &&
        !validationErrorMessages.containsKey(SignInErrorFieldsEnum.PASSWORD_CANT_BE_EMPTY)) {
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

    if (errorMessage.contains('internal error') || validationErrorMessages.values.isEmpty) {
      validationErrorMessages.clear();
      validationErrorMessages[SignInErrorFieldsEnum.INTERNAL_SERVER_ERROR] =
          SignInErrorFieldsEnum.INTERNAL_SERVER_ERROR.message;
    } else if (errorMessage.contains('password')) {
      validationErrorMessages.clear();
      validationErrorMessages[SignInErrorFieldsEnum.INCORRECT_EMAIL_OR_PASSWORD] =
          SignInErrorFieldsEnum.INCORRECT_EMAIL_OR_PASSWORD.message;
    }
    return validationErrorMessages.values.first;
  }
}
