import 'package:get/state_manager.dart';

class LifeController extends GetxController {
  RxInt counter = 3.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void decrement() {
    if (counter.value > 0) {
      counter.value--;
    }
  }

  void reset() {
    counter.value = 3;
  }
}
