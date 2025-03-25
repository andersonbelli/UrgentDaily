// ignore_for_file: constant_identifier_names

import '../../../localization/localization.dart';
import 'error_fields.dart';

enum TaskErrorFieldsEnum implements ErrorFields {
  TITLE,
  DAYS_OF_WEEK;

  @override
  String get message {
    switch (this) {
      case TITLE:
        return t.title;
      case DAYS_OF_WEEK:
        return t.recursiveTaskSelectOneDay;
    }
  }
}
