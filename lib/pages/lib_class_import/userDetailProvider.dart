import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailProvider with ChangeNotifier {
  String _name = "", _avatar = "", _background = "",_since="" ,_phone="",
      _relationship = "", _address = "", _born = "", _sex = "", _birthday = "";

  String get name => _name;
  String get avatar => _avatar;
  String get background => _background;
  String get relationship => _relationship;
  String get address => _address;
  String get born => _born;
  String get sex => _sex;
  String get birthday => _birthday;
  String get since => _since;
  String get phone => _phone;

  String? idUserDevice;

  Future<void> getidUserDevice() async {
    idUserDevice = await SharedPreferenceHelper().getIdUser();
  }

  Future<void> getUserDetails() async {
    await getidUserDevice();
    if (idUserDevice != null) {
      DocumentSnapshot data = await FirebaseFirestore.instance.collection("userinfo")
          .doc(idUserDevice).get();
      _background = data.get("imageBackground");
      _relationship = data.get("relationship");
      _address = data.get("address");
      _born = data.get("born");
      _since=data.get("since");
      notifyListeners();
    }
  }
  Future<void> getUser() async {
    await getidUserDevice();
    if (idUserDevice != null) {
      DocumentSnapshot data = await FirebaseFirestore.instance.collection("user")
          .doc(idUserDevice).get();
      _name = data.get("Username");
      _avatar = data.get("imageAvatar");
      _sex = data.get("Sex");
      _birthday = data.get("Birthdate");
      _phone = data.get("Phone");
      notifyListeners();
    }
  }

  Future<void> updateName(String name) async {
    await getidUserDevice();
    if (idUserDevice != null) {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(idUserDevice)
          .update({"Username": name});
      _name = name;
      notifyListeners();
    }
  }

  Future<void> updateAvatar(String avatar) async {
    await getidUserDevice();
    if (idUserDevice != null) {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(idUserDevice)
          .update({"imageAvatar": avatar});
      _avatar = avatar;
      notifyListeners();
    }
  }
  Future<void> updatePhone(String phone) async {
    await getidUserDevice();
    if (idUserDevice != null) {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(idUserDevice)
          .update({"Phone": phone});
      _phone = phone;
      notifyListeners();
    }
  }

  Future<void> updateBackground(String background) async {
    await getidUserDevice();
    if (idUserDevice != null) {
      await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(idUserDevice)
          .update({"imageBackground": background});
      _background = background;
      notifyListeners();
    }
  }

  Future<void> updateRelationship(String relationship) async {
    await getidUserDevice();
    if (idUserDevice != null) {
      await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(idUserDevice)
          .update({"relationship": relationship});
      _relationship = relationship;
      notifyListeners();
    }
  }

  Future<void> updateAddress(String address) async {
    await getidUserDevice();
    if (idUserDevice != null) {
      await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(idUserDevice)
          .update({"address": address});
      _address = address;
      notifyListeners();
    }
  }
  Future<void> updateSince(String since) async {
    await getidUserDevice();
    if (idUserDevice != null) {
      await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(idUserDevice)
          .update({"since": since});
      _since = since;
      notifyListeners();
    }
  }

  Future<void> updateBorn(String born) async {
    await getidUserDevice();
    if (idUserDevice != null) {
      await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(idUserDevice)
          .update({"born": born});
      _born = born;
      notifyListeners();
    }
  }

  Future<void> updateSex(String sex) async {
    await getidUserDevice();
    if (idUserDevice != null) {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(idUserDevice)
          .update({"Sex": sex});
      _sex = sex;
      notifyListeners();
    }
  }

  Future<void> updateBirthday(String birthday) async {
    await getidUserDevice();
    if (idUserDevice != null) {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(idUserDevice)
          .update({"Birthdate": birthday});
      _birthday = birthday;
      notifyListeners();
    }
  }
}
