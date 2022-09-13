import 'package:get/get.dart';

import '../modules/add_food/bindings/add_food_binding.dart';
import '../modules/add_food/views/add_food_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_FOOD,
      page: () => const AddFoodView(),
      binding: AddFoodBinding(),
    ),
  ];
}
