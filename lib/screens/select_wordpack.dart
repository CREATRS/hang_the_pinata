import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:hang_the_pinata/backend/models/game_progress.dart';
import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/backend/services/api.dart';
import 'package:hang_the_pinata/backend/services/app_state.dart';
import 'package:hang_the_pinata/utils/constants.dart';
import 'package:hang_the_pinata/widgets/components/button.dart';
import 'package:hang_the_pinata/widgets/components/cached_or_asset_image.dart';
import 'package:hang_the_pinata/widgets/components/selectable_item.dart';

class SelectWordpack extends StatefulWidget {
  const SelectWordpack({super.key});

  @override
  State<SelectWordpack> createState() => _SelectWordpackState();
}

class _SelectWordpackState extends State<SelectWordpack> {
  AppStateService appState = Get.find<AppStateService>();
  RoundedLoadingButtonController controller = RoundedLoadingButtonController();
  WordPack? selectedWordpack;
  bool loaded = false;
  GameProgress? progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your wordpack'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: loaded
            ? null
            : Api.getWordPacks(
                appState.user.value.sourceLanguage!,
                appState.user.value.targetLanguage!,
              ),
        builder: (context, AsyncSnapshot<List<WordPack>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<WordPack> wordPacks = snapshot.data as List<WordPack>;
          loaded = true;
          return ListView.builder(
            itemCount: wordPacks.length,
            itemBuilder: (context, index) {
              WordPack wordPack = wordPacks[index];
              return SelectableItem(
                text: wordPack.name,
                subtitle: '${wordPack.words.length} words',
                color: AppColors.orange,
                leading: CachedOrAssetImage(wordPack.image),
                middle: Flexible(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    children: wordPack.languages
                        .map(
                          (e) => Image.asset('assets/flags/$e.png', width: 24),
                        )
                        .toList()
                        .reversed
                        .toList(),
                  ),
                ),
                trailing: Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index + 1 <= wordPack.rating
                          ? Icons.star_rounded
                          : index + .5 < wordPack.rating
                              ? Icons.star_half_rounded
                              : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ),
                onTap: () => setState(() => selectedWordpack = wordPack),
                selected: selectedWordpack?.id == wordPack.id,
              );
            },
          );
        },
      ),
      bottomNavigationBar: selectedWordpack != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Button(
                controller: controller,
                onPressed: () async {
                  controller.start();
                  controller.success();
                  await Future.delayed(const Duration(milliseconds: 300));

                  if (!mounted) return;
                  Navigator.pushNamed(
                    context,
                    Routes.game,
                    arguments: {
                      StorageKeys.wordPacks: selectedWordpack,
                      'progress': progress,
                    },
                  ).then((p) {
                    controller.reset();
                    if (p != null) {
                      progress = p as GameProgress;
                    }
                  });
                },
                text: 'Play',
              ),
            )
          : null,
      extendBody: true,
    );
  }
}
