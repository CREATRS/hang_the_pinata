import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:hang_the_pinata/utils/constants.dart';
import 'package:hang_the_pinata/widgets/components/button.dart';
import 'package:hang_the_pinata/widgets/components/logo.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    RoundedLoadingButtonController controller =
        RoundedLoadingButtonController();
    return Scaffold(
      body: Column(
        children: [
          const Spacer(flex: 2),
          const Text('Hang The Piñata', style: TextStyles.h1),
          const AppIcon(radius: 36),
          const Spacer(),
          Button(
            text: "Let's play!",
            controller: controller,
            onPressed: () {
              Get.toNamed(Routes.selectWordpack);
            },
            autoAnimate: true,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
