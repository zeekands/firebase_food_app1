import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_food_app/app/data/Food.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class DetailFoodController extends GetxController {
  CollectionReference ref = FirebaseFirestore.instance.collection('Food');
  Stream<Food> getFood(String id) {
    return FirebaseFirestore.instance
        .collection('Food')
        .doc(id)
        .snapshots()
        .map((event) => Food.fromJson(event.data()!));
  }

  Future<void> deleteMenu(String id) async {
    final refDoc = ref.doc(id);
    refDoc.delete();
  }

  Future<void> updateMenu(String id, String nama, int harga, String jenis,
      String image, String resep) async {
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "images": image,
      "resep": resep,
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
    String resep,
  ) async {
    String imageURL = await uploadFile(images);
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "images": imageURL,
      "resep": resep,
    };
    refDoc.set(data);
  }
}
