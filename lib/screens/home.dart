import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:hang_the_pinata/utils/constants.dart';
import 'package:hang_the_pinata/widgets/components/button.dart';
import 'package:hang_the_pinata/widgets/components/logo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    RoundedLoadingButtonController controller =
        RoundedLoadingButtonController();
    return SafeArea(
      child: Column(
        children: [
          const Spacer(flex: 2),
          const Text('Hang The Piñata', style: TextStyles.h1),
          const AppIcon(radius: 36),
          const Spacer(),
          Button(
            text: "Let's play!",
            controller: controller,
            onPressed: () {
              controller.success();
              Get.toNamed(Routes.selectWordpack);
              controller.reset();
            },
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
