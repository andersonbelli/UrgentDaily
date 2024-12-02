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
    return Visibility(
      visible: isVisible,
      child: Flexible(
        child: Container(
          padding: const EdgeInsets.all(AppPadding.MEDIUM),
          color: Theme.of(context).focusColor,
          child: ListView.builder(
            itemCount: errorMessagesList.length,
            clipBehavior: Clip.antiAlias,
            itemBuilder: (context, index) {
              return Text(
                '* ${errorMessagesList.values.elementAt(index)}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              );
            },
          ),
        ),
      ),
    );
  }
}
