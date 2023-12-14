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

  final List<String> attempts = [];
  AnimationController? animationController;

  double _animationTarget = 0;
  late String _currentWord;
  late List<String> _characters;
  int _score = 0;
  bool? _win;

  // Public methods
  bool attempt(String s) {
    attempts.add(s);
    if (_currentWord.contains(s)) {
      if (_currentWord
          .split('')
          .every((element) => attempts.contains(element))) {
        _win = true;
        _score++;
        _finish();
      }
      return true;
    } else {
      _next();
      if (animationController!.value * 11 >= 5) {
        _win = false;
        _finish();
      }
      return false;
    }
  }

  void reset({bool clearScore = true}) {
    if (animationController != null) _reverse();

    _win = null;
    if (clearScore) _score = 0;

    _currentWord = wordPack.words[Random().nextInt(wordPack.words.length)]
        .get(targetLanguage);
    _characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    attempts.clear();
  }

  // Private methods
  void _finish() {
    if (animationController!.value * 11 < 5) {
      animationController!.value += 6 / 11;
    }
    _animationTarget = animationController!.value + 1 / 11;
    animationController!.animateTo(_animationTarget);
  }

  void _next() {
    if (_win != null) return;
    _animationTarget += (1 / 11);
    animationController!.animateTo(_animationTarget);
  }

  void _reverse() async {
    if (animationController!.value * 11 < 6) {
      _animationTarget = 0;
      animationController!.reverse();
    } else {
      _animationTarget -= (1 / 11);
      await animationController!.animateBack(_animationTarget);
      _animationTarget = 0;
      animationController!.value = 0;
    }
  }

  // Getters/Setters
  String get currentWord => _currentWord;
  List<String> get characters => _characters;
  int get score => _score;
  bool? get win => _win;
  int get wrongAttempts =>
      attempts.where((c) => !_currentWord.contains(c)).length;
}
