import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/models/settings.dart';
import 'package:dino_run/widgets/game_over_menu.dart';
import 'package:dino_run/widgets/hud.dart';
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

  /// This method add the already created [Dino]
  /// and [EnemyManager] to this game.
  void startGamePlay() {
    add(_dino);
    add(_enemyManager);
  }

  // This method remove all the actors from the game.
  void _disconnectActors() {
    _dino.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }

// This will get called for each tap on the screen.
  @override
  void onTapDown(TapDownInfo info) {
    // Make dino jump only when game is playing.
    // When game is in playing state, only Hud will be the active overlay.
    if (overlays.isActive(Hud.id)) {
      _dino.jump();
    }
    super.onTapDown(info);
  }

  // This method gets called for each tick/frame of the game.
  @override
  void update(double dt) {
    // If number of lives is 0 or less, game is over.
    if (playerData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
      AudioManager.instance.pauseBgm();
    }
    super.update(dt);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // On resume, if active overlay is not PauseMenu,
        // resume the engine (lets the parallax effect play).
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        // If game is active, then remove Hud and add PauseMenu
        // before pausing the game.
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }

  // This method reset the whole game world to initial state.
  void reset() {
    // First disconnect all actions from game world.
    _disconnectActors();

    // Reset player data to inital values.
    playerData.currentScore = 0;
    playerData.lives = 3;
  }
}
