import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_food_app/app/data/Food.dart';
import 'package:firebase_food_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/detail_food_controller.dart';

class DetailFoodView extends GetView<DetailFoodController> {
  const DetailFoodView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final food = Get.arguments as Food;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, -1),
            ),
          ],
        ),
        height: 100.h,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                deleteMenu(food.id);
              },
              child: Container(
                  width: 150.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.white,
                      ),
                      10.horizontalSpace,
                      const Text("Hapus", style: TextStyle(color: Colors.white))
                    ],
                  )),
            ),
            GestureDetector(
              onTap: () {
                editMenu(food, context);
              },
              child: Container(
                  width: 150.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                      10.horizontalSpace,
                      const Text("Edit", style: TextStyle(color: Colors.white))
                    ],
                  )),
            ),
          ],
        ),
      ),
      body: StreamBuilder<Food>(
          stream: controller.getFood(food.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300.h,
                    backgroundColor: Colors.red,
                    pinned: true,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ).marginSymmetric(horizontal: 10.w, vertical: 10.h),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(100),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            snapshot.data!.nama,
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        snapshot.data!.images,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ColoredBox(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.resep,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("Data tidak ditemukan"));
            }
          }),
    );
  }

  void editMenu(Food food, BuildContext context) {
    final image = XFile("").obs;
    final namaController = TextEditingController();
    final hargaController = TextEditingController();
    final resepController = TextEditingController();
    namaController.text = food.nama;
    hargaController.text = food.harga.toString();
    resepController.text = food.resep;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Obx(
        () => Container(
          height: 0.9.sh,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(10),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Edit Menu",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w500)),
                    IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          size: 16.sp,
                          color: Colors.grey[500],
                        )),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      ScreenUtil().setWidth(10),
                    ),
                  ),
                  child: image.value.path == ""
                      ? CachedNetworkImage(
                          imageUrl: food.images,
                          width: 1.sw,
                          height: 200.h,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(image.value.path),
                          width: 1.sw,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                ),
                10.verticalSpace,
                ElevatedButton(
                    onPressed: () async {
                      ImagePicker picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        image.value = pickedFile;
                      }
                    },
                    child: const Text("Edit Foto")),
                20.verticalSpace,
                Text(
                  "Nama Menu",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
                10.verticalSpace,
                RoundedInputField(
                  textEditingController: namaController,
                  hintText: food.nama.toString(),
                ),
                15.verticalSpace,
                Text(
                  "Harga",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
                10.verticalSpace,
                RoundedInputField(
                  textEditingController: hargaController,
                  hintText: food.resep.toString(),
                ),
                10.verticalSpace,
                Text(
                  "Resep",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
                10.verticalSpace,
                RoundedInputField(
                  maxLines: 10,
                  textEditingController: resepController,
                  hintText: food.nama.toString(),
                ),
                30.verticalSpace,
                Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: ScreenUtil().setHeight(40),
                        width: 0.8.sw,
                        child: ElevatedButton(
                          onPressed: () {
                            //deleteMenu(snapshot, index);
                            Get.back();
                            Get.snackbar(
                              "Hapus Berhasil",
                              "Data Telah Berhasil Dihapus",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                          child: const Text('Hapus Menu'),
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Flexible(
                      child: SizedBox(
                        height: ScreenUtil().setHeight(40),
                        width: 0.5.sw,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            if (image.value.path.isNotEmpty) {
                              await controller.updateMenuWithImage(
                                food.id,
                                namaController.text,
                                int.parse(hargaController.text),
                                food.jenis,
                                File(image.value.path),
                                resepController.text,
                              );
                            } else {
                              await controller.updateMenu(
                                food.id,
                                namaController.text,
                                int.parse(hargaController.text),
                                food.jenis,
                                food.images,
                                resepController.text,
                              );
                            }
                            Get.back();
                            Get.snackbar(
                              "Edit Berhasil",
                              "Data Telah Berhasil Diedit",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                          child: const Text('Simpan Menu'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ).paddingSymmetric(vertical: 10.h, horizontal: 20.w),
          ),
        ),
      ),
    );
  }

  void deleteMenu(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text("Hapus"),
        content: const Text("Apakah anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteMenu(id);
              Get.offAllNamed(Routes.HOME);
              Get.snackbar(
                "Dihapus",
                "Data berhasil dihapus",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                margin: const EdgeInsets.all(10),
              );
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }
}

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final double? roundedCorner;
  final ValueChanged<String>? onChanged;
  final TextEditingController? textEditingController;
  final double? width;
  final double? height;
  final double? textSize;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final int? maxLines;
  final TextInputType? keyboardType;
  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.textEditingController,
    this.roundedCorner = 10,
    this.height,
    this.width,
    this.textSize,
    this.backgroundColor,
    this.padding,
    this.borderColor,
    this.keyboardType,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onChanged: onChanged,
        controller: textEditingController,
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundedCorner!),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundedCorner!),
            borderSide: const BorderSide(
              color: Colors.green,
            ),
          ),
          contentPadding: padding ??
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: textSize ?? 13),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
