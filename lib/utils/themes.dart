import 'package:flutter/material.dart';

import 'package:hang_the_pinata/utils/constants.dart';

ButtonStyle _buttonStyle(Color color, double opacity) => ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(color),
      overlayColor: MaterialStateProperty.all<Color>(
        AppColors.orange.withOpacity(opacity),
      ),
    );

ThemeData darkTheme = ThemeData.dark().copyWith(
  iconButtonTheme: IconButtonThemeData(style: _buttonStyle(Colors.white, .2)),
  textButtonTheme: TextButtonThemeData(style: _buttonStyle(Colors.white, .2)),
);

ThemeData lightTheme = ThemeData(
  iconButtonTheme: IconButtonThemeData(style: _buttonStyle(Colors.black, .1)),
  textButtonTheme: TextButtonThemeData(style: _buttonStyle(Colors.black, .1)),
);
