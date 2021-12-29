import 'package:dino_run/screens/main_menu.dart';
import 'package:flutter/material.dart';

class GameOverMenu extends StatelessWidget {
  final Function onRestartPressed;
  final int score;
  const GameOverMenu({
    Key key,
    @required this.onRestartPressed,
    @required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MainMenu(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.restart_alt,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    onPressed: onRestartPressed,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
