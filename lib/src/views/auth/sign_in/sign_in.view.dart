import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../routes.dart';
import '../../../controllers/auth/sign_in.controller.dart';
import '../../../helpers/constants/colors.constants.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../helpers/di/di.dart';
import '../../../helpers/enums/error_fields/sign_in_error_fields.enum.dart';
import '../../../localization/localization.dart';
import '../../widgets/dashed_border.widget.dart';
import '../../widgets/default_scaffold.widget.dart';
import '../../widgets/green_button.widget.dart';
import '../../widgets/message_dialog.widget.dart';
import '../../widgets/text_field_with_title.widget.dart';
import '../../widgets/text_shadow.widget.dart';
import '../../widgets/text_underline.widget.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});

  static const String routeName = Routes.singIn;

  final auth = getIt<SignInController>();

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      appBarText: t.signIn,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.size16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFieldWithTitle(
                hintText: t.email,
                controller: auth.emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  auth.emailController.clearComposing();

                  final isNotEmpty = value.trim().isNotEmpty;
                  final hasEmptyEmailError = auth.validationErrorMessages.containsKey(
                    SignInErrorFieldsEnum.EMAIL_CANT_BE_EMPTY,
                  );

                  if (isNotEmpty && hasEmptyEmailError) {
                    auth.removeValidationError(
                      SignInErrorFieldsEnum.EMAIL_CANT_BE_EMPTY,
                    );
                  } else {
                    auth.validateFields();
                  }
                },
              ),
              TextFieldWithTitle(
                hintText: t.password,
                controller: auth.passwordController,
                obscureText: true,
                onChanged: (value) {
                  auth.passwordController.clearComposing();

                  final isNotEmpty = value.trim().isNotEmpty;
                  final hasEmptyPasswordError = auth.validationErrorMessages.containsKey(
                    SignInErrorFieldsEnum.PASSWORD_CANT_BE_EMPTY,
                  );

                  if (isNotEmpty && hasEmptyPasswordError) {
                    auth.removeValidationError(
                      SignInErrorFieldsEnum.PASSWORD_CANT_BE_EMPTY,
                    );
                  } else {
                    auth.validateFields();
                  }
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: TextShadow(
                    text: t.forgotPassword,
                    fontSize: 14,
                    shadowOpacity: 1,
                    weight: FontWeight.normal,
                    color: AppColors.GRAY,
                  ),
                  onPressed: () async {
                    String dialogMessage = '';

                    if (auth.emailController.text.isEmpty) {
                      dialogMessage = t.emailCantBeEmpty;
                    } else {
                      try {
                        await auth.resetPassword(auth.emailController.text);
                        dialogMessage = t.resetPasswordEmailSent;
                      } catch (e) {
                        dialogMessage = e.toString();
                      }
                    }

                    if (context.mounted) {
                      showMessageDialog(
                        context,
                        dialogMessage,
                      );
                    }
                  },
                ),
              ),
              GreenButton(
                text: t.signIn,
                margin: EdgeInsets.zero,
                isDisabled: auth.emailController.text.isEmpty && auth.passwordController.text.isEmpty,
                onTap: () async {
                  try {
                    await auth.loginWithEmail(
                      auth.emailController.text,
                      auth.passwordController.text,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      showMessageDialog(
                        context,
                        e.toString(),
                      );
                    }
                  }
                },
              ),
              Text(t.or),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.RED.withOpacity(0.8),
                  ),
                ),
                onPressed: () async {
                  try {
                    await auth.loginWithGoogle();
                  } catch (e) {
                    if (context.mounted) {
                      showMessageDialog(
                        context,
                        e.toString(),
                      );
                    }
                  }
                },
                child: Text(
                  t.loginWithGoogle,
                  style: const TextStyle(color: AppColors.DARK),
                ),
              ),
              const SizedBox(height: AppPadding.size24),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const DashedDivider(),
              ),
              CupertinoButton(
                child: TextUnderline(
                  t.signUp,
                  textSize: 20,
                ),
                onPressed: () => Navigator.pushNamed(
                  context,
                  Routes.signUp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
