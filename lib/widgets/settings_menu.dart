import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/game/dino_run.dart';
import '/models/settings.dart';
import '/widgets/main_menu.dart';
import '/game/audio_manager.dart';

// This represents the settings menu overlay.
class SettingsMenu extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'SettingsMenu';

  // Reference to parent game.
  final DinoRun gameRef;

  const SettingsMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Settings settings = Get.find<Settings>();
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black.withAlpha(100),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => SwitchListTile(
                        title: const Text(
                          'Music',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        value: settings.bgm,
                        onChanged: (bool value) {
                          settings.bgm = value;
                          if (value) {
                            AudioManager.instance
                                .startBgm('8Bit Platformer Loop.wav');
                          } else {
                            AudioManager.instance.stopBgm();
                          }
                        },
                      )),
                  Obx(() => SwitchListTile(
                        title: const Text(
                          'Effects',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        value: settings.sfx,
                        onChanged: (bool value) {
                          settings.sfx = value;
                        },
                      )),
                  TextButton(
                    onPressed: () {
                      gameRef.overlays.remove(SettingsMenu.id);
                      gameRef.overlays.add(MainMenu.id);
                    },
                    child: const Icon(Icons.arrow_back_ios_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
