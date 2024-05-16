
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
  Future addRelationship(String id ,Map<String , dynamic> userInfoMap )async{
    return await FirebaseFirestore.instance
        .collection("relationship").doc(id)
        .set(userInfoMap);
  }
 Future requestFriend(String requestId, String receiveId) async {
    // lấy id của người gửi
    DocumentSnapshot docrequestId =
    await FirebaseFirestore.instance.collection("relationship").doc(requestId).get();
    // lấy danh sách theo id
    Map<String, dynamic> userData = docrequestId.data() as Map<String, dynamic>;
    // lấy request của người gửi
    List<String> newListRequest = List<String>.from(userData['Request'] ?? []);
   // print(newListRequest);
    if(!newListRequest.contains(receiveId)){
      newListRequest.add(receiveId);

      Map<String, dynamic> requestMap= {
        "Request":newListRequest
      };
      FirebaseFirestore.instance
          .collection("relationship")
          .doc(requestId)
          .update(requestMap);
    }else{
      print("có $receiveId rồi");
    }
    // lấy thông tin người nhận
  DocumentSnapshot docReceiveId =
  await FirebaseFirestore.instance.collection("relationship").doc(receiveId).get() ;
    // lấy danh sách người nhận
    Map<String,dynamic> userReceiveData=docReceiveId.data() as Map<String,dynamic>;
    // lấy received của người nhận
    List<String>newListReceive=List<String>.from(userReceiveData['Received'] ?? []);
      if(!newListReceive.contains(requestId)) {
        newListReceive.add(requestId);
        Map<String, dynamic> receiveMap = {
          "Received": newListReceive
        };
        FirebaseFirestore.instance.collection("relationship")
            .doc(receiveId)
            .update(receiveMap);
      }else{
        print("có $requestId rồi");
      }
     // lấy received của người gửi
    List<String>listReqestReceive =List<String>.from(userData['Received'] ?? []);
      //lấy request của người nhận
    List<String>listReceiveRequest =List<String>.from(userReceiveData['Request'] ?? []);
    // Xóa người gửi khi request = receive
    for(String requestkey in newListRequest ){
      for(String receivekey in listReqestReceive){
        if(requestkey == receivekey) {
          newListRequest.remove(requestkey);
          Map<String, dynamic> requestMapRemove = {
            "Request": newListRequest
          };
          FirebaseFirestore.instance
              .collection("relationship")
              .doc(requestId)
              .update(requestMapRemove);

          listReqestReceive.remove(receivekey);
          Map<String, dynamic> receiveMapRemove = {
            "Received": listReqestReceive
          };
          FirebaseFirestore.instance.collection("relationship")
              .doc(requestId)
              .update(receiveMapRemove);
          if(newListReceive.contains(requestId)) {
            newListReceive.remove(requestId);
            Map<String, dynamic> receiveMapRemove = {
              "Received": newListReceive
            };
            FirebaseFirestore.instance.collection("relationship")
                .doc(receiveId)
                .update(receiveMapRemove);
          }
          if(listReceiveRequest.contains(requestId)) {
            listReceiveRequest.remove(requestId);
            Map<String, dynamic> receiveMapRemove = {
              "Request": listReceiveRequest
            };
            FirebaseFirestore.instance.collection("relationship")
                .doc(receiveId)
                .update(receiveMapRemove);
          }
          // thêm bạn của người gửi
          List<String>newListRequestFriend = List<String>.from(
              userData['Friends'] ?? []);
          newListRequestFriend.add(requestId);
          Map<String, dynamic> requestFriendMap = {
            "Friends": newListRequestFriend
          };
          FirebaseFirestore.instance.collection("relationship")
              .doc(receiveId)
              .update(requestFriendMap);
          // thêm bạn của người nhận
          List<String>newListReceiveFriend = List<String>.from(
              userReceiveData['Friends'] ?? []);
          newListReceiveFriend.add(receiveId);
          print(newListReceiveFriend);
          Map<String, dynamic> receiveFriendMap = {
            "Friends": newListReceiveFriend
          };
          print(receiveFriendMap);
          FirebaseFirestore.instance.collection("relationship")
              .doc(requestId)
              .update(receiveFriendMap);

          print("thêm bạn thành công");
         }
        }
      }
     }


  // Future receiveFriend(String requestId , Map<String , dynamic> receiveId) async {
  //   return await FirebaseFirestore.instance
  //       .collection("relationship").doc(requestId)
  //       .set(receiveId);
  // }
  // lấy danh sách request
Future<List<String>>getRequest(String id) async{
  DocumentSnapshot docRequest =
  await FirebaseFirestore.instance.collection("relationship").doc(id).get() ;
  Map<String,dynamic> userReceiveData=docRequest.data() as Map<String,dynamic>;
  List<String>newListReceive=List<String>.from(userReceiveData['Request'] ?? []);
  return newListReceive;
}

//lấy danh sách receive
  Stream<List<String>>getReceive(String id) async*{
    List<String> list=[];
    DocumentSnapshot docRequest =
    await FirebaseFirestore.instance.collection("relationship").doc(id).get() ;
    //print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
    Map<String,dynamic> userReceiveData=docRequest.data() as Map<String,dynamic>;
    List<String>newListReceive=List<String>.from(userReceiveData['Received'] ?? []);
      for(String newList in newListReceive){
        list.add(newList);
        yield list;
      }
      //print(list);

  }
  //lấy danh sách friends
  Future<List<String>>getFriends(String id) async{
      DocumentSnapshot docRequest =
      await FirebaseFirestore.instance.collection("relationship")
          .doc(id)
          .get();
      Map<String, dynamic> userReceiveData = docRequest.data() as Map<
          String,
          dynamic>;
      List<String>newListReceive = List<String>.from(
          userReceiveData['Friends'] ?? []);
          return newListReceive;
      }

  Stream<QuerySnapshot> getUsers() async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("user")
          .snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách tin tức: $error');
    }
  }
  Future deleteRequest( String idUser,String idRequest) async{
    DocumentSnapshot docRequest =
    await FirebaseFirestore.instance.collection("relationship").doc(idUser).get() ;
    Map<String,dynamic> userReceiveData=docRequest.data() as Map<String,dynamic>;
    List<String>newListRequest=List<String>.from(userReceiveData['Request'] ?? []);

    if(newListRequest.contains(idRequest)) {
      newListRequest.remove(idRequest);
      // print(idRequest);
      // print(newListRequest);
      Map<String, dynamic> requestMap = {
        "Request": newListRequest
      };
      FirebaseFirestore.instance.collection("relationship")
          .doc(idUser)
          .update(requestMap);

      DocumentSnapshot docReceive =
      await FirebaseFirestore.instance.collection("relationship").doc(idRequest).get() ;
      Map<String,dynamic> userReceiveData=docReceive.data() as Map<String,dynamic>;
      List<String>newListReceive=List<String>.from(userReceiveData['Received'] ?? []);

      if(newListReceive.contains(idUser)) {
        newListReceive.remove(idUser);
        // print(idRequest);
        // print(newListReceive);
        Map<String, dynamic> receivetMap = {
          "Received": newListReceive
        };
        FirebaseFirestore.instance.collection("relationship")
            .doc(idRequest)
            .update(receivetMap);
        print("xóa lời mời ok");
      }
    }
  }
// cập nhật thông tin người dùng
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

  Future<QuerySnapshot> getUserById(String id) async{
    return await FirebaseFirestore.instance
        .collection("user").where("IdUser", isEqualTo: id).get();
  }
  Future addHideHintsFriend(String idUser,String idHideHintsFriend) async {
    DocumentSnapshot docIdUser =
    await FirebaseFirestore.instance.collection("user").doc(idUser).get();
    Map<String, dynamic> userData = docIdUser.data() as Map<String, dynamic>;
    List<String> newListUser = List<String>.from(
        userData['HideHintsFriend'] ?? []);
    if (!newListUser.contains(idHideHintsFriend)) {
      newListUser.add(idHideHintsFriend);
      Map<String, dynamic> requestMap = {
        "HideHintsFriend": newListUser
      };
      FirebaseFirestore.instance
          .collection("user")
          .doc(idUser)
          .update(requestMap);
      print("xóa gợi ý bạn bè thành công");
    }
  }
  Stream<List<String>> getHideHintsFriend(String id) async*{
    List<String> list=[];
    DocumentSnapshot docId =
    await FirebaseFirestore.instance.collection("user").doc(id).get();
    Map<String, dynamic> userData = docId.data() as Map<String, dynamic>;
    List<String> newListUser = List<String>.from(
        userData['HideHintsFriend'] ?? []);
        for(String idUser in newListUser){
          list.add(idUser);
          yield list;
        }
  }
  Stream<List<Person>> getHideHintsUsers(String id, List<Person> users) async*{
    Stream<List<String>>? getHideHintsFriends;
    Stream<List<String>>? getListReceived;
    List<String>listReceived=[];
     getListReceived= await getReceive(id) ;
     await for(List<String> list in getListReceived){
       listReceived=list;
     }
    List listFriend=await getFriends(id) ;
    List<String> listGetHideHintsFriend=[];
    getHideHintsFriends=await getHideHintsFriend(id) ;
    await for(List<String> list in getHideHintsFriends){
      listGetHideHintsFriend=list;
    }
    //print(id);
    print(users.length);
    for(int i=0;i<users.length;i++){
      bool removed = false;
       //print(users[i].id);
      if(users[i].id==id){
        print("vào được rồi");
        users.remove(users[i]);
        removed = true;
      }
      if(listFriend.contains(users[i].id)){
        // print(listFriend);
        users.remove(users[i]);
        removed = true;
      }
      if(listReceived.contains(users[i])){
        //  print(listReceive);
        users.remove(users[i]);
        removed = true;
      }
      if(listGetHideHintsFriend.contains(users[i].id)){
        users.remove(users[i]);
        // print(uSers[i]);
        removed = true;
      }
      if (removed) {
        i--; // Lùi lại chỉ mục `i` khi một phần tử bị xóa
      }

    }
    //print(users);
     yield users;
   // print(users);

  }
}