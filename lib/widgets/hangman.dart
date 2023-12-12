import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

late AnimationController _controller;
double _target = 0;

class HangMan extends StatefulWidget {
  const HangMan({super.key});

  @override
  State<HangMan> createState() => _HangManState();

  void next() {
    _target += (1 / 11);
    _controller.animateTo(_target, duration: const Duration(seconds: 2));
  }

  void finish() {
    if (_controller.value * 11 < 5) _controller.value += 6 / 11;
    _target = _controller.value + 1 / 11;
    _controller.animateTo(_target, duration: const Duration(seconds: 2));
  }

  void reset() {
    _target = 0;
    _controller.value = 0;
  }
}

class _HangManState extends State<HangMan> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/hangman.json',
      alignment: Alignment.center,
      fit: BoxFit.contain,
      controller: _controller,
    );
  }
}
