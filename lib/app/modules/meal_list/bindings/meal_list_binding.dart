import 'package:get/get.dart';

import '../controllers/meal_list_controller.dart';

class MealListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealListController>(
      () => MealListController(),
    );
  }
}
