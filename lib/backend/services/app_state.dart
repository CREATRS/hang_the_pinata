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
  Rx<User> user = Rx<User>(const User());

  late Box box;

  // Methods
  Future<void> _loadStorage() async {
    await Hive.initFlutter();
    box = await Hive.openBox(StorageKeys.box);
  }

  void _loadUser() async {
    Map? userData = box.get(StorageKeys.user);
    if (userData != null) {
      try {
        user.value = User.fromJson(Map<String, dynamic>.from(userData));
        update();
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        log('Error loading user: $e');
        box.delete(StorageKeys.user);
        user.value = const User();
      }
    }
  }

  void updateUser(User newUser) {
    user.value = newUser;
    box.put(StorageKeys.user, newUser.toJson());
  }
}
