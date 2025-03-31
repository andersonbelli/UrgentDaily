import 'package:flutter/material.dart';

import '../../helpers/constants/colors.constants.dart';

class TextFieldWithTitle extends StatelessWidget {
  const TextFieldWithTitle({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.maxLength = 120,
    this.hasError = false,
    this.errorText = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  final int maxLength;
  final String hintText;
  final bool hasError;
  final String errorText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Theme.of(context).colorScheme.outline,
      cursorErrorColor: Theme.of(context).colorScheme.outline,
      maxLength: maxLength,
      obscureText: obscureText,
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.GRAY,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: hasError ? Theme.of(context).colorScheme.error : AppColors.DARK_LIGHT.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.GRAY),
        ),
        errorText: errorText,
      ),
      keyboardType: keyboardType,
      controller: controller,
      onChanged: onChanged,
    );
  }
}
