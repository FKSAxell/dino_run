import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// This class stores the player progress presistently.
class PlayerData extends GetxController {
  RxInt highScore = 0.obs;

  final RxInt _lives = 3.obs;

  final _storage = GetStorage();

  int get lives => _lives.value;

  @override
  void onInit() async {
    final storeHighScore = await _storage.read('highScore');

    if (storeHighScore) {
      highScore.value = storeHighScore;
    }

    super.onInit();
  }

  set lives(int value) {
    if (value <= 3 && value >= 0) {
      _lives.value = value;
    }
  }

  final RxInt _currentScore = 0.obs;

  int get currentScore => _currentScore.value;

  set currentScore(int value) {
    _currentScore.value = value;
    if (highScore < _currentScore.value) {
      highScore.value = _currentScore.value;
      _storage.write('highScore', highScore.value);
    }
  }
}
