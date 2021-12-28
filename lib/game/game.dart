import 'package:dino_run/controllers/life_controller.dart';
import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:flame/components/parallax_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DinoGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  Dino _dino;
  ParallaxComponent _parallaxComponent;
  TextComponent _scoreText;
  int score;
  EnemyManager _enemyManager;
  final LifeController lifeCtrl = Get.put(LifeController());

  DinoGame() {
    _parallaxComponent = ParallaxComponent(
      [
        ParallaxImage("parallax/plx-1.png"),
        ParallaxImage("parallax/plx-2.png"),
        ParallaxImage("parallax/plx-3.png"),
        ParallaxImage("parallax/plx-4.png"),
        ParallaxImage("parallax/plx-5.png"),
        ParallaxImage("parallax/plx-6.png", fill: LayerFill.none),
      ],
      baseSpeed: Offset(100, 0),
      layerDelta: Offset(20, 0),
    );
    add(_parallaxComponent);

    _dino = Dino();
    add(_dino);

    _enemyManager = EnemyManager();
    add(_enemyManager);

    // var enemy = Enemy(EnemyType.AngryPig);
    // add(enemy);

    score = 0;
    _scoreText = TextComponent(
      score.toString(),
      config: TextConfig(
        fontFamily: 'Audiowide',
        color: Colors.white,
      ),
    );
    add(_scoreText);
    addWidgetOverlay('Hud', _buildHud());
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _scoreText.setByPosition(Position((size.width / 2) - _scoreText.width, 0));
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);

    _dino.jump();
  }

  @override
  void onTapUp(TapUpDetails details) {
    // TODO: implement onTapUp
    super.onTapUp(details);
    // if(_dino.speedY<){

    // }
    _dino.speedY += 120;
  }

  @override
  void update(double t) {
    super.update(t);
    score += (60 * t).toInt();
    _scoreText.text = score.toString();

    components.whereType<Enemy>().forEach((enemy) {
      if (_dino.distance(enemy) < 30) {
        _dino.hit();
      }
    });

    if (lifeCtrl.counter.value <= 0) {
      gameOver();
    }
  }

  void gameOver() {
    pauseEngine();
    addWidgetOverlay('GameOverMenu', _getGameOverMenu());
  }

  Widget _buildHud() {
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

  void pauseGame() {
    pauseEngine();
    addWidgetOverlay('PauseMenu', _buildPauseMenu());
  }

  Widget _buildPauseMenu() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 100.0,
            vertical: 50.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Paused',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  removeWidgetOverlay('PauseMenu');
                  resumeEngine();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getGameOverMenu() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 80.0,
            vertical: 30.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
              Text(
                'Score: $score',
                style: const TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(
                  Icons.restart_alt,
                  color: Colors.white,
                  size: 20.0,
                ),
                onPressed: () {
                  reset();
                  removeWidgetOverlay('GameOverMenu');
                  resumeEngine();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        pauseGame();
        break;
      case AppLifecycleState.paused:
        pauseGame();
        break;
      case AppLifecycleState.detached:
        pauseGame();
        break;
    }
  }

  void reset() {
    score = 0;
    lifeCtrl.reset();
    _dino.run();
    _enemyManager.reset();
    components.whereType<Enemy>().forEach((enemy) {
      this.markToRemove(enemy);
    });
  }
}
