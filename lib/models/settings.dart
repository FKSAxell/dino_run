import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// This class stores the game settings persistently.
class Settings extends GetxController {
  final RxBool _bgm = false.obs;

  final RxBool _sfx = false.obs;

  final _storage = GetStorage();

  @override
  void onInit() async {
    final storeBgm = await _storage.read('bgm');
    final storeSfx = await _storage.read('sfx');

    if (storeBgm != null) {
      _bgm.value = storeBgm;
    }

    if (storeSfx != null) {
      _sfx.value = storeSfx;
    }

    super.onInit();
  }

  bool get bgm => _bgm.value;
  set bgm(bool value) {
    _bgm.value = value;
  }

  bool get sfx => _sfx.value;
  set sfx(bool value) {
    _sfx.value = value;
  }
}
