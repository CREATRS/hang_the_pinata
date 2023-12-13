import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:hang_the_pinata/backend/controllers/game_controller.dart';
import 'package:hang_the_pinata/backend/models/user.dart';
import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/backend/services/app_state.dart';
import 'package:hang_the_pinata/widgets/components/cached_or_asset_image.dart';
import 'package:hang_the_pinata/widgets/hangman.dart';

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key, required this.wordPack});
  final WordPack wordPack;

  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  late GameController controller;
  late HangMan hangman;

  @override
  void initState() {
    super.initState();
    User user = Get.find<AppStateService>().user.value;
    hangman = const HangMan();
    controller = GameController(
      wordPack: widget.wordPack,
      source: user.sourceLanguage!,
      target: user.targetLanguage!,
      game: hangman,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedOrAssetImage(widget.wordPack.image),
            const SizedBox(width: 8),
            Flexible(
              child: Text(widget.wordPack.name, overflow: TextOverflow.fade),
            ),
            const SizedBox(width: 42),
          ],
        ),
      ),
      body: Column(
        children: [
          // Animation
          hangman,

          // Word
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              controller.currentWord
                  .split('')
                  .map((e) => controller.attemptedLetters.contains(e) ? e : '_')
                  .join(' '),
              style: const TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),

          // Keyboard
          Flexible(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 45,
              ),
              itemCount: controller.letters.length,
              itemBuilder: (context, index) {
                String letter = controller.letters[index];
                bool isPressed = controller.attemptedLetters.contains(letter);
                bool isCorrect =
                    isPressed && controller.currentWord.contains(letter);
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: RawMaterialButton(
                    onPressed: () => setState(() => controller.attempt(letter)),
                    fillColor:
                        isPressed ? Colors.grey.shade300 : Colors.grey.shade100,
                    elevation: isPressed ? 0 : 5,
                    shape: const CircleBorder(),
                    child: Text(
                      letter,
                      style: TextStyle(
                        color: isPressed
                            ? isCorrect
                                ? Colors.green
                                : Colors.red
                            : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
