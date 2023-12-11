import 'package:flutter/material.dart';

import 'package:hang_the_pinata/widgets/hangman.dart';

class HangmanGame extends StatelessWidget {
  const HangmanGame({super.key});

  @override
  Widget build(BuildContext context) {
    HangMan hangman = const HangMan();
    return Center(
      child: Column(
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
