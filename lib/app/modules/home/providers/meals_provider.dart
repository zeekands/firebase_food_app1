import 'package:firebase_food_app/app/modules/home/models/meals_model.dart';
import 'package:get/get.dart';

class MealsProviders extends GetConnect {
  Future<MealsModel> getRestaurants() async {
    final response =
        await get('https://www.themealdb.com/api/json/v1/1/categories.php');
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return MealsModel.fromJson(response.body as Map<String, dynamic>);
    }
  }
}
