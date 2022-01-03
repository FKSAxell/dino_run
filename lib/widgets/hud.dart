import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/game/dino_run.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';
import '/widgets/pause_menu.dart';

// This represents the head up display in game.
// It consists of, current score, high score,
// a pause button and number of remaining lives.
class Hud extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'Hud';

  // Reference to parent game.
  final DinoRun gameRef;

  const Hud(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerData playerData = Get.find<PlayerData>();
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Obx(() => Text(
                    'Score: ${playerData.currentScore}',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  )),
              Obx(() => Text(
                    'Score: ${playerData.highScore}',
                    style: const TextStyle(color: Colors.white),
                  )),
            ],
          ),
          TextButton(
            onPressed: () {
              gameRef.overlays.remove(Hud.id);
              gameRef.overlays.add(PauseMenu.id);
              gameRef.pauseEngine();
              AudioManager.instance.pauseBgm();
            },
            child: const Icon(Icons.pause, color: Colors.white),
          ),
          Obx(
            () => Row(
              children: List.generate(3, (index) {
                if (index < playerData.lives) {
                  return const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  );
                } else {
                  return const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
