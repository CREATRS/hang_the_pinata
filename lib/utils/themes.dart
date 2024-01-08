import 'package:flutter/material.dart';

import 'package:hang_the_pinata/utils/constants.dart';

ButtonStyle _buttonStyle(Color color, double opacity) => ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(color),
      overlayColor: MaterialStateProperty.all<Color>(
        AppColors.orange.withOpacity(opacity),
      ),
    );

ThemeData darkTheme = ThemeData.dark().copyWith(
  shadowColor: Colors.white.withOpacity(.5),
  elevatedButtonTheme:
      ElevatedButtonThemeData(style: _buttonStyle(AppColors.orange, .1)),
  iconButtonTheme: IconButtonThemeData(style: _buttonStyle(Colors.white, .2)),
  textButtonTheme: TextButtonThemeData(style: _buttonStyle(Colors.white, .2)),
);

ThemeData lightTheme = ThemeData(
  elevatedButtonTheme:
      ElevatedButtonThemeData(style: _buttonStyle(AppColors.orange, .1)),
  iconButtonTheme: IconButtonThemeData(style: _buttonStyle(Colors.black, .1)),
  textButtonTheme: TextButtonThemeData(style: _buttonStyle(Colors.black, .1)),
);
