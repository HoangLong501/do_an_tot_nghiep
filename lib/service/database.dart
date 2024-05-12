
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/lib_class_import/user.dart';

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
  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("user").where("E-mail", isEqualTo: email).get();
  }
  Future<List<Person>> getUserByName(String name) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("user")
        .where("Username", isEqualTo: name)
        .get();

    List<Person> userList = [];

    querySnapshot.docs.forEach((document) {
      Person user = Person(
        id: document['IdUser'],
        username: document['Username'],
        email: document['E-mail'],
        birthDate: document['Birthdate'],
        phone: document['Phone'],
        sex: document['Sex'],
        image: document['imageAvatar'],
      );
      userList.add(user);
    });

    return userList;
  }
  Future<List<Person>> getUser() async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("user")
        .get();
    List<Person> userList = [];

    querySnapshot.docs.forEach((document) {
      Person user = Person(
        id: document['IdUser'],
        username: document['Username'],
        email: document['E-mail'],
        birthDate: document['Birthdate'],
        phone: document['Phone'],
        sex: document['Sex'],
        image: document['imageAvatar'],
      );
      userList.add(user);
    });

    return userList;
  }




}