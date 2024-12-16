import 'package:flutter/material.dart';

import '../../helpers/constants/colors.constants.dart';

Widget loadingWidget(bool isLoading) => isLoading
    ? Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.CREAM.withOpacity(0.7),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.DARK_LIGHT),
            backgroundColor: AppColors.GREEN,
            strokeCap: StrokeCap.square,
          ),
        ),
      )
    : const SizedBox.shrink();
