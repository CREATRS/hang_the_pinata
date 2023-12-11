import 'package:dio/dio.dart';

class StaticData {
  static Response get wordpacks =>
      Response(requestOptions: RequestOptions(), data: _wordpacks);
}

Map<String, dynamic> _wordpacks = {
  'wordpacks': [
    {
      'id': 1,
      'name': 'Animals',
      'rating': 3.8,
      'image': 'assets/wordpacks/animals.png',
      'words': [
        {'en': 'lion', 'es': 'león', 'fr': 'lion', 'gr': 'Löwe'},
        {'en': 'elephant', 'es': 'elefante', 'fr': 'éléphant', 'gr': 'Elefant'},
        {'en': 'giraffe', 'es': 'jirafa', 'fr': 'girafe', 'gr': 'Giraffe'},
        {'en': 'zebra', 'es': 'cebra', 'fr': 'zèbre', 'gr': 'Zebra'},
        {'en': 'penguin', 'es': 'pingüino', 'fr': 'pingouin', 'gr': 'Pinguin'},
      ],
    },
    {
      'id': 2,
      'name': 'Colors',
      'rating': 3.4,
      'image': 'assets/wordpacks/colors.png',
      'words': [
        {'en': 'red', 'es': 'rojo', 'fr': 'rouge', 'gr': 'rot'},
        {'en': 'blue', 'es': 'azul', 'fr': 'bleu', 'gr': 'blau'},
        {'en': 'green', 'es': 'verde', 'fr': 'vert', 'gr': 'grün'},
        {'en': 'yellow', 'es': 'amarillo', 'fr': 'jaune', 'gr': 'gelb'},
        {'en': 'pink', 'es': 'rosa', 'fr': 'rose', 'gr': 'rosa'},
      ],
    },
    {
      'id': 3,
      'name': 'Fruits',
      'rating': 4.8,
      'image': 'assets/wordpacks/fruits.png',
      'words': [
        {'en': 'apple', 'es': 'manzana', 'fr': 'pomme', 'gr': 'Apfel'},
        {'en': 'banana', 'es': 'plátano', 'fr': 'banane', 'gr': 'Banane'},
        {'en': 'grape', 'es': 'uva', 'fr': 'raisin', 'gr': 'Traube'},
        {'en': 'strawberry', 'es': 'fresa', 'fr': 'fraise', 'gr': 'Erdbeere'},
        {'en': 'orange', 'es': 'naranja', 'fr': 'orange', 'gr': 'Orange'},
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
        {'en': 'Spain', 'es': 'España', 'fr': 'Espagne', 'gr': 'Spanien'},
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
