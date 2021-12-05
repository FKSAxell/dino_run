import 'dart:ui';

import 'package:dino_run/game/constants.dart';
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

  const EnemyData({
    @required this.imageName,
    @required this.textureWidth,
    @required this.textureHeight,
    @required this.nColumns,
    @required this.nRoms,
  });
}

class Enemy extends AnimationComponent {
  double speed = 200;
  Size size;
  int textureWidth;
  int textureHeight;
  static const Map<EnemyType, EnemyData> _enemyDetails = {
    EnemyType.AngryPig: EnemyData(
      imageName: "AngryPig/Walk (36x30).png",
      nColumns: 16,
      textureWidth: 36,
      textureHeight: 30,
      nRoms: 1,
    ),
    EnemyType.Bat: EnemyData(
      imageName: "Bat/Flying (46x30).png",
      textureWidth: 46,
      textureHeight: 30,
      nColumns: 7,
      nRoms: 1,
    ),
    EnemyType.Rino: EnemyData(
      imageName: "Rino/Run (52x34).png",
      textureWidth: 52,
      textureHeight: 34,
      nColumns: 6,
      nRoms: 1,
    ),
  };
  Enemy(EnemyType enemyType) : super.empty() {
    final enemyData = _enemyDetails[enemyType];
    final spriteSheet = SpriteSheet(
      imageName: enemyData.imageName,
      textureWidth: enemyData.textureWidth,
      textureHeight: enemyData.textureHeight,
      columns: enemyData.nColumns,
      rows: enemyData.nRoms,
    );
    // final idleAnimation =
    //     spriteSheet.createAnimation(0, from: 0, to: 3, stepTime: 0.1);
    this.animation = spriteSheet.createAnimation(
      0,
      from: 0,
      to: (enemyData.nColumns - 1),
      stepTime: 0.1,
    );
    textureWidth = enemyData.textureWidth;
    textureHeight = enemyData.textureHeight;
  }
  @override
  void resize(Size size) {
    super.resize(size);
    double scaleFactor = (size.width / numberOfTilesAlongWidth) / textureWidth;
    this.height = textureHeight * scaleFactor;
    this.width = textureWidth * scaleFactor;
    this.x = size.width + this.width;
    this.y = size.height - groundHeight - this.height;
    this.size = size;
  }

  @override
  void update(double t) {
    super.update(t);
    this.x -= speed * t;
    if (this.x < (-this.width)) {
      this.x = size.width + this.width;
    }
  }
}
