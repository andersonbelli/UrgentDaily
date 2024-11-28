import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../controllers/auth/sign_in.controller.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../helpers/di/di.dart';
import '../../../helpers/enums/error_fields/sign_in_error_fields.enum.dart';
import '../../../localization/localization.dart';
import '../../widgets/text_field_with_title.widget.dart';
import '../sign_up/sign_up.view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  static const routeName = '/sing_in';

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final auth = getIt<SignInController>();

  @override
  void dispose() {
    auth.emailController.dispose();
    auth.passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(t.errorTitle),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(t.errorOkButton),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.signIn),
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
                          if (auth.emailController.text.isEmpty) {
                            _showErrorDialog(
                              t.emailCantBeEmpty,
                            );
                            return;
                          }
                          try {
                            await auth.resetPassword(auth.emailController.text);
                            _showErrorDialog(
                              t.resetPasswordEmailSent,
                            );
                          } catch (e) {
                            _showErrorDialog(e.toString());
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
                                  _showErrorDialog(e.toString());
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
                        _showErrorDialog(e.toString());
                      }
                    },
                  ),
                  const SizedBox(height: AppPadding.LARGE),
                  CupertinoButton(
                    child: Text(t.signUp),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return const FractionallySizedBox(
                            heightFactor: 0.9,
                            child: SignUpView(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
