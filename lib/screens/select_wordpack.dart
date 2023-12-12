import 'package:flutter/material.dart';

import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/backend/services/api.dart';
import 'package:hang_the_pinata/utils/constants.dart';
import 'package:hang_the_pinata/widgets/components/cached_or_asset_image.dart';
import 'package:hang_the_pinata/widgets/components/selectable_item.dart';

class SelectWordpack extends StatelessWidget {
  const SelectWordpack({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api.getWordpacks(),
      builder: (context, AsyncSnapshot<List<WordPack>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<WordPack> wordpacks = snapshot.data as List<WordPack>;
        return ListView.builder(
          itemCount: wordpacks.length,
          itemBuilder: (context, index) {
            WordPack wordpack = wordpacks[index];
            return SelectableItem(
              text: wordpack.name,
              color: AppColors.orange,
                leading: CachedOrAssetImage(wordpack.image),
                alwaysShowTrailing: true,
            );
          },
        );
      },
    );
  }
}
