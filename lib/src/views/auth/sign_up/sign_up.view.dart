import 'package:flutter/material.dart';

import '../../../../routes.dart';
import '../../../controllers/auth/sign_up.controller.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../helpers/di/di.dart';
import '../../../localization/localization.dart';
import '../../widgets/default_scaffold.widget.dart';
import '../../widgets/error_messages_container.widget.dart';
import '../../widgets/message_dialog.widget.dart';
import '../../widgets/text_shadow.widget.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  static const String routeName = Routes.signUp;

  final auth = getIt<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      appBarText: t.signUp,
      controller: auth,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              dense: true,
              trailing: const CloseButton(),
              title: TextShadow(text: t.signUp),
            ),
            Padding(
              padding: const EdgeInsets.all(AppPadding.size16),
              child: Form(
                key: auth.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: auth.emailController,
                      decoration: InputDecoration(labelText: t.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t.emailCantBeEmpty;
                        }
                        return null;
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: AppPadding.size16,
                      ),
                      child: TextFormField(
                        controller: auth.passwordController,
                        decoration: InputDecoration(labelText: t.password),
                        obscureText: true,
                      ),
                    ),
                    TextFormField(
                      controller: auth.confirmPasswordController,
                      decoration: InputDecoration(labelText: t.confirmPassword),
                      obscureText: true,
                      validator: (value) {
                        if (value != auth.passwordController.text) {
                          return t.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppPadding.size24),
                    ElevatedButton(
                      child: Text(t.signUp),
                      onPressed: () async {
                        if (auth.formKey.currentState!.validate()) {
                          try {
                            await auth.signUpWithEmail(
                              auth.emailController.text,
                              auth.passwordController.text,
                            );

                            if (context.mounted) Navigator.pop(context);
                          } catch (e) {
                            if (context.mounted) {
                              showMessageDialog(context, e.toString());
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            ErrorMessagesContainer(
              isVisible: auth.validationErrorMessages.isNotEmpty,
              errorMessagesList: auth.validationErrorMessages,
            ),
          ],
        ),
      ),
    );
  }
}
