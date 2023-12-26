import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:hang_the_pinata/backend/models/language.dart';
import 'package:hang_the_pinata/backend/models/user.dart';
import 'package:hang_the_pinata/backend/services/app_state.dart';
import 'package:hang_the_pinata/backend/services/purchases.dart';
import 'package:hang_the_pinata/utils/constants.dart';
import 'package:hang_the_pinata/widgets/components/button.dart';
import 'package:hang_the_pinata/widgets/components/logo.dart';
import 'package:hang_the_pinata/widgets/modules/paywall.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RoundedLoadingButtonController controller = RoundedLoadingButtonController();
  bool isDark = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              const Icon(Icons.dark_mode_rounded),
              GetBuilder<AppStateService>(
                builder: (appState) {
                  return Switch(
                    // TODO: Review on device dark mode
                    value: isDark,
                    onChanged: (bool value) async {
                      await appState.setDarkMode(value);
                      setState(() => isDark = value);
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: GetBuilder<AppStateService>(
        builder: (appstate) {
          Rx<User> user = appstate.user;
          return Column(
            children: [
              const Spacer(flex: 2),
              const Text('Hang The Piñata', style: TextStyles.h1),
              const AppIcon(radius: 36),
              const Spacer(),
              if (user.value.hasLanguages)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/flags/${user.value.sourceLanguage}.png',
                        width: 48,
                      ),
                      IconButton(
                        icon: const Icon(Icons.compare_arrows_rounded),
                        onPressed: () async {
                          await Get.bottomSheet(const _SelectLanguages());
                          setState(() {});
                        },
                      ),
                      Image.asset(
                        'assets/flags/${user.value.targetLanguage}.png',
                        width: 48,
                      ),
                    ],
                  ),
                ),
              Button(
                text: "Let's play!",
                controller: controller,
                onPressed: () async {
                  controller.start();
                  if (!user.value.hasLanguages) {
                    await 300.milliseconds.delay(
                          () async =>
                              await Get.bottomSheet(const _SelectLanguages()),
                        );
                  }
                  if (!user.value.hasLanguages) {
                    controller.error();
                    300.milliseconds.delay(() => controller.reset());
                    return;
                  }
                  if (!user.value.isPremium) {
                    Offering? offerings = await PurchasesService.getOffering();
                    if (offerings == null) {
                      controller.error();
                      Get.snackbar(
                        'Error',
                        'There was an error connecting to the store. '
                            'Please try again later.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      3.seconds.delay(() => controller.reset());
                      return;
                    }
                    if (!mounted) return;
                    await Get.bottomSheet(
                      PayWall(offerings),
                      isScrollControlled: true,
                    );
                  }
                  if (!user.value.isPremium) {
                    controller.error();
                    1.seconds.delay(() => controller.reset());
                    return;
                  }
                  setState(() {});
                  controller.success();
                  await 1
                      .seconds
                      .delay(() => Get.toNamed(Routes.selectWordpack));
                  controller.reset();
                },
              ),
              const Spacer(flex: 2),
            ],
          );
        },
      ),
    );
  }
}

class _SelectLanguages extends StatefulWidget {
  const _SelectLanguages();

  @override
  State<_SelectLanguages> createState() => __SelectLanguagesState();
}

class __SelectLanguagesState extends State<_SelectLanguages> {
  String? sourceLanguage;
  String? targetLanguage;

  Widget languageButton(Language language, bool isSource) {
    bool isActive = isSource && sourceLanguage == language.code ||
        !isSource && targetLanguage == language.code;
    return GestureDetector(
      onTap: () {
        setState(() {
          isSource
              ? sourceLanguage = language.code
              : targetLanguage = language.code;
        });
      },
      child: AnimatedContainer(
        decoration: BoxDecoration(
          border: isActive ? Border.all(color: AppColors.orange) : null,
          borderRadius: BorderRadius.circular(32),
        ),
        width: isActive ? 64 : 48,
        duration: const Duration(milliseconds: 200),
        child:
            Image.asset('assets/flags/${language.code}.png', fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppStateService>(
      builder: (appState) {
        sourceLanguage ??= appState.user.value.sourceLanguage;
        targetLanguage ??= appState.user.value.targetLanguage;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: Text('Select your languages', style: TextStyles.h3),
              ),
              const SizedBox(height: 16),
              const Text('Native language'),
              const SizedBox(height: 8),
              SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: Languages.values
                      .map((language) => languageButton(language, true))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Target language'),
              const SizedBox(height: 8),
              SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: Languages.values
                      .map((language) => languageButton(language, false))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              GetBuilder<AppStateService>(
                builder: (appState) {
                  return Button(
                    onPressed: () async {
                      await appState.updateUser(
                        sourceLanguage: sourceLanguage,
                        targetLanguage: targetLanguage,
                      );
                      Get.back();
                    },
                    text: 'Save',
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
