import 'package:flutter/material.dart';

import 'package:hang_the_pinata/utils/constants.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      overlayColor:
          MaterialStateProperty.all<Color>(AppColors.orange.withOpacity(0.2)),
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      overlayColor:
          MaterialStateProperty.all<Color>(AppColors.orange.withOpacity(0.1)),
    ),
  ),
);
