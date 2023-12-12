import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hang_the_pinata/backend/models/user.dart';
import 'package:hang_the_pinata/utils/constants.dart';

class AppStateService extends GetxController {
  // Init state
  AppStateService() {
    _loadStorage().then((_) => _loadUser());
  }

  // Values
  Rxn<User> user = Rxn<User>();

  // Methods
  Future<void> _loadStorage() async {
    await Hive.initFlutter();
    await Hive.openBox(StorageKeys.box);
  }

  void _loadUser() async {
    Box box = Hive.box(StorageKeys.box);
    Map<String, dynamic>? userData = box.get(StorageKeys.user);
    if (userData != null) {
      try {
        user.value = User.fromJson(userData);
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        log('Error loading user: $e');
        // await GetStorage().remove('user');
        box.delete(StorageKeys.user);
        user.value = null;
      }
    }
  }
}
