import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_food_app/app/data/Food.dart';
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

  Future<void> deleteMenu(String id) async {
    final refDoc = ref.doc(id);
    refDoc.delete();
  }
}
