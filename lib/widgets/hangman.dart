import 'dart:math';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:hang_the_pinata/backend/controllers/game_controller.dart';

class HangMan extends StatefulWidget {
  const HangMan(this.controller, {super.key});

  final GameController controller;

  @override
  State<HangMan> createState() => _HangManState();
}

class _HangManState extends State<HangMan> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
      reverseDuration: const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Lottie.asset(
      'assets/animations/hangman.json',
      alignment: Alignment.center,
      fit: BoxFit.contain,
      height: min(size.width, size.height * 0.35),
      controller: widget.controller.animationController,
    );
  }
}
