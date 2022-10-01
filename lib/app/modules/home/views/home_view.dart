import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_food_app/app/modules/home/models/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(
                    ScreenUtil().setWidth(10),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 18.r,
                      color: Colors.grey[500],
                    ),
                    20.horizontalSpace,
                    Text(
                      "Search",
                      style: TextStyle(fontSize: 12.sp),
                    )
                  ],
                ).paddingAll(10.r),
              ),
            ).paddingSymmetric(horizontal: 20.w, vertical: 10.h),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Restoran List From API",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
          ).paddingOnly(bottom: 20.h),
          Flexible(
            child: FutureBuilder<RestaurantModel>(
              future: controller.getRestaurants(),
              builder: (_, snapshot) {
                var data = snapshot.data?.restaurants;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.h,
                      crossAxisCount: 2,
                      childAspectRatio: .8,
                    ),
                    itemBuilder: (_, index) => itemRestaurant(data, index),
                    itemCount: data?.length,
                  );
                } else {
                  return const Center(
                    child: Text("Data Kosong"),
                  );
                }
              },
            ),
          )
        ],
      ).paddingOnly(left: 20.w, right: 20.w, bottom: 10.h),
    );
  }

  Container itemRestaurant(List<Restaurants>? data, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ScreenUtil().setWidth(10),
        ),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.h,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                ScreenUtil().setWidth(10),
              ),
              topRight: Radius.circular(
                ScreenUtil().setWidth(10),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl:
                  "https://restaurant-api.dicoding.dev/images/medium/${data?[index].pictureId}",
              height: 135.h,
              width: 200.w,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    data?[index].name ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.red,
                        ),
                        5.horizontalSpace,
                        Text(
                          data?[index].city ?? "",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(12),
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        5.horizontalSpace,
                        Text(
                          data?[index].rating ?? "",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(12),
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                15.verticalSpace,
              ],
            ).paddingOnly(
              top: 10.h,
              left: 10.w,
              right: 10.w,
            ),
          ),
        ],
      ),
    );
  }
}
