import 'package:abelliz_essentials/constants/colors.constants.dart';
import 'package:flutter/material.dart';

import '../../helpers/constants/padding.constants.dart';
import '../../helpers/typedefs/error_messages.typedef.dart';

class ErrorMessagesContainer extends StatelessWidget {
  const ErrorMessagesContainer({
    super.key,
    required this.isVisible,
    required this.errorMessagesList,
  });

  final bool isVisible;
  final ErrorMessagesMap<Enum> errorMessagesList;

  @override
  Widget build(BuildContext context) {
    if (!isVisible || errorMessagesList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppPadding.size16),
      color: Theme.of(context).focusColor,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 88.0),
            child: Divider(
              color: AppColors.GRAY.withValues(alpha: 0.4),
            ),
          );
        },
        itemCount: errorMessagesList.values.length,
        itemBuilder: (context, index) {
          final errorMessage = errorMessagesList.values.elementAt(index);

          return Text(
            '* $errorMessage',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          );
        },
      ),
    );
  }
}
