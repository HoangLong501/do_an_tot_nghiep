
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  
  Future addUserDetail(String id ,Map<String , dynamic> userInfoMap )async{
    return await FirebaseFirestore.instance
        .collection("user").doc(id)
        .set(userInfoMap);
  }
  Future<void> updateUserDetail(String id, Map<String, dynamic> updatedUserInfoMap) async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .update(updatedUserInfoMap);
      print("Cập nhật thông tin người dùng thành công!");
    } catch (e) {
      print("Lỗi khi cập nhật thông tin người dùng: $e");
    }
  }
}