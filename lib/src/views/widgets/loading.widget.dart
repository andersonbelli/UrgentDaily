import 'package:flutter/material.dart';

import '../../helpers/constants/colors.constants.dart';

Widget loadingWidget(bool isLoading) => isLoading
    ? Container(
        color: AppColors.DARK.withOpacity(0.8),
        width: double.infinity,
        height: double.infinity,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.GREEN),
          ),
        ),
      )
    : const SizedBox.shrink();
