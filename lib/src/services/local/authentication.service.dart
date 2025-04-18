import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../helpers/di/di.dart';
import 'local_keys.dart';

class AuthenticationLocalService {
  Future<void> saveUser(User user) async => getIt.get<FlutterSecureStorage>().write(
        key: LocalKeys.userKey,
        value: user.toString(),
      );
}
