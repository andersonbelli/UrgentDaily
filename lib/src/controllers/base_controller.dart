import 'package:flutter/material.dart';

class BaseController with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void toggleLoading() {
    _isLoading = !_isLoading;

    notifyListeners();
  }
}
