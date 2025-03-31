// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../constants/colors.constants.dart';

enum TaskPriority {
  URGENT,
  IMPORTANT,
  IMPORTANT_NOT_URGENT,
  NOT_IMPORTANT;

  String get name => toString().split('_').join(' ');

  Color get color {
    switch (this) {
      case URGENT:
        return AppColors.PINK;
      case IMPORTANT:
        return AppColors.PURPLE;
      case IMPORTANT_NOT_URGENT:
        return AppColors.BLUE_LIGHT;
      case NOT_IMPORTANT:
        return AppColors.GRAY_LIGHT;
    }
  }
}
