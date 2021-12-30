import 'package:dino_run/controllers/life_controller.dart';
import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/models/settings.dart';
import 'package:dino_run/widgets/game_over_menu.dart';
import 'package:dino_run/widgets/pause_menu.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DinoRun extends FlameGame with TapDetector, HasCollidables {
  // List of all the image assets.
  static const _imageAssets = [
    'DinoSprites - tard.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'Rino/Run (52x34).png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-5.png',
    'parallax/plx-6.png',
  ];

  // List of all the audio assets.
  static const _audioAssets = [
    '8Bit Platformer Loop.wav',
    'hurt7.wav',
    'jump14.wav',
  ];

  late Dino _dino;
  late Settings settings;
  late PlayerData playerData;
  late EnemyManager _enemyManager;

  @override
  Future<void>? onLoad() async {
    /// Read [PlayerData] and [Settings] from hive.
    playerData = Get.put(PlayerData());
    settings = Get.put(Settings());

    /// Initilize [AudioManager].
    await AudioManager.instance.init(_audioAssets, settings);

    // Start playing background music. Internally takes care
    // of checking user settings.
    AudioManager.instance.startBgm('8Bit Platformer Loop.wav');

    // Cache all the images.
    await images.loadAll(_imageAssets);

    // Set a fixed viewport to avoid manually scaling
    // and handling different screen sizes.
    camera.viewport = FixedResolutionViewport(Vector2(360, 180));

    /// Create a [ParallaxComponent] and add it to game.
    final parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData('parallax/plx-1.png'),
        ParallaxImageData('parallax/plx-2.png'),
        ParallaxImageData('parallax/plx-3.png'),
        ParallaxImageData('parallax/plx-4.png'),
        ParallaxImageData('parallax/plx-5.png'),
        ParallaxImageData('parallax/plx-6.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );
    add(parallaxBackground);

    // Create the main hero of this game.
    _dino = Dino(images.fromCache('DinoSprites - tard.png'), playerData);
    // Create an enemy manager.
    _enemyManager = EnemyManager();

    return super.onLoad();
  }

  // DinoGame() {
  //   _parallaxComponent = ParallaxComponent(
  //     [
  //       ParallaxImage("parallax/plx-1.png"),
  //       ParallaxImage("parallax/plx-2.png"),
  //       ParallaxImage("parallax/plx-3.png"),
  //       ParallaxImage("parallax/plx-4.png"),
  //       ParallaxImage("parallax/plx-5.png"),
  //       ParallaxImage("parallax/plx-6.png", fill: LayerFill.none),
  //     ],
  //     baseSpeed: Offset(100, 0),
  //     layerDelta: Offset(20, 0),
  //   );
  //   add(_parallaxComponent);

  //   _dino = Dino();
  //   add(_dino);
  //   _enemyManager = EnemyManager();
  //   add(_enemyManager);
  //   // var enemy = Enemy(EnemyType.AngryPig);
  //   // add(enemy);
  //   score = 0;
  //   _scoreText = TextComponent(
  //     score.toString(),
  //     config: TextConfig(
  //       fontFamily: 'Audiowide',
  //       color: Colors.white,
  //     ),
  //   );
  //   add(_scoreText);
  //   addWidgetOverlay('Hud', Hud(pauseGame: pauseGame));
  // }

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
