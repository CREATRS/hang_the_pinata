import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:hang_the_pinata/screens/select_wordpack.dart';
import 'backend/services/app_state.dart';
import 'screens/hangman_game.dart';
import 'screens/home.dart';
import 'utils/constants.dart';

void main() async {
  Get.isLogEnable = false;
  AppStateService appState = AppStateService();
  await appState.init();
  Get.put(appState);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Hang the Piñata',
      debugShowCheckedModeBanner: false,
      enableLog: false,
      onGenerateRoute: _router,
    );
  }
}

Route<dynamic> _router(RouteSettings settings) {
  late Widget screen;
  switch (settings.name) {
    case Routes.game:
      Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
      screen = HangmanGame(
        wordPack: args[StorageKeys.wordPacks],
        progress: args['progress'],
      );
      break;
    case Routes.home:
      screen = const Home();
      break;
    case Routes.selectWordpack:
      screen = const SelectWordpack();
      break;
    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  return MaterialPageRoute<dynamic>(builder: (_) => screen, settings: settings);
}
