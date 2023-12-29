import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:hang_the_pinata/backend/secrets.dart';
import 'package:hang_the_pinata/backend/services/app_state.dart';
import 'package:hang_the_pinata/utils/constants.dart';

enum PremiumStatus {
  active,
  oneWeekOffline,
  none,
  subscriptionEnded,
}

class PurchasesService {
  static Future<PremiumStatus> checkPremiumStatus({
    CustomerInfo? customerInfo,
  }) async {
    AppStateService appState = Get.find<AppStateService>();
    customerInfo ??= await Purchases.getCustomerInfo();
    PremiumStatus? status;

    String? expirationDate =
        customerInfo.entitlements.all[entitlementId]?.expirationDate;
    DateTime now = DateTime.now().toUtc();
    DateTime requestDate = DateTime.parse(customerInfo.requestDate);
    if (expirationDate != null &&
        requestDate.add(const Duration(hours: 1)).isBefore(now)) {
      if (DateTime.parse(expirationDate).isBefore(now)) {
        status = PremiumStatus.subscriptionEnded;
      }
    }
    if (status == null &&
        requestDate.add(const Duration(days: 7)).isBefore(now)) {
      status = PremiumStatus.oneWeekOffline;
    }

    EntitlementInfo? entitlement = customerInfo.entitlements.all[entitlementId];
    status ??= (entitlement?.isActive ?? false)
        ? PremiumStatus.active
        : PremiumStatus.none;

    appState.updateUser(
      purchasesUserId: await Purchases.appUserID,
      isPremium: status == PremiumStatus.active,
    );
    return status;
  }

  static Future<bool> checkTrialElegibility() async {
    Map<String, IntroEligibility> res =
        await Purchases.checkTrialOrIntroductoryPriceEligibility(
      [entitlementId, 'htp_199_1y'],
    );
    for (IntroEligibility eligibility in res.values) {
      log('Eligibility: ${eligibility.status}, ${eligibility.description}');
      if (eligibility.status ==
          IntroEligibilityStatus.introEligibilityStatusEligible) {
        return true;
      }
    }
    return false;
  }

  static Future init(AppStateService appState) async {
    await Purchases.setLogLevel(LogLevel.debug);

    if (Platform.isIOS || Platform.isMacOS) {
      StoreConfig(
        store: Store.appStore,
        apiKey: revenueCatAppleKey,
      );
    } else if (Platform.isAndroid) {
      StoreConfig(
        store: Store.playStore,
        apiKey: revenueCatGoogleKey,
      );
    }

    await Purchases.configure(
      PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..observerMode = false,
    );

    appState.updateUser(purchasesUserId: await Purchases.appUserID);

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementId];

      appState.updateUser(
        purchasesUserId: await Purchases.appUserID,
        isPremium: entitlement?.isActive ?? false,
      );
    });
  }

  static Future<Offering?> getOffering() async =>
      (await Purchases.getOfferings()).current;

  static Future<bool> setupEmail() async {
    if (await Purchases.isAnonymous && (Platform.isIOS || Platform.isMacOS)) {
      try {
        AuthorizationCredentialAppleID credential =
            await SignInWithApple.getAppleIDCredential(
          scopes: AppleIDAuthorizationScopes.values,
        );

        if (credential.userIdentifier != null) {
          await Purchases.logIn(credential.userIdentifier!);
        }
        if (credential.email != null) {
          Map<String, String> fields = {'\$email': credential.email!};
          String? displayName = credential.givenName;
          if (displayName != null) {
            fields['\$displayName'] = displayName;
          }
          await Purchases.setAttributes(fields);
        }
        return true;
      } on SignInWithAppleAuthorizationException catch (_) {
        return false;
      }
    }
    return true;
  }
}

class StoreConfig {
  factory StoreConfig({required Store store, required String apiKey}) {
    _instance ??= StoreConfig._internal(store, apiKey);
    return _instance!;
  }

  StoreConfig._internal(this.store, this.apiKey);

  final Store store;
  final String apiKey;
  static StoreConfig? _instance;

  static StoreConfig get instance => _instance!;

  static bool isForAppleStore() => instance.store == Store.appStore;

  static bool isForGooglePlay() => instance.store == Store.playStore;
}
