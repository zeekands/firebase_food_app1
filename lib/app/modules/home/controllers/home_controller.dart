import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_food_app/app/data/Food.dart';
import 'package:firebase_food_app/app/routes/app_pages.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  CollectionReference ref = FirebaseFirestore.instance.collection('Food');
  String getCurrency(double price) {
    return NumberFormat.decimalPattern('en_us').format(price);
  }

  final buttonText = ["All", "Makanan", "Kuah", "Minuman"];
  final iconButton = [
    "assets/images/ic_makanan.png",
    "assets/images/ic_makanan.png",
    "assets/images/ic_kuah.png",
    "assets/images/ic_minuman.png"
  ];
  final selectedValueIndex = 0.obs;

  Stream<List<Food>> readFood(String jenis) {
    if (jenis != "All") {
      return FirebaseFirestore.instance
          .collection('Food')
          .where('jenis', isEqualTo: jenis)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
    } else {
      return FirebaseFirestore.instance.collection('Food').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
    }
  }

  Stream<List<Food>> searchFood(String search) {
    return FirebaseFirestore.instance
        .collection('Food')
        .where('nama', isGreaterThanOrEqualTo: search)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
  }

  Future<void> deleteMenu(String id) async {
    final refDoc = ref.doc(id);
    refDoc.delete();
  }

  Future<void> updateMenu(
      String id, String nama, int harga, String jenis, String image) async {
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "images": image,
    };
    refDoc.set(data);
  }

  Future<String> uploadFile(File image) async {
    final storageReference =
        FirebaseStorage.instance.ref().child('Menus/${image.path}');
    await storageReference.putFile(image);
    String returnURL = "";
    await storageReference.getDownloadURL().then(
      (fileURL) {
        returnURL = fileURL;
      },
    );
    return returnURL;
  }

  Future<void> updateMenuWithImage(
    String id,
    String nama,
    int harga,
    String jenis,
    File images,
  ) async {
    String imageURL = await uploadFile(images);
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "images": imageURL,
    };
    refDoc.set(data);
  }
}

class HomeSearchDelegate extends SearchDelegate {
  HomeSearchDelegate(this.controller);
  final HomeController controller;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Food>>(
        stream: controller.searchFood(query),
        builder: (context, snapshot) {
          return Obx(
            () => ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data?[index].nama ?? ""),
                );
              },
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<Food>>(
      stream: controller.searchFood(query),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data;
                  if (data == null) return const SizedBox();
                  if (data[index].nama.startsWith(query)) {
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 10.w,
                      ),
                      isThreeLine: true,
                      onTap: () {
                        Get.toNamed(Routes.DETAIL_FOOD, arguments: data[index]);
                      },
                      title: Text(
                        " ${snapshot.data?[index].nama}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ).paddingAll(5.r),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.r,
                                  vertical: 5.r,
                                ),
                                height: 20.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.r),
                                  ),
                                  color: Colors.amber,
                                ),
                                child: Text(
                                  "Rp. ${controller.getCurrency(snapshot.data?[index].waktuPembuatan.toDouble() ?? 0)}",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.r,
                                  vertical: 5.r,
                                ),
                                height: 20.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.r),
                                    ),
                                    color: Colors.amber),
                                child: Text(
                                  "${snapshot.data?[index].jenis}",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          5.verticalSpace,
                        ],
                      ).paddingAll(5.r),
                      trailing: Image(
                        image: CachedNetworkImageProvider(
                          snapshot.data?[index].images ?? "",
                        ),
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    );
                  }
                  return Container();
                },
              );
      },
    );
  }
}
