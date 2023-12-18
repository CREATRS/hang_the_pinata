import 'dart:io';

import 'package:flutter/material.dart';

import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

import 'package:hang_the_pinata/backend/controllers/game_controller.dart';
import 'package:hang_the_pinata/backend/models/language.dart';
import 'package:hang_the_pinata/backend/models/user.dart';
import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/backend/services/app_state.dart';
import 'package:hang_the_pinata/utils/constants.dart';
import 'package:hang_the_pinata/widgets/components/cached_or_asset_image.dart';
import 'package:hang_the_pinata/widgets/components/shake_widget.dart';
import 'package:hang_the_pinata/widgets/hangman.dart';

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key, required this.wordPack, this.progress});
  final WordPack wordPack;
  final GameProgress? progress;

  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  late GameController controller;
  late User user;
  AppStateService appState = Get.find<AppStateService>();
  final Map<String, ConfettiController> confettiControllers = {};
  final ShakeWidgetController shakeController = ShakeWidgetController();
  String? showAccents;

  @override
  void initState() {
    super.initState();
    user = appState.user.value;
    controller = GameController(
      wordPack: widget.wordPack,
      sourceLanguage: user.sourceLanguage!,
      targetLanguage: Languages.get(user.targetLanguage!),
      preloadProgress: widget.progress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: controller.score == 0
              ? () => Navigator.pop(context)
              : () => Get.dialog(
                    AlertDialog(
                      title: const Text('Are you sure?'),
                      content: Text(
                        'You will lose your ${controller.score} points.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  ),
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
        ),
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
            flex: 7,
            child: ShakeWidget(
              key: Key(controller.wrongAttempts.toString()),
              controller: shakeController,
              enabled: controller.attempts.isNotEmpty,
              child: Column(
                children: [10, 9, 7].map((length) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      children: List.generate(
                        length,
                        (index) {
                          if (length == 9) {
                            index += 10;
                          } else if (length == 7) {
                            index += 19;
                          }
                          String character = controller.characters[index];
                          if (confettiControllers[character] == null) {
                            confettiControllers[character] =
                                ConfettiController(duration: duration);
                          }
                          ConfettiController confettiController =
                              confettiControllers[character]!;
                          List<String> specialCharacters = controller
                                  .targetLanguage
                                  .specialCharacters[character] ??
                              [];
                          return ConfettiWidget(
                            confettiController: confettiController,
                            numberOfParticles: 2,
                            maxBlastForce: 5,
                            minBlastForce: 2,
                            blastDirectionality: BlastDirectionality.explosive,
                            child: specialCharacters.isEmpty
                                ? _characterButton(
                                    character,
                                    confettiController: confettiController,
                                    enableLongPress:
                                        specialCharacters.isNotEmpty,
                                  )
                                : AnimatedContainer(
                                    duration: duration,
                                    width: MediaQuery.of(context).size.width /
                                        10 *
                                        (showAccents == character
                                            ? specialCharacters.length + 1
                                            : 1),
                                    height: 52,
                                    child: Stack(
                                      children: [
                                        ...specialCharacters.map((accent) {
                                          int index =
                                              specialCharacters.indexOf(accent);
                                          return AnimatedPositioned(
                                            left: showAccents == character
                                                ? (index + 1) * 40
                                                : 0,
                                            curve: Curves.easeInOut,
                                            duration: duration,
                                            child: _characterButton(
                                              accent,
                                              confettiController:
                                                  confettiController,
                                              elevation:
                                                  showAccents == character
                                                      ? 2
                                                      : 0,
                                            ),
                                          );
                                        }),
                                        _characterButton(
                                          character,
                                          specialCharacters: specialCharacters,
                                          confettiController:
                                              confettiController,
                                          enableLongPress:
                                              specialCharacters.isNotEmpty,
                                        ),
                                      ],
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Score and button
          AnimatedSlide(
            duration: const Duration(seconds: 1),
            offset: controller.win != null && controller.win!
                ? Offset.zero
                : const Offset(0, 2),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Text(
                    'Score: ${controller.score}\nBest: ${user.bestScore}',
                    style: TextStyles.h3,
                  ),
                  const Spacer(),
                  controller.isWordPackCompleted
                      ? ElevatedButton.icon(
                          icon: Transform.flip(
                            flipX: true,
                            child: const Icon(Icons.next_plan),
                          ),
                          label: const Text('Change wordpack'),
                          onPressed: () =>
                              Navigator.pop(context, controller.progress),
                        )
                      : ElevatedButton.icon(
                          icon: const Icon(Icons.next_plan),
                          label: const Text('Next'),
                          onPressed: controller.win != null
                              ? () async {
                                  await controller.reset(clearScore: false);
                                  setState(() {});
                                }
                              : null,
                        ),
                ],
              ),
            ),
          ),
          if (controller.win != null && !controller.win!)
            IconButton(
              onPressed: () async {
                await controller.reset();
                showAccents = null;
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
            ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _characterButton(
    String character, {
    List<String> specialCharacters = const [],
    bool enableLongPress = false,
    ConfettiController? confettiController,
    double elevation = 2,
  }) {
    bool isPressed = controller.attempts.contains(character);
    bool hasChildToPress = !specialCharacters.every(
      (element) => controller.attempts.contains(element),
    );
    return Container(
      width: MediaQuery.of(context).size.width / 10,
      height: 52,
      padding: const EdgeInsets.all(2),
      child: RawMaterialButton(
        onPressed: controller.isReady
            ? isPressed && hasChildToPress && showAccents != character
                ? () => setState(() => showAccents = character)
                : showAccents == character
                    ? () => setState(() => showAccents = null)
                    : isPressed
                        ? null
                        : () async {
                            setState(() {});
                            bool attempt = await controller.attempt(character);
                            setState(() {});
                            if (attempt) {
                              confettiController?.play();
                            } else {
                              shakeController.shake();
                            }
                            if (controller.characters.contains(character) &&
                                character != showAccents) {
                              showAccents = null;
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
                              if (controller.isWordPackCompleted) {
                                Get.snackbar(
                                  'Congratulations!',
                                  'You completed the word pack!',
                                  duration: 5.seconds,
                                );
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
        onLongPress: controller.isReady && enableLongPress && !isPressed
            ? () => setState(() => showAccents = character)
            : null,
        fillColor: isPressed ? Colors.grey.shade300 : Colors.grey.shade100,
        elevation: elevation,
        shape: const CircleBorder(),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Text(
              character,
              style: TextStyle(
                color: isPressed
                    ? controller.currentWord.contains(character)
                        ? Colors.green
                        : Colors.red
                    : null,
              ),
            ),
            if (specialCharacters.isNotEmpty)
              const Positioned(
                bottom: 0,
                right: 0,
                width: 5,
                height: 10,
                child: Icon(Icons.arrow_drop_down, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
