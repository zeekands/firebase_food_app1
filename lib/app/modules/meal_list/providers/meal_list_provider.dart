import 'package:get/get.dart';

import '../models/meal_list_model.dart';

class MealListProvider extends GetConnect {
  Future<MealModel> getMeal(String category) async {
    final response = await get(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category');
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return MealModel.fromJson(response.body as Map<String, dynamic>);
    }
  }
}
