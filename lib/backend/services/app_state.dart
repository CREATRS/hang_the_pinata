import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hang_the_pinata/backend/models/user.dart';
import 'package:hang_the_pinata/utils/constants.dart';

class AppStateService extends GetxController {
  // Init state
  Future<void> init() async {
    await _loadStorage();
    _loadUser();
    setDarkMode(box.get(StorageKeys.darkMode) ?? false);
  }

  // Values
  RxBool darkMode = false.obs;
  Rx<User> user = Rx<User>(const User());

  late Box box;

  // Methods
  Future<void> _loadStorage() async {
    await Hive.initFlutter();
    box = await Hive.openBox(StorageKeys.box);
    await setDarkMode(box.get(StorageKeys.darkMode));
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

  Future<void> setDarkMode(bool? value) async {
    if (value == null) return;

    darkMode.value = value;
    await box.put(StorageKeys.darkMode, value);
    update();
  }

  Future<void> updateUser({
    String? sourceLanguage,
    String? targetLanguage,
    int? bestScore,
    String? purchasesUserId,
    bool? isPremium,
  }) async {
    user.value = user.value.copyWith(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      bestScore: bestScore,
      purchasesUserId: purchasesUserId,
      isPremium: isPremium,
    );
    await box.put(StorageKeys.user, user.value.toJson());
  }
}
