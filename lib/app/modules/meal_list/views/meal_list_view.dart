import 'package:firebase_food_app/app/modules/meal_list/models/meal_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/meal_list_controller.dart';

class MealListView extends GetView<MealListController> {
  const MealListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${controller.idMeal} Recipe'),
      ),
      body: FutureBuilder<MealModel>(
        future: controller.getMeals(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data?.meals;
            return ListView.builder(
              itemCount: snapshot.data.meals.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: SizedBox(
                        height: 250.h,
                        width: double.infinity,
                        child: Image.network(
                          data![index].strMealThumb!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 250.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: SizedBox(
                        width: 250.w,
                        child: Text(
                          data[index].strMeal!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20.w, vertical: 10.h);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
