import 'package:flutter/foundation.dart';

import '../helpers/di/di.dart';
import '../services/auth/auth.service.dart';

class BaseController with ChangeNotifier {
  String? _message;

  String? get message => _message;

  void showToastMessage(String newMessage) async {
    _message = newMessage;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _message = null; // Reset after notifying
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void toggleLoading() {
    _isLoading = !_isLoading;

    notifyListeners();
  }

  // TODO: save this data on local database -> check only once per session
  bool? _checkedIfUserIsLoggedIn;

  bool? get checkedIfUserIsLoggedIn => _checkedIfUserIsLoggedIn;
  set checkedIfUserIsLoggedIn(bool? value) {
    _checkedIfUserIsLoggedIn = value;
    notifyListeners();
  }

  bool get isUserLoggedIn {
    final user = getIt.get<AuthService>().user;

    if (user.isAnonymous || (user.email?.isEmpty ?? true)) {
      return false;
    }

    return true;
  }

  Future<T?> apiCall<T>({
    required Future<T> Function() callHandler,
    required void Function(String error, StackTrace stack) errorHandler,
  }) async {
    toggleLoading();

    try {
      return await callHandler();
    } catch (error, stack) {
      errorHandler(error.toString(), stack);
    } finally {
      toggleLoading();
    }
    return null;
  }
}
