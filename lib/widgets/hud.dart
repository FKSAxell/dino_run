import 'package:dino_run/controllers/life_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Hud extends StatelessWidget {
  final Function pauseGame;
  const Hud({Key key, @required this.pauseGame}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final LifeController lifeCtrl = Get.find<LifeController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.pause,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: pauseGame,
        ),
        Obx(
          () {
            List<Widget> list = [];

            // This loop decides how many hearts are filled and how many are empty
            // depending upon the current dino life.
            for (int i = 0; i < 3; ++i) {
              list.add(
                Icon(
                  (i < lifeCtrl.counter.value)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: list,
              ),
            );
          },
        )
      ],
    );
  }
}
