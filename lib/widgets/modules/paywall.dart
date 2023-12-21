import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:hang_the_pinata/backend/services/app_state.dart';
import 'package:hang_the_pinata/utils/constants.dart';
import 'package:hang_the_pinata/widgets/components/button.dart';

class PayWall extends StatefulWidget {
  const PayWall(this.offering, {super.key});
  final Offering offering;

  @override
  State<PayWall> createState() => _PayWallState();
}

class _PayWallState extends State<PayWall> {
  @override
  Widget build(BuildContext context) {
    Package package = widget.offering.availablePackages.first;

    String getButtonText() {
      IntroductoryPrice? introductoryPrice =
          package.storeProduct.introductoryPrice;
      if (introductoryPrice == null) {
        return 'Purchase for ${package.storeProduct.priceString}';
      }
      double promoPrice = introductoryPrice.price;
      String period = introductoryPrice.periodUnit.name;
      int periodUnit = introductoryPrice.periodNumberOfUnits;

      String text = ' Redeem your ';
      if (periodUnit > 1) {
        text += '$periodUnit ${period.toLowerCase()} trial for ';
      }
      if (promoPrice == 0) {
        text += 'free ${period.toLowerCase()}';
      } else {
        text += '\$$promoPrice ';
      }
      return text;
    }

    String getThenText() {
      if (package.storeProduct.introductoryPrice == null) {
        return '';
      }
      return '\nThen just ${package.storeProduct.priceString}'
          ' ${package.packageType.name}\n';
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      height: MediaQuery.of(context).size.height * .9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * .4,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .5,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 72, 16, 23),
                children: [
                  Text(
                    widget.offering.metadata['title']?.toString() ??
                        'Improve your learning!',
                    style: TextStyles.h1,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.offering.serverDescription,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    getThenText(),
                    textAlign: TextAlign.center,
                  ),
                  GetBuilder<AppStateService>(
                    builder: (appState) {
                      return Button(
                        text: getButtonText(),
                        onPressed: () async {
                          try {
                            CustomerInfo customerInfo =
                                await Purchases.purchasePackage(package);
                            EntitlementInfo? entitlement =
                                customerInfo.entitlements.all[entitlementId];
                            appState.updateUser(
                              purchasesUserId: await Purchases.appUserID,
                              isPremium: entitlement?.isActive,
                            );
                          } on PlatformException catch (e) {
                            log('Error purchasing: $e');
                          }
                          if (mounted) Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  TextButton(
                    child: const Text('Restore purchases'),
                    onPressed: () {/* TODO */},
                  ),
                ],
              ),
            ),
          ),
          ClipPath(
            clipper: _ImageClipper(),
            child: Image.asset(
              'assets/images/horse.png',
              height: MediaQuery.of(context).size.height * .5,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * .8);
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height * 1.1,
      size.width,
      size.height * 0.9,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
