import 'package:flutter/material.dart';

import '../../controllers/base_controller.dart';
import 'snackbar.widget.dart';

baseControllerUI(BuildContext context, BaseController controller) => WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.message != null) {
        showSnackBar(
          context,
          SnackBar(
            content: Text(controller.message!),
          ),
        );
      }
    });
