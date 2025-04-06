import 'package:flutter/foundation.dart';

class BaseController with ChangeNotifier {
  String? _message;

  String? get message => _message;

  void showMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
    _message = null; // Reset after notifying
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void toggleLoading() {
    _isLoading = !_isLoading;

    notifyListeners();
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
