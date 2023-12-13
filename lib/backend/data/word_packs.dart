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
        {'es': 'león', 'fr': 'lion', 'gr': 'löwe'},
        {'en': 'elephant', 'es': 'elefante', 'fr': 'éléphant', 'gr': 'elefant'},
        {'en': 'giraffe', 'es': 'jirafa', 'fr': 'girafe', 'gr': 'giraffe'},
        {'en': 'zebra', 'es': 'cebra', 'fr': 'zèbre', 'gr': 'zebra'},
        {'en': 'penguin', 'es': 'pingüino', 'fr': 'pingouin', 'gr': 'pinguin'},
      ],
    },
    {
      'id': 2,
      'name': 'Colors',
      'rating': 3.4,
      'image': 'assets/wordpacks/colors.png',
      'words': [
        {'en': 'red', 'es': 'rojo', 'fr': 'rouge', 'gr': 'rot', 'it': 'rosso'},
        {'en': 'blue', 'es': 'azul', 'fr': 'bleu', 'gr': 'blau', 'it': 'blu'},
        {
          'en': 'green',
          'es': 'verde',
          'fr': 'vert',
          'gr': 'grün',
          'it': 'verde',
        },
        {
          'en': 'yellow',
          'es': 'amarillo',
          'fr': 'jaune',
          'gr': 'gelb',
          'it': 'giallo',
        },
        {'en': 'pink', 'es': 'rosa', 'fr': 'rose', 'gr': 'rosa', 'it': 'rosa'},
      ],
    },
    {
      'id': 3,
      'name': 'Fruits',
      'rating': 4.8,
      'image': 'assets/wordpacks/fruits.png',
      'words': [
        {'en': 'apple', 'es': 'manzana', 'fr': 'pomme', 'gr': 'apfel'},
        {'en': 'banana', 'fr': 'banane', 'gr': 'banane'},
        {'en': 'grape', 'es': 'uva', 'fr': 'raisin', 'gr': 'traube'},
        {'en': 'strawberry', 'es': 'fresa', 'fr': 'fraise', 'gr': 'erdbeere'},
        {'en': 'orange', 'es': 'naranja', 'fr': 'orange', 'gr': 'orange'},
      ],
    },
    {
      'id': 4,
      'name': 'Numbers',
      'rating': 4.0,
      'image': 'assets/wordpacks/numbers.png',
      'words': [
        {'en': 'one', 'es': 'uno', 'fr': 'un', 'gr': 'eins'},
        {'en': 'two', 'es': 'dos', 'fr': 'deux', 'gr': 'zwei'},
        {'en': 'three', 'es': 'tres', 'fr': 'trois', 'gr': 'drei'},
        {'en': 'four', 'es': 'cuatro', 'fr': 'quatre', 'gr': 'vier'},
        {'en': 'five', 'es': 'cinco', 'fr': 'cinq', 'gr': 'fünf'},
      ],
    },
    {
      'id': 5,
      'name': 'Countries',
      'rating': 3.2,
      'image': 'assets/wordpacks/countries.png',
      'words': [
        {'en': 'Italy', 'es': 'Italia', 'fr': 'Italie', 'gr': 'Italien'},
        {'en': 'France', 'es': 'Francia', 'fr': 'France', 'gr': 'Frankreich'},
        {
          'en': 'Germany',
          'es': 'Alemania',
          'fr': 'Allemagne',
          'gr': 'Deutschland',
        },
        {'en': 'Spain', 'es': 'España', 'fr': 'Espagne', 'gr': 'spanien'},
        {
          'en': 'England',
          'es': 'Inglaterra',
          'fr': 'Angleterre',
          'gr': 'England',
        }
      ],
    }
  ],
};
