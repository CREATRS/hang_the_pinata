import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hang_the_pinata/screens/select_wordpack.dart';
import 'screens/hangman_game.dart';
import 'screens/home.dart';
import 'utils/constants.dart';
import 'utils/themes.dart';

// import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // String dbPath = await getDbPath();
  // Hive.init(dbPath);
  await Hive.openBox('wordpacks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Hang the Piñata',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _router,
    );
  }
}

Route<dynamic> _router(RouteSettings settings) {
  late Widget screen;
  switch (settings.name) {
    case Routes.game:
      screen = const HangmanGame();
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
  return MaterialPageRoute<dynamic>(
    builder: (_) => Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
            value: Get.isDarkMode,
            onChanged: (bool value) =>
                Get.changeTheme(Get.isDarkMode ? lightTheme : darkTheme),
          ),
        ],
      ),
      body: screen,
    ),
    settings: settings,
  );
}
