import 'dart:math';

import 'package:flutter/material.dart' show AnimationController;

import 'package:hang_the_pinata/backend/models/wordpack.dart';

class GameController {
  GameController({
    required this.wordPack,
    required this.sourceLanguage,
    required this.targetLanguage,
  }) {
    reset();
  }

  final WordPack wordPack;
  final String sourceLanguage;
  final String targetLanguage;

  final List<String> attemptedLetters = [];
  AnimationController? animationController;

  double _animationTarget = 0;
  late String _currentWord;
  late List<String> _letters;
  bool? _win;

  // Public methods
  bool attempt(String s) {
    attemptedLetters.add(s);
    if (_currentWord.contains(s)) {
      if (_currentWord
          .split('')
          .every((element) => attemptedLetters.contains(element))) {
        _win = true;
        _finish();
      }
      return true;
    } else {
      _next();
      if (animationController!.value * 11 > 5) {
        _win = false;
        _finish();
      }
      return false;
    }
  }

  void reset() {
    _animationTarget = 0;
    animationController?.reverse();
    _win = null;

    _currentWord = wordPack.words[Random().nextInt(wordPack.words.length)]
        .toJson()[targetLanguage]
        .toUpperCase();
    _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    _letters.shuffle();
    attemptedLetters.clear();
  }

  // Private methods
  void _next() {
    if (_win != null) return;
    _animationTarget += (1 / 11);
    animationController!.animateTo(_animationTarget);
  }

  void _finish() {
    if (animationController!.value * 11 < 5) {
      animationController!.value += 6 / 11;
    }
    _animationTarget = animationController!.value + 1 / 11;
    animationController!.animateTo(_animationTarget);
  }

  // Getters/Setters
  String get currentWord => _currentWord;
  List<String> get letters => _letters;
}
