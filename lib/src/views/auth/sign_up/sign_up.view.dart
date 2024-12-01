import 'package:flutter/material.dart';

import '../../../controllers/auth/sign_up.controller.dart';
import '../../../helpers/constants/colors.constants.dart';
import '../../../helpers/constants/padding.constants.dart';
import '../../../helpers/di/di.dart';
import '../../../localization/localization.dart';
import '../../widgets/error_messages_container.widget.dart';
import '../../widgets/message_dialog.widget.dart';
import '../../widgets/text_shadow.widget.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  final auth = getIt<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          trailing: IconButton(
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.inverseSurface,
              shadows: [
                BoxShadow(
                  color: AppColors.DARK.withOpacity(0.3),
                  blurRadius: 0.4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextShadow(text: t.signUp),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.MEDIUM),
          child: Form(
            key: auth.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: auth.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: auth.passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: auth.confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value != auth.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Sign Up'),
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
    );
  }
}
