import 'dart:math';

import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/widgets/hangman.dart';

class GameController {
  final WordPack wordPack;
  final String source;
  final String target;
  final HangMan game;

  late List<String> letters;

  late String currentWord;
  final List<String> attemptedLetters = [];

  GameController({
    required this.wordPack,
    required this.source,
    required this.target,
    required this.game,
  }) {
    currentWord = wordPack.words[Random().nextInt(wordPack.words.length)]
        .toJson()[target]
        .toUpperCase();
    letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    letters.shuffle();
  }

  bool attempt(String s) {
    attemptedLetters.add(s);
    if (currentWord.contains(s)) {
      return true;
    } else {
      game.next();
      return false;
    }
  }
}
