import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/add_food_controller.dart';

class AddFoodView extends GetView<AddFoodController> {
  const AddFoodView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Menu Baru'),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              20.verticalSpace,
              controller.image.value.path != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.file(
                        File(controller.image.value.path),
                        height: 200.h,
                        width: 200.w,
                        fit: BoxFit.cover,
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        await controller.getImage(true);
                      },
                      child: Container(
                        height: 200.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text("Tambah Foto"),
                        ),
                      ),
                    ),
              20.verticalSpace,
              Obx(
                () => Center(
                  child: controller.image.value.path != ""
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            controller.image.value = XFile("");
                          },
                        )
                      : const SizedBox(),
                ),
              ),
              20.verticalSpace,
              TextField(
                controller: controller.namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              TextField(
                controller: controller.hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              TextField(
                controller: controller.deskripsiController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
              10.verticalSpace,
              Container(
                width: 1.sw,
                height: 50.h,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton(
                    alignment: Alignment.center,
                    isExpanded: true,
                    underline: Container(),
                    iconSize: 32,
                    value: controller.selectedJenis.value,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: controller.selectJenis.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      controller.selectedJenis.value = newValue.toString();
                    }),
              ),
              20.verticalSpace,
              GestureDetector(
                onTap: () async {
                  if (controller.namaController.text.isEmpty ||
                      controller.hargaController.text.isEmpty ||
                      controller.selectedJenis.value.isEmpty ||
                      controller.image.value.path.isEmpty) {
                    Get.snackbar('Error', 'Lengkapi data terlebih dahulu',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        borderRadius: 10,
                        margin: const EdgeInsets.all(10),
                        snackStyle: SnackStyle.FLOATING);
                  } else {
                    await controller.saveImages(
                        File(controller.image.value.path),
                        controller.namaController.text,
                        int.parse(controller.hargaController.text),
                        controller.selectedJenis.value,
                        controller.deskripsiController.text);
                    Get.back();
                    Get.snackbar("Berhasil", "Menu berhasil ditambahkan.",
                        backgroundColor: Colors.green, colorText: Colors.white);
                  }
                },
                child: Container(
                    width: 1.sw,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Text('Add Menu',
                            style: TextStyle(color: Colors.white)))),
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w, vertical: 10.h),
        ),
      ),
    );
  }
}
