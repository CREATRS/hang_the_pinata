import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/backend/services/api.dart';
import 'package:hang_the_pinata/utils/constants.dart';
import 'package:hang_the_pinata/widgets/components/logo.dart';
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
              leading: wordpack.image.contains('http')
                  ? CachedNetworkImage(
                      imageUrl: wordpack.image,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                      errorWidget: (context, url, error) =>
                          const AppIcon(radius: 18),
                    )
                  : Image.asset(wordpack.image, height: 36),
              alwaysShowTrailing: true,
            );
          },
        );
      },
    );
  }
}
