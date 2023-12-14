import 'package:flutter/material.dart';

import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

import 'package:hang_the_pinata/backend/controllers/game_controller.dart';
import 'package:hang_the_pinata/backend/models/user.dart';
import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/backend/services/app_state.dart';
import 'package:hang_the_pinata/widgets/components/cached_or_asset_image.dart';
import 'package:hang_the_pinata/widgets/components/shake_widget.dart';
import 'package:hang_the_pinata/widgets/hangman.dart';

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key, required this.wordPack});
  final WordPack wordPack;

  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  late GameController controller;
  late User user;
  AppStateService appState = Get.find<AppStateService>();
  final Map<String, ConfettiController> confettiControllers = {};
  final ShakeWidgetController shakeController = ShakeWidgetController();

  @override
  void initState() {
    super.initState();
    user = appState.user.value;
    controller = GameController(
      wordPack: widget.wordPack,
      sourceLanguage: user.sourceLanguage!,
      targetLanguage: user.targetLanguage!,
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
            const SizedBox(width: 8),
            Image.asset('assets/flags/${user.targetLanguage}.png', width: 24),
          ],
        ),
      ),
      body: Column(
        children: [
          // Animation
          HangMan(controller),

          // Word
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              controller.currentWord
                  .split('')
                  .map((a) => controller.attempts.contains(a) ? a : '_')
                  .join(' '),
              style: const TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),

          // Keyboard
          Flexible(
            child: ShakeWidget(
              key: Key(controller.wrongAttempts.toString()),
              controller: shakeController,
              enabled: controller.attempts.isNotEmpty,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 45,
                ),
                itemCount: controller.characters.length,
                itemBuilder: (context, index) {
                  String character = controller.characters[index];
                  bool isPressed = controller.attempts.contains(character);
                  if (confettiControllers[character] == null) {
                    confettiControllers[character] = ConfettiController(
                      duration: const Duration(milliseconds: 500),
                    );
                  }
                  ConfettiController confettiController =
                      confettiControllers[character]!;
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: ConfettiWidget(
                      confettiController: confettiController,
                      numberOfParticles: 2,
                      maxBlastForce: 5,
                      minBlastForce: 2,
                      blastDirectionality: BlastDirectionality.explosive,
                      child: RawMaterialButton(
                        onPressed: controller.win == null && !isPressed
                            ? () async {
                                setState(() {});
                                bool attempt = controller.attempt(character);
                                  if (attempt) {
                                    confettiController.play();
                                  } else {
                                    shakeController.shake();
                                  }
                                  if (controller.win != null &&
                                      controller.win! &&
                                      user.bestScore < controller.score) {
                                    user = user.copyWith(
                                      bestScore: user.bestScore + 1,
                                    );
                                    appState.updateUser(user);
                                }
                              }
                            : null,
                        fillColor: isPressed
                            ? Colors.grey.shade300
                            : Colors.grey.shade100,
                        shape: const CircleBorder(),
                        child: Text(
                          character,
                          style: TextStyle(
                            color: isPressed
                                ? controller.currentWord.contains(character)
                                    ? Colors.green
                                    : Colors.red
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => controller.reset()),
            icon: const Icon(Icons.refresh),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
