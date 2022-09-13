import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodController extends GetxController {
  final image = XFile("").obs;

  CollectionReference ref = FirebaseFirestore.instance.collection('Food');
  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  final selectJenis = [
    "Makanan",
    "Minuman",
    "Kuah",
  ];

  final selectedJenis = "Makanan".obs;

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
    }

    if (pickedFile != null) {
      image.value = pickedFile;
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    hargaController.dispose();
    deskripsiController.dispose();
    super.onClose();
  }

  Future<String> uploadFile(File image) async {
    final storageReference =
        FirebaseStorage.instance.ref().child('Menus/${image.path}');
    await storageReference.putFile(image);
    print('File Uploaded');
    String returnURL = "";
    await storageReference.getDownloadURL().then(
      (fileURL) {
        returnURL = fileURL;
      },
    );
    return returnURL;
  }

  Future<void> saveImages(
    File images,
    String nama,
    int harga,
    String jenis,
    String deskripsi,
  ) async {
    String imageURL = await uploadFile(images);
    final refDoc = ref.doc();
    final data = {
      "id": refDoc.id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "deskripsi": deskripsi,
      "images": imageURL
    };
    refDoc.set(data);
  }

  Future<void> editMenu(
    String id,
    String nama,
    int harga,
    String jenis,
    File images,
    String deskripsi,
  ) async {
    String imageURL = await uploadFile(images);
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "deskripsi": deskripsi,
      "images": imageURL
    };
    refDoc.set(data);
  }
}
