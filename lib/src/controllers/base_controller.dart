import 'package:flutter/material.dart';

abstract class BaseController extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
