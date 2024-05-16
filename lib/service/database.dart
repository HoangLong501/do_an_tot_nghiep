
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
  Future<QuerySnapshot> getIdUserDetail (String id) async {
    return await FirebaseFirestore.instance
        .collection("user").where("IdUser" , isEqualTo: id).get();
  }
  createChatRoom(String chatRoomId , Map<String , dynamic>chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).get();
    if(snapshot.exists){
      return true;
    } else {
      // Cập nhật thời gian vào map trước khi đặt nó vào Firestore
      return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).set(chatRoomInfoMap);
    }
  }
  Future<DocumentReference?> addNews(String idUser,String idNewsfeed, Map<String, dynamic> newsfeedInfoMap) async {
    try {
      // Sử dụng ID tùy chỉnh được cung cấp để thêm dữ liệu vào Firestore.
      DocumentReference docRef = FirebaseFirestore.instance.collection("newsfeed").doc(idUser).collection("myNewsfeed").doc(idNewsfeed);
      await docRef.set(newsfeedInfoMap);
      print('Đã thêm tin tức thành công ');
      // Trả về DocumentReference của tài liệu đã thêm.
      return docRef;
    } catch (e) {
      print("Lỗi khi thêm tin tức vào Firestore: $e");
      // Xử lý lỗi tại đây nếu cần.
      return null;
    }
  }
  Future<QuerySnapshot> search(String username) async {
    return await FirebaseFirestore.instance.collection("user").where("SearchKey",isEqualTo: username).get();
  }
  Future initComment(String idNewsfeed,Map<String , dynamic> userInfoMap)async{
    return await FirebaseFirestore.instance
        .collection("comment").doc(idNewsfeed)
        .set(userInfoMap);
  }
  Future addComment(String idNewsfeed,String userComment ,Map<String , dynamic> userInfoMap)async{
    return await FirebaseFirestore.instance
        .collection("comment").doc(idNewsfeed).collection("commentDetail").doc(userComment)
        .set(userInfoMap);
  }

  Stream<QuerySnapshot> getMyNews(String idUser) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("newsfeed").doc(idUser).collection("myNewsfeed")
          .orderBy("newTimestamp", descending: true)
          .snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách tin tức: $error');
    }
  }
  Future<List<String>> getFriends(String userId) async {
    // CollectionReference friendsRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('friends');
    // QuerySnapshot friendsSnapshot = await friendsRef.where('status', isEqualTo: 'accepted').get();

    List<String> friendIds = ["Ly Ly_202405091941" ,"con_202405091930" ];
    // for (var doc in friendsSnapshot.docs) {
    //   friendIds.add(doc.id);
    // }
    return friendIds;
  }



  }


