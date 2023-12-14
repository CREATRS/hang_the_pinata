import 'package:flutter/material.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:hang_the_pinata/utils/constants.dart';

export 'package:rounded_loading_button/rounded_loading_button.dart'
    show RoundedLoadingButtonController;

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    this.controller,
    this.color = AppColors.orange,
    required this.onPressed,
    this.autoAnimate = false,
  });

  final String text;
  final RoundedLoadingButtonController? controller;
  final Color? color;
  final VoidCallback? onPressed;
  final bool autoAnimate;

  @override
  Widget build(BuildContext context) {
    RoundedLoadingButtonController controllerInt =
        controller ?? RoundedLoadingButtonController();
    return RoundedLoadingButton(
      controller: controllerInt,
      onPressed: autoAnimate
          ? () async {
              controllerInt.start();
              await Future.delayed(
                const Duration(milliseconds: 700),
                () => controllerInt.success(),
              );
              await Future.delayed(const Duration(milliseconds: 300));
              Future.delayed(const Duration(milliseconds: 300), () {
                controllerInt.reset();
              });
              onPressed?.call();
            }
          : onPressed,
      color: color,
      height: 45,
      animateOnTap: controller == null,
      elevation: 7,
      successColor: color,
      child: Text(text, style: TextStyles.h3.copyWith(color: Colors.white)),
    );
  }
}
