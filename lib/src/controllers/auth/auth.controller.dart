import '../../helpers/enums/error_fields/sign_up_error_fields.enum.dart';
import '../../helpers/typedefs/error_messages.typedef.dart';
import '../../services/auth/auth.service.dart';
import '../base_controller.dart';

class AuthController extends BaseController {
  final AuthService _auth;

  ErrorMessagesMap<SignUpErrorFieldsEnum> validationErrorMessages = {};

  AuthController({required AuthService auth}) : _auth = auth;

  Future<void> signUpWithEmail(String email, String password) async {
    toggleLoading();
    await _auth
        .signUpWithEmail(
          email.trim(),
          password.trim(),
        )
        .whenComplete(() => toggleLoading());
  }

  Future<void> loginWithEmail(String email, String password) async {
    toggleLoading();
    await _auth
        .loginWithEmail(
          email.trim(),
          password.trim(),
        )
        .whenComplete(() => toggleLoading());
  }

  Future<void> loginWithGoogle() async {
    toggleLoading();
    _auth.loginWithGoogle().whenComplete(() => toggleLoading());
  }

  Future<void> resetPassword(String email) async {
    await _auth.resetPassword(email.trim());
  }

  Future<void> logout() async {
    await _auth.logout();
    notifyListeners();
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'Password cannot be empty';

    final hasMinLength = value.length >= 8;
    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasSpecialChar = value.contains(RegExp(r'[!@#$&*~]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));

    if (!hasMinLength) {
      return 'Password must be at least 8 characters long';
    }
    if (!hasUppercase) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!hasLowercase) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!hasSpecialChar) {
      return 'Password must contain at least one special character';
    }
    if (!hasNumber) {
      return 'Password must contain at least one number';
    }

    return null;
  }
}
