import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:hang_the_pinata/backend/data/word_packs.dart';
import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/backend/secrets.dart';
import 'package:hang_the_pinata/utils/constants.dart';

Dio dio = Dio(
  BaseOptions(
    baseUrl: host,
    validateStatus: (status) => status! < 500,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    },
  ),
);

class Api {
  static Future<List<WordPack>> getWordPacks(String lang, String lang2) async {
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      StaticData.wordPacks.data![StorageKeys.wordPacks],
    );
    Box box = Hive.box(StorageKeys.box);

    if (await _hasInternet()) {
      Response webResponse = await dio.get(
        '',
        options: Options(
          receiveTimeout: const Duration(seconds: 3),
          sendTimeout: const Duration(seconds: 4),
        ),
      );
      List<Map<String, dynamic>> wr = List<Map<String, dynamic>>.from(
        webResponse.data[StorageKeys.wordPacks],
      );
      data += wr;
      box.put(StorageKeys.wordPacks, jsonEncode(wr));
    } else {
      String? wordpacks = box.get(StorageKeys.wordPacks);
      if (wordpacks != null) {
        data += List<Map<String, dynamic>>.from(jsonDecode(wordpacks));
      }
    }

    return List<WordPack>.from(
      data.map((wordpack) => WordPack.fromJson(wordpack)).where(
            (wordpack) =>
                wordpack.languages.contains(lang) &&
                wordpack.languages.contains(lang2),
          ),
    );
  }
}

Future<bool> _hasInternet() async {
  try {
    List result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}
