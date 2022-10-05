import 'package:firebase_food_app/app/modules/home/models/meals_model.dart';
import 'package:get/get.dart';

import '../models/restaurant_model.dart';
import '../providers/meals_provider.dart';
import '../providers/restaurants_provider.dart';

class HomeController extends GetxController {
  Future<RestaurantModel> getRestaurants() async {
    final data = await RestaurantsProviders().getRestaurants();
    return data;
  }

  Future<MealsModel> getMeals() async {
    final data = await MealsProviders().getRestaurants();
    return data;
  }
}
