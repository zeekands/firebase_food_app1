import 'package:get/get.dart';

import '../models/restaurant_model.dart';
import '../providers/restaurants_provider.dart';

class HomeController extends GetxController {
  Future<RestaurantModel> getRestaurants() async {
    final data = await RestaurantsProviders().getRestaurants();
    return data;
  }
}
