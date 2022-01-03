import 'package:dino_run/game/dino_run.dart';
import 'package:dino_run/widgets/game_over_menu.dart';
import 'package:dino_run/widgets/hud.dart';
import 'package:dino_run/widgets/main_menu.dart';
import 'package:dino_run/widgets/pause_menu.dart';
import 'package:dino_run/widgets/settings_menu.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

/// This is the single instance of [DinoRun] which
/// will be reused throughout the lifecycle of the game.
DinoRun _dinoRun = DinoRun();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino Run',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Audiowide',
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: GameWidget(
          // This will dislpay a loading bar until [DinoRun] completes
          // its onLoad method.
          loadingBuilder: (conetxt) => const Center(
            child: SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
          ),
          // Register all the overlays that will be used by this game.
          overlayBuilderMap: {
            MainMenu.id: (_, DinoRun gameRef) => MainMenu(gameRef),
            PauseMenu.id: (_, DinoRun gameRef) => PauseMenu(gameRef),
            Hud.id: (_, DinoRun gameRef) => Hud(gameRef),
            GameOverMenu.id: (_, DinoRun gameRef) => GameOverMenu(gameRef),
            SettingsMenu.id: (_, DinoRun gameRef) => SettingsMenu(gameRef),
          },
          // By default MainMenu overlay will be active.
          initialActiveOverlays: const [MainMenu.id],
          game: _dinoRun,
        ),
      ),
    );
  }
}
