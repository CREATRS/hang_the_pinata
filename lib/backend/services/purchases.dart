import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:hang_the_pinata/backend/secrets.dart';
import 'package:hang_the_pinata/backend/services/app_state.dart';
import 'package:hang_the_pinata/utils/constants.dart';

class PurchasesService {
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

    PurchasesConfiguration configuration;

    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..observerMode = false;

    await Purchases.configure(configuration);

    appState.updateUser(purchasesUserId: await Purchases.appUserID);

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementId];

      appState.updateUser(
        purchasesUserId: await Purchases.appUserID,
        isPremium: entitlement?.isActive,
      );
    });
  }

  static Future<Offering?> getOffering() async {
    Offerings offerings = await Purchases.getOfferings();
    Offering? current = offerings.current;
    return current;
  }

  static Future<Offerings> getOfferings() async =>
      await Purchases.getOfferings();
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

  static StoreConfig get instance {
    return _instance!;
  }

  static bool isForAppleStore() => instance.store == Store.appStore;

  static bool isForGooglePlay() => instance.store == Store.playStore;
}
