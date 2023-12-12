import 'package:flutter/material.dart';

import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/widgets/hangman.dart';

class HangmanGame extends StatelessWidget {
  const HangmanGame({super.key, required this.wordPack});
  final WordPack wordPack;

  @override
  Widget build(BuildContext context) {
    HangMan hangman = const HangMan();
    return Scaffold(
      appBar: AppBar(title: Text(wordPack.name)),
      body: Column(
        children: [
          hangman,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => hangman.next(),
                icon: const Icon(Icons.arrow_forward),
              ),
              IconButton(
                onPressed: () => hangman.finish(),
                icon: const Icon(Icons.check),
              ),
              IconButton(
                onPressed: () => hangman.reset(),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
