// ignore_for_file: constant_identifier_names

import '../../localization/localization.dart';
import 'error_fields/error_fields.dart';

enum TaskErrorType implements ErrorFields {
  TITLE_CANT_BE_EMPTY,
  TASK_NOT_FOUND,
  FAILED_TO_CREATE,
  FAILED_TO_UPDATE,
  FAILED_TO_DELETE,
  INTERNAL_SERVER_ERROR;

  @override
  String get message {
    switch (this) {
      case TITLE_CANT_BE_EMPTY:
        return t.titleCantBeEmpty;
      case TASK_NOT_FOUND:
        return t.taskNotFound;
      case FAILED_TO_CREATE:
        return t.failedToCreateTask;
      case FAILED_TO_UPDATE:
        return t.failedToUpdateTask;
      case FAILED_TO_DELETE:
        return t.failedToDeleteTask;
      case INTERNAL_SERVER_ERROR:
        return t.internalServerError;
    }
  }
}
