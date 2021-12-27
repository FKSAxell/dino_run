import 'dart:math';
import 'dart:ui';

import 'package:dino_run/game/constants.dart';
import 'package:flame/anchor.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/cupertino.dart';

enum EnemyType { AngryPig, Bat, Rino }

class EnemyData {
  final String imageName;
  final int textureWidth;
  final int textureHeight;
  final int nColumns;
  final int nRoms;
  final bool canFly;
  final int speed;

  const EnemyData({
    @required this.imageName,
    @required this.textureWidth,
    @required this.textureHeight,
    @required this.nColumns,
    @required this.nRoms,
    @required this.canFly,
    @required this.speed,
  });
}

class Enemy extends AnimationComponent {
  EnemyData _myData;
  static Random _random = Random();
  // double speed = 200;
  // Size size;
  // int textureWidth;
  // int textureHeight;
  static const Map<EnemyType, EnemyData> _enemyDetails = {
    EnemyType.AngryPig: EnemyData(
      imageName: "AngryPig/Walk (36x30).png",
      nColumns: 16,
      textureWidth: 36,
      textureHeight: 30,
      nRoms: 1,
      canFly: false,
      speed: 250,
    ),
    EnemyType.Bat: EnemyData(
      imageName: "Bat/Flying (46x30).png",
      textureWidth: 46,
      textureHeight: 30,
      nColumns: 7,
      nRoms: 1,
      canFly: true,
      speed: 300,
    ),
    EnemyType.Rino: EnemyData(
      imageName: "Rino/Run (52x34).png",
      textureWidth: 52,
      textureHeight: 34,
      nColumns: 6,
      nRoms: 1,
      canFly: false,
      speed: 350,
    ),
  };

  Enemy(EnemyType enemyType) : super.empty() {
    _myData = _enemyDetails[enemyType];
    final spriteSheet = SpriteSheet(
      imageName: _myData.imageName,
      textureWidth: _myData.textureWidth,
      textureHeight: _myData.textureHeight,
      columns: _myData.nColumns,
      rows: _myData.nRoms,
    );
    // final idleAnimation =
    //     spriteSheet.createAnimation(0, from: 0, to: 3, stepTime: 0.1);
    this.animation = spriteSheet.createAnimation(
      0,
      from: 0,
      to: (_myData.nColumns - 1),
      stepTime: 0.1,
    );

    this.anchor = Anchor.center;
  }
  @override
  void resize(Size size) {
    super.resize(size);
    double scaleFactor =
        (size.width / numberOfTilesAlongWidth) / _myData.textureWidth;
    this.height = _myData.textureHeight * scaleFactor;
    this.width = _myData.textureWidth * scaleFactor;
    this.x = size.width + this.width;
    this.y = size.height - groundHeight - (this.height / 2);
    if (_myData.canFly && _random.nextBool()) {
      this.y -= this.height;
    }
  }

  @override
  void update(double t) {
    super.update(t);
    this.x -= _myData.speed * t;

    //FUE REMPLAZADO POR OVERRIDE DESTROY
    // if (this.x < (-this.width)) {
    //   this.x = size.width + this.width;
    // }
  }

  @override
  bool destroy() {
    return this.x < (-this.width);
  }
}
