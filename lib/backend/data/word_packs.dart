import 'package:dio/dio.dart';

import 'package:hang_the_pinata/utils/constants.dart';

class StaticData {
  static Response<Map<String, dynamic>> get wordPacks =>
      Response(requestOptions: RequestOptions(), data: _wordPacks);
}

Map<String, dynamic> _wordPacks = {
  StorageKeys.wordPacks: [
    {
      'id': 1,
      'name': 'Animals',
      'rating': 3.8,
      'image': 'assets/wordpacks/animals.png',
      'words': [
        {'es': 'león', 'fr': 'lion', 'de': 'löwe'},
        {'en': 'elephant', 'es': 'elefante', 'fr': 'éléphant', 'de': 'elefant'},
        {'en': 'giraffe', 'es': 'jirafa', 'fr': 'girafe', 'de': 'giraffe'},
        {'en': 'zebra', 'es': 'cebra', 'fr': 'zèbre', 'de': 'zebra'},
        {'en': 'penguin', 'es': 'pingüino', 'fr': 'pingouin', 'de': 'pinguin'},
      ],
    },
    {
      'id': 2,
      'name': 'Colors',
      'rating': 3.4,
      'image': 'assets/wordpacks/colors.png',
      'words': [
        {'en': 'red', 'es': 'rojo', 'fr': 'rouge', 'de': 'rot', 'it': 'rosso'},
        {'en': 'blue', 'es': 'azul', 'fr': 'bleu', 'de': 'blau', 'it': 'blu'},
        {
          'en': 'green',
          'es': 'verde',
          'fr': 'vert',
          'de': 'grün',
          'it': 'verde',
        },
        {
          'en': 'yellow',
          'es': 'amarillo',
          'fr': 'jaune',
          'de': 'gelb',
          'it': 'giallo',
        },
        {'en': 'pink', 'es': 'rosa', 'fr': 'rose', 'de': 'rosa', 'it': 'rosa'},
      ],
    },
    {
      'id': 3,
      'name': 'Fruits',
      'rating': 4.8,
      'image': 'assets/wordpacks/fruits.png',
      'words': [
        {
          'en': 'apple',
          'es': 'manzana',
          'fr': 'pomme',
          'de': 'apfel',
          'it': 'mela',
        },
        {
          'en': 'pear',
          'es': 'pera',
          'fr': 'poire',
          'de': 'birne',
          'it': 'pera',
        },
        {'en': 'pineapple', 'es': 'piña', 'fr': 'ananas', 'de': 'ananas'},
        {
          'en': 'watermelon',
          'es': 'sandía',
          'fr': 'pastèque',
          'de': 'wassermelone',
        },
        {
          'en': 'grapefruit',
          'es': 'pomelo',
          'fr': 'pamplemousse',
          'de': 'pampelmuse',
        },
        {'en': 'lemon', 'es': 'limón', 'fr': 'citron', 'de': 'zitrone'},
        {'en': 'lime', 'es': 'lima', 'fr': 'citron vert', 'de': 'limette'},
        {'en': 'cherry', 'es': 'cereza', 'fr': 'cerise', 'de': 'kirsche'},
        {'en': 'banana', 'fr': 'banane', 'de': 'banane'},
        {'en': 'grape', 'es': 'uva', 'fr': 'raisin', 'de': 'traube'},
        {'en': 'strawberry', 'es': 'fresa', 'fr': 'fraise', 'de': 'erdbeere'},
        {'en': 'orange', 'es': 'naranja', 'fr': 'orange', 'de': 'orange'},
      ],
    },
    {
      'id': 4,
      'name': 'Numbers',
      'rating': 4.0,
      'image': 'assets/wordpacks/numbers.png',
      'words': [
        {'en': 'one', 'es': 'uno', 'fr': 'un', 'de': 'eins', 'it': 'uno'},
        {'en': 'two', 'es': 'dos', 'fr': 'deux', 'de': 'zwei', 'it': 'due'},
        {'en': 'three', 'es': 'tres', 'fr': 'trois', 'de': 'drei', 'it': 'tre'},
        {
          'en': 'four',
          'es': 'cuatro',
          'fr': 'quatre',
          'de': 'vier',
          'it': 'quattro',
        },
        {
          'en': 'five',
          'es': 'cinco',
          'fr': 'cinq',
          'de': 'fünf',
          'it': 'cinque',
        },
      ],
    },
    {
      'id': 5,
      'name': 'Countries',
      'rating': 3.2,
      'image': 'assets/wordpacks/countries.png',
      'words': [
        {'en': 'Italy', 'es': 'Italia', 'fr': 'Italie', 'de': 'Italien'},
        {'en': 'France', 'es': 'Francia', 'fr': 'France', 'de': 'Frankreich'},
        {
          'en': 'Germany',
          'es': 'Alemania',
          'fr': 'Allemagne',
          'de': 'Deutschland',
        },
        {'en': 'Spain', 'es': 'España', 'fr': 'Espagne', 'de': 'spanien'},
        {
          'en': 'England',
          'es': 'Inglaterra',
          'fr': 'Angleterre',
          'de': 'England',
        }
      ],
    }
  ],
};
