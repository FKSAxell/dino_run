import 'package:dino_run/controllers/life_controller.dart';
import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:dino_run/widgets/game_over_menu.dart';
import 'package:dino_run/widgets/hud.dart';
import 'package:dino_run/widgets/pause_menu.dart';
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
    addWidgetOverlay('Hud', Hud(pauseGame: pauseGame));
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
    addWidgetOverlay(
      'GameOverMenu',
      GameOverMenu(
        score: score,
        onRestartPressed: reset,
      ),
    );
  }

  void pauseGame() {
    pauseEngine();
    addWidgetOverlay(
      'PauseMenu',
      PauseMenu(
        onResumePressed: () {
          removeWidgetOverlay('PauseMenu');
          resumeEngine();
        },
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
    removeWidgetOverlay('GameOverMenu');
    resumeEngine();
    _dino.run();
    _enemyManager.reset();
    components.whereType<Enemy>().forEach((enemy) {
      this.markToRemove(enemy);
    });
  }
}
