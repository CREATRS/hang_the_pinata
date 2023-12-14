import 'package:flutter/material.dart';

import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

import 'package:hang_the_pinata/backend/controllers/game_controller.dart';
import 'package:hang_the_pinata/backend/models/user.dart';
import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/backend/services/app_state.dart';
import 'package:hang_the_pinata/utils/constants.dart';
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
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Text(
              controller.currentWord
                  .split('')
                  .map((a) => controller.attempts.contains(a) ? a : '_')
                  .join(' '),
              style: TextStyles.h1,
              textAlign: TextAlign.center,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: controller.win != null ? 20 : 0,
            child: Text(
              controller.win != null ? controller.currentWordSource : '',
              style: TextStyles.h3,
            ),
          ),

          // Keyboard
          Flexible(
            flex: 3,
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

                                if (controller.win == null) return;

                                if (controller.win!) {
                                  confettiControllers
                                      .forEach((_, value) => value.play());
                                  if (controller.score > user.bestScore) {
                                    user = user.copyWith(
                                      bestScore: controller.score,
                                    );
                                    appState.updateUser(user);
                                    Get.snackbar(
                                      'New high score!',
                                      'You scored ${controller.score} points!',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    await 3.seconds.delay();
                                  }
                                } else {
                                  Get.snackbar(
                                    'Game over!',
                                    'You scored ${controller.score} points!',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
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

          // Score and next
          AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: controller.win != null && controller.win! ? 1 : 0,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Text(
                    'Score: ${controller.score}\nBest: ${user.bestScore}',
                    style: TextStyles.h3,
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.next_plan),
                    label: const Text('Next'),
                    onPressed: () =>
                        setState(() => controller.reset(clearScore: false)),
                  ),
                ],
              ),
            ),
          ),
          if (controller.win != null && !controller.win!)
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
