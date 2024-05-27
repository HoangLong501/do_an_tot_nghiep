
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/lib_class_import/user.dart';

class DatabaseMethods {

  Future addUserDetail(String id, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("user").doc(id)
        .set(userInfoMap);
  }

  Future addRelationship(String idUser,
      Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("relationship").doc(idUser)
        .set(userInfoMap);
  }
  Future addReact(String idReact,
      Map<String, dynamic> reactInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("react").doc(idReact)
        .set(reactInfoMap);
  }
  Stream<int> getReactStream(String idUserOwn, String idNewsfeed) async* {
    try {
      List temp=[];
      yield* FirebaseFirestore.instance
          .collection("newsfeed")
          .doc(idUserOwn)
          .collection("myNewsfeed")
          .doc(idNewsfeed)
          .snapshots()
          .map((docSnapshot) {
        if (docSnapshot.exists) {
          temp = docSnapshot.data()?['react'];
          // Nếu tài liệu tồn tại, trả về giá trị số lượng từ tài liệu
          return temp.length; // Trả về 0 nếu không tìm thấy 'QUANTITY'
        } else {
          // Nếu tài liệu không tồn tại, trả về 0
          return 0;
        }
      });
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy số lượng sản phẩm: $error');
      // Trả về một Stream trống nếu có lỗi xảy ra
      yield* Stream.empty();
    }
  }
  
  Future<bool> checkUserReact(String newsfeedId,String idUserOwn ,String userId) async {
    try {
      // Lấy thông tin của newsfeed cụ thể
      DocumentSnapshot newsfeedSnapshot = await FirebaseFirestore.instance
          .collection('newsfeed')
          .doc(idUserOwn).collection("myNewsfeed").doc(newsfeedId)
          .get();

      // Kiểm tra xem newsfeed có tồn tại không
      if (newsfeedSnapshot.exists) {
        // Lấy dữ liệu của newsfeed
        Map<String, dynamic> newsfeedData = newsfeedSnapshot.data() as Map<String, dynamic>;

        // Lấy danh sách các userId đã react
        List<String> reactUsers = List<String>.from(newsfeedData['react'] ?? []);

        // Kiểm tra xem userId đã có trong danh sách react chưa
        if (reactUsers.contains(userId)) {
          // Nếu có, trả về true
          return true;
        } else {
          // Nếu không, trả về false
          return false;
        }
      } else {
        // Nếu newsfeed không tồn tại, trả về false

        return false;
      }
    } catch (error) {
      // Xử lý lỗi nếu có và trả về false
      print('Đã xảy ra lỗi khi kiểm tra react của người dùng cho newsfeed: $error');
      return false;
    }
  }
  Future<void> updateNewsfeedReact(String newsfeedId,String idUserOwn, String userId) async {
    try {
      // Lấy thông tin của newsfeed cụ thể
      DocumentSnapshot newsfeedSnapshot = await FirebaseFirestore.instance
          .collection('newsfeed')
          .doc(idUserOwn).collection("myNewsfeed").doc(newsfeedId)
          .get();

      // Kiểm tra xem newsfeed có tồn tại không
      if (newsfeedSnapshot.exists) {
        // Lấy dữ liệu của newsfeed
        Map<String, dynamic> newsfeedData = newsfeedSnapshot.data() as Map<String, dynamic>;

        // Lấy danh sách các userId đã react
        List<String> reactUsers = List<String>.from(newsfeedData['react'] ?? []);
        // int reactCount = newsfeedData["reactCount"];
        // print(reactCount);
        // Kiểm tra xem userId đã có trong danh sách react chưa
        if (reactUsers.contains(userId)) {
          // Nếu có, loại bỏ userId khỏi danh sách
          reactUsers.remove(userId);

        } else {
          // Nếu không, thêm userId vào danh sách
          reactUsers.add(userId);

        }

        // Cập nhật trường 'react' của newsfeed với danh sách mới
        await FirebaseFirestore.instance
            .collection('newsfeed')
            .doc(idUserOwn).collection("myNewsfeed").doc(newsfeedId)
            .update({'react': reactUsers});
        print('Cập nhật ${reactUsers.length}');
        print('Cập nhật react thành công cho newsfeed có ID: $newsfeedId');
      } else {

        // Nếu newsfeed không tồn tại
        print('Newsfeed với ID: $newsfeedId không tồn tại');
      }
    } catch (error) {

      // Xử lý lỗi nếu có
      print('Đã xảy ra lỗi khi cập nhật react cho newsfeed: $error');
    }
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

// cập nhật thông tin người dùng
  Future<void> updateUserDetail(String id,
      Map<String, dynamic> updatedUserInfoMap) async {
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

  Future<List<Person>> getUserLimit10() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("user").limit(10)
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

  Future<QuerySnapshot> getIdUserDetail(String id) async {
    return await FirebaseFirestore.instance
        .collection("user").where("IdUser", isEqualTo: id).get();
  }

  createChatRoom(String chatRoomId, Map<String, dynamic>chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance.collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      // Cập nhật thời gian vào map trước khi đặt nó vào Firestore
      return FirebaseFirestore.instance.collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }
  Stream<QuerySnapshot> getChatRoomMessage(chatRoomId)async*{
    yield* FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("chats").orderBy("time",descending: true).snapshots();
  }

  Stream<QuerySnapshot> getChatRooms(String idUser)async*{
    yield* FirebaseFirestore.instance.collection("chatrooms").orderBy("Time",descending: true)
        .where("user",arrayContains: idUser).snapshots();
  }
   Future addMessage(String chatRoomId, Map<String,dynamic> messInfoMap ) async {
      return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("chats").doc().set(messInfoMap);
   }
  updateLastMessageSend(String chatRoomId , Map<String , dynamic>lastMessageInfoMap)  {
    print(chatRoomId);
    return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).update(lastMessageInfoMap);
  }

   Future<DocumentReference?> addNews(String idUser, String idNewsfeed,
      Map<String, dynamic> newsfeedInfoMap) async {
    try {
      // Sử dụng ID tùy chỉnh được cung cấp để thêm dữ liệu vào Firestore.
      DocumentReference docRef = FirebaseFirestore.instance.collection(
          "newsfeed").doc(idUser).collection("myNewsfeed").doc(idNewsfeed);
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

  Future<DocumentReference?> addFriends(String idUser, String idReceived,
      Map<String, dynamic> statusInfoMap) async {
    try {
      // Sử dụng ID tùy chỉnh được cung cấp để thêm dữ liệu vào Firestore.
      DocumentReference docRef = FirebaseFirestore.instance.collection(
          "relationship")
          .doc(idReceived).collection("friend").doc(idUser);
      await docRef.set(statusInfoMap);
      print(idUser);
      print(idReceived);
      print("tạo friend thành công");
      return docRef;
    } catch (e) {
      return null;
    }
  }

  Future<DocumentReference?> addHints(String idUser, String idUserRandom,
      Map<String, dynamic> statusInfoMap) async {
    try {
      // Sử dụng ID tùy chỉnh được cung cấp để thêm dữ liệu vào Firestore.
      DocumentReference docRef = FirebaseFirestore.instance.collection(
          "relationship")
          .doc(idUser).collection("hint").doc(idUserRandom);
      await docRef.set(statusInfoMap);
      return docRef;
    } catch (e) {
      return null;
    }
  }

  Future<QuerySnapshot> search(String username) async {
    return await FirebaseFirestore.instance.collection("user").where(
        "SearchKey", isEqualTo: username).get();
  }

  Future initComment(String idNewsfeed,
      Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("comment").doc(idNewsfeed)
        .set(userInfoMap);
  }

  Future addComment(String idNewsfeed, String userComment,
      Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("comment").doc(idNewsfeed).collection("commentDetail").doc(
        userComment)
        .set(userInfoMap);
  }
  Future<DocumentReference?> addCommentDetail(String idComment,
      Map<String, dynamic> commentInfoMap) async {
    try {
      // Sử dụng ID tùy chỉnh được cung cấp để thêm dữ liệu vào Firestore.
      DocumentReference docRef = FirebaseFirestore.instance.collection(
          "comment").doc(idComment).collection("userComment").doc();
      await docRef.set(commentInfoMap);
      print('Đã thêm comment thành công ');
      // Trả về DocumentReference của tài liệu đã thêm.
      return docRef;
    } catch (e) {
      print("Lỗi khi thêm comment vào Firestore: $e");
      // Xử lý lỗi tại đây nếu cần.
      return null;
    }
  }
  Stream<QuerySnapshot> getCommentStream(String idComment)async*{
    try{
      yield* FirebaseFirestore.instance
          .collection("comment").doc(idComment).collection("userComment")
          .snapshots();
    }catch(error){
      print('Đã xảy ra lỗi khi lấy comment tổng : $error');
    }

  }


  Future<QuerySnapshot> getUserById(String id) async {
    return await FirebaseFirestore.instance
        .collection("user").where("IdUser", isEqualTo: id).get();
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

  Stream<QuerySnapshot> getUsers2() async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("user")
          .snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách tin tức: $error');
    }
  }

  Future<List<String>> getFriends(String userId) async {
    List<String> friends=[];
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("relationship").
    doc(userId).collection("friend").where("status",isEqualTo:"friend").get();

    querySnapshot.docs.forEach((e){
      friends.add(e.get("id"));
    });
    print(friends);
    return friends;
  }

  Stream<QuerySnapshot> getFriend(String idUser) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("relationship").doc(idUser).collection("friend")
          .where("status", isEqualTo: "friend").snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách  bạn bè: $error');
    }
  }

  Stream<QuerySnapshot> getReceived(String idUser) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("relationship").doc(idUser).collection("friend")
          .where("status", isEqualTo: "pending").snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách gợi ý bạn bè: $error');
    }
  }

  Future<int> getCkheckHint(String idUser, String idHint) async {
    try {
      DocumentSnapshot<
          Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("relationship")
          .doc(idUser)
          .collection("hint")
          .doc(idHint)
          .get();
      if (snapshot.exists) {
        return snapshot.data()?['check '] ?? 0;
      } else {
        return 0;
      }
    } catch (error) {
      print("Đã xảy ra lỗi: $error");
      return 0;
    }
  }

  Future<void> updateCheckHint(String idUser, String idHint,
      Map<String, dynamic> hintInfoMap) async {
    try {
      await FirebaseFirestore.instance
          .collection("relationship")
          .doc(idUser)
          .collection("hint")
          .doc(idHint)
          .update(hintInfoMap);
      print("Cập nhật thông tin người dùng thành công!");
    } catch (e) {
      print("Lỗi khi cập nhật thông tin người dùng: $e");
    }
  }

  Stream<QuerySnapshot> getMyHint(String idUser) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("relationship").doc(idUser).collection("hint")
          .snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách gợi ý bạn bè: $error');
    }
  }

  Future<void> deleteHint(String idUser, String idHint) async {
    try {
      CollectionReference friendsRef = FirebaseFirestore.instance
          .collection('relationship').doc(idUser).collection('hint');
      await friendsRef.doc(idHint).delete();

      print(
          'Đã xóa gợi ý có id $idHint từ tài khoản người dùng có id $idUser thành công.');
    } catch (error) {
      // Xử lý ngoại lệ (ví dụ: in ra lỗi)
      print('Lỗi khi xóa gợi ý: $error');
    }
  }

  Future<void> deleteReceived(String idUser,String idReceived) async {
    try{
      CollectionReference collectionReference=FirebaseFirestore.instance.collection("relationship")
          .doc(idReceived).collection("friend");
      await collectionReference.doc(idUser).delete();
      print("đã hủy kết bạn với $idReceived");
    }catch(error){
      print("lỗi khi xóa hủy kết bạn với $idReceived");
    }
  }
  }











