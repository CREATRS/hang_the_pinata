import 'package:flutter/material.dart';

// Backend
class Languages {
  static const String english = 'en';
  static const String spanish = 'es';
  static const String french = 'fr';
  static const String italian = 'it';
  static const String german = 'de';

  static const List<String> values = [
    english,
    spanish,
    french,
    italian,
    german,
  ];
}

class Routes {
  static const String game = '/game';
  static const String home = '/';
  static const String selectWordpack = '/select_wordpack';
  // static const String result = '/result';
}

class StorageKeys {
  static const String box = 'hang_the_pinata';
  static const String user = 'user';
  static const String wordPacks = 'word_packs';
}

// Style
class AppColors {
  static const Color orange = Color(0xFFD96818);
}

class TextStyles {
  static const h1 = TextStyle(fontSize: 36, fontWeight: FontWeight.bold);
  static const h3 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
}
