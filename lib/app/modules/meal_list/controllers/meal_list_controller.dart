import 'package:firebase_food_app/app/modules/meal_list/models/meal_list_model.dart';
import 'package:get/get.dart';

import '../providers/meal_list_provider.dart';

class MealListController extends GetxController {
  final idMeal = Get.arguments.toString();

  Future<MealModel> getMeals() async {
    final data = await MealListProvider().getMeal(idMeal);
    return data;
  }
}
