import 'package:flutter/foundation.dart';

import '../helpers/di/di.dart';
import '../services/auth/auth.local.service.dart';

class BaseController with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void toggleLoading() {
    _isLoading = !_isLoading;

    notifyListeners();
  }

  bool get isUserLoggedIn {
    final user = getIt.get<AuthLocalService>().user;

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
