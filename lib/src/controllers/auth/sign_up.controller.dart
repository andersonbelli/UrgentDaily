import 'package:flutter/material.dart';

import '../../helpers/enums/error_fields/sign_up_error_fields.enum.dart';
import '../../helpers/typedefs/error_messages.typedef.dart';
import '../../localization/localization.dart';
import '../../services/auth/auth.remote.service.dart';
import '../base_controller.dart';

class SignUpController extends BaseController {
  final AuthRemoteService _auth;

  ErrorMessagesMap<SignUpErrorFieldsEnum> validationErrorMessages = {};

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  SignUpController({required AuthRemoteService auth}) : _auth = auth;

  bool get isButtonDisabled =>
      validationErrorMessages.isNotEmpty ||
      (emailController.text.isEmpty && passwordController.text.isEmpty && confirmPasswordController.text.isEmpty);

  Future<void> signUpWithEmail(String email, String password) async {
    await apiCall<void>(
      callHandler: () => _auth.signUpWithEmail(
        email.trim(),
        password.trim(),
      ),
      errorHandler: (error, stack) {
        // Handle the error (e.g., show a snackbar, log it, etc.)
      },
    );
  }

  void validateFields() {
    validationErrorMessages.clear();

    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    validateEmail(email);
    validatePassword(password, confirmPassword);

    notifyListeners();
  }

  void validateEmail(String value) {
    if (value.isEmpty && validationErrorMessages[SignUpErrorFieldsEnum.EMAIL_CANT_BE_EMPTY] == null) {
      validationErrorMessages[SignUpErrorFieldsEnum.EMAIL_CANT_BE_EMPTY] =
          SignUpErrorFieldsEnum.EMAIL_CANT_BE_EMPTY.message;
      return;
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value) && validationErrorMessages[SignUpErrorFieldsEnum.INVALID_EMAIL] == null) {
      validationErrorMessages[SignUpErrorFieldsEnum.INVALID_EMAIL] = SignUpErrorFieldsEnum.INVALID_EMAIL.message;
    }
  }

  void validatePassword(String password, String confirmPassword) {
    final hasMinLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$&*~]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final passwordsMatch = password == confirmPassword;

    if (!hasMinLength) {
      validationErrorMessages[SignUpErrorFieldsEnum.PASSWORD_TOO_SHORT] = t.passwordTooShort;
    }

    if (!hasUppercase) {
      validationErrorMessages[SignUpErrorFieldsEnum.PASSWORD_REQUIRES_UPPERCASE] = t.passwordRequiresUppercase;
    }

    if (!hasLowercase) {
      validationErrorMessages[SignUpErrorFieldsEnum.PASSWORD_REQUIRES_LOWERCASE] = t.passwordRequiresLowercase;
    }

    if (!hasSpecialChar) {
      validationErrorMessages[SignUpErrorFieldsEnum.PASSWORD_REQUIRES_SPECIAL_CHARACTER] =
          t.passwordRequiresSpecialCharacter;
    }

    if (!hasNumber) {
      validationErrorMessages[SignUpErrorFieldsEnum.PASSWORD_REQUIRES_NUMBER] = t.passwordRequiresNumber;
    }

    if (!passwordsMatch) {
      validationErrorMessages[SignUpErrorFieldsEnum.PASSWORDS_DO_NOT_MATCH] =
          SignUpErrorFieldsEnum.PASSWORDS_DO_NOT_MATCH.message;
    }
  }
}
