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
  });
  final String text;
  final RoundedLoadingButtonController? controller;
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      controller: controller ?? RoundedLoadingButtonController(),
      onPressed: onPressed,
      color: color,
      height: 45,
      elevation: 7,
      successColor: color,
      child: Text(text, style: TextStyles.h3.copyWith(color: Colors.white)),
    );
  }
}
