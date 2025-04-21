import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../localization/localization.dart';
import '../../models/app_user.model.dart';
import '../local_storage_keys.dart';

class AuthLocalService {
  final FlutterSecureStorage _storage;
  AuthLocalService(this._storage);

  late AppUser _user;
  AppUser get user => _user;

  Future<bool> saveUser(User? currentUser) async {
    if (currentUser != null) {
      final savedUser = await getLocalUser();

      if (savedUser == null) {
        final newUser = AppUser.fromFirebaseUser(currentUser);

        _storage.write(
          key: LocalStorageKeys.userKey,
          value: json.encode(newUser.toJson()),
        );

        _user = newUser;

        return true;
      }
    } else {
      throw t.pleaseLoginFirst;
    }
    return false;
  }

  Future<AppUser?> getLocalUser() async {
    final user = await _storage.read(
      key: LocalStorageKeys.userKey,
    );

    if (user == null) return null;

    return _user = AppUser.fromJson(json.decode(user));
  }
}
