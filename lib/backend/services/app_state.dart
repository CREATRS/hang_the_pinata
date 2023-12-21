import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hang_the_pinata/backend/models/user.dart';
import 'package:hang_the_pinata/utils/constants.dart';
import 'package:hang_the_pinata/utils/themes.dart';

class AppStateService extends GetxController {
  // Init state
  Future<void> init() async {
    await _loadStorage();
    _loadUser();
    setDarkMode(box.get(StorageKeys.darkMode) ?? false);
  }

  // Values
  Rx<User> user = Rx<User>(const User());

  late Box box;

  // Methods
  Future<void> _loadStorage() async {
    await Hive.initFlutter();
    box = await Hive.openBox(StorageKeys.box);
  }

  void _loadUser() {
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

  Future<void> setDarkMode(bool value) async {
    Get.changeTheme(value ? darkTheme : lightTheme);
    await box.put(StorageKeys.darkMode, value);
  }

  Future<void> updateUser({
    String? sourceLanguage,
    String? targetLanguage,
    int? bestScore,
  }) async {
    user.value = user.value.copyWith(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      bestScore: bestScore,
    );
    await box.put(StorageKeys.user, user.value.toJson());
  }
}
