import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:hang_the_pinata/backend/data/wordpacks.dart';
import 'package:hang_the_pinata/backend/models/wordpack.dart';
import 'package:hang_the_pinata/backend/secrets.dart';

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
  static Future<List<WordPack>> getWordpacks() async {
    Response response = StaticData.wordpacks;
    Box box = Hive.box('wordpacks');
    try {
      // Response webResponse = await dio.get('wordpacks/');
      // List<Map> wr = webResponse.data['wordpacks'] as List<Map>;
      // print(webResponse.data['wordpacks'].runtimeType as List<Map>);
      // print(response.data['wordpacks'].runtimeType);
      // response.data['wordpacks'] += wr;
      // response.data['wordpacks'].addAll(wr);
      box.put('wordpacks', jsonEncode(response.data));
    } on DioException catch (_) {
      String? wordpacks = box.get('wordpacks');
      if (wordpacks != null) {
        response.data['wordpacks'].addAll(jsonDecode(wordpacks)['wordpacks']);
      }
    }

    return List<WordPack>.from(
      response.data['wordpacks'].map((wordpack) => WordPack.fromJson(wordpack)),
    );
  }
}
