import 'package:firebase_food_app/app/modules/home/models/meals_model.dart';
import 'package:get/get.dart';

import '../providers/meals_provider.dart';

class HomeController extends GetxController {
  Future<MealsModel> getMeals() async {
    final data = await MealsProviders().getRestaurants();
    return data;
  }
}
