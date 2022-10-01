import 'package:firebase_food_app/app/modules/home/models/restaurant_model.dart';
import 'package:get/get.dart';

class RestaurantsProviders extends GetConnect {
  Future<RestaurantModel> getRestaurants() async {
    final response = await get('https://restaurant-api.dicoding.dev/list');
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return RestaurantModel.fromJson(response.body as Map<String, dynamic>);
    }
  }
}
