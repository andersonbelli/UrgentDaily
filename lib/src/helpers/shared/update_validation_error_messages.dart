import 'package:flutter/foundation.dart';

import '../enums/error_fields/error_fields.dart';
import '../typedefs/error_messages.typedef.dart';

class ValidationHelper {
  static void updateValidationErrorMessages(
    ErrorMessagesMap<ErrorFields> errorMessages,
    ErrorFields field,
    bool addError,
    VoidCallback onUpdate,
  ) {
    bool updated = false;

    if (addError) {
      if (!errorMessages.containsKey(field)) {
        errorMessages[field] = field.message;
        updated = true;
      }
    } else {
      if (errorMessages.containsKey(field)) {
        errorMessages.remove(field);
        updated = true;
      }
    }

    if (updated) {
      onUpdate();
    }
  }
}
