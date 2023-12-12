import 'package:flutter/material.dart';

import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/backend/services/api.dart';
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
  WordPack? selectedWordpack;
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your wordpack'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: loaded ? null : Api.getWordPacks(),
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
                alwaysShowTrailing: true,
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
                onPressed: () => Navigator.pushNamed(
                  context,
                  Routes.game,
                  arguments: selectedWordpack,
                ),
                text: 'Play',
                autoAnimate: true,
              ),
            )
          : null,
      extendBody: true,
    );
  }
}
