import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../controllers/auth/sign_in.controller.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../helpers/di/di.dart';
import '../../../helpers/enums/error_fields/sign_in_error_fields.enum.dart';
import '../../../localization/localization.dart';
import '../../widgets/default_appbar_child.widget.dart';
import '../../widgets/message_dialog.widget.dart';
import '../../widgets/text_field_with_title.widget.dart';
import '../sign_up/sign_up.view.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});

  static const routeName = '/sing_in';

  final auth = getIt<SignInController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarChild(
          Text(t.signIn),
        ),
      ),
      body: auth.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(AppPadding.MEDIUM),
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
                      final hasEmptyEmailError =
                          auth.validationErrorMessages.containsKey(
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
                      final hasEmptyPasswordError =
                          auth.validationErrorMessages.containsKey(
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
                  const SizedBox(height: AppPadding.LARGE),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text(t.forgotPassword),
                        onPressed: () async {
                          String dialogMessage = '';

                          if (auth.emailController.text.isEmpty) {
                            dialogMessage = t.emailCantBeEmpty;
                          } else {
                            try {
                              await auth
                                  .resetPassword(auth.emailController.text);
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
                      ElevatedButton(
                        onPressed: (auth.emailController.text.isNotEmpty &&
                                auth.passwordController.text.isNotEmpty)
                            ? () async {
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
                              }
                            : null,
                        child: Text(t.signIn),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppPadding.LARGE),
                  ElevatedButton(
                    child: Text(t.loginWithGoogle),
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
                  ),
                  const SizedBox(height: AppPadding.LARGE),
                  CupertinoButton(
                    child: Text(t.signUp),
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => FractionallySizedBox(
                        heightFactor: 0.9,
                        child: SignUpView(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
