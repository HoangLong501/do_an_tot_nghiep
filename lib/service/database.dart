
import 'dart:convert';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
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


  Future addFanPage(String idUser,
      Map<String, dynamic> fanPageInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("fanpage").doc(idUser)
        .set(fanPageInfoMap);
  }

  Stream<int> getReactStream(String idUserOwn, String idNewsfeed) async* {
    try {
      List temp = [];
      yield* FirebaseFirestore.instance
          .collection("newsfeed")
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

  Future<bool> checkUserReact(String newsfeedId, String idUserOwn,
      String userId) async {
    try {
      // Lấy thông tin của newsfeed cụ thể
      DocumentSnapshot newsfeedSnapshot = await FirebaseFirestore.instance
          .collection('newsfeed')
          .doc(newsfeedId)
          .get();

      // Kiểm tra xem newsfeed có tồn tại không
      if (newsfeedSnapshot.exists) {
        // Lấy dữ liệu của newsfeed
        Map<String, dynamic> newsfeedData = newsfeedSnapshot.data() as Map<
            String,
            dynamic>;

        // Lấy danh sách các userId đã react
        List<String> reactUsers = List<String>.from(
            newsfeedData['react'] ?? []);

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
      print(
          'Đã xảy ra lỗi khi kiểm tra react của người dùng cho newsfeed: $error');
      return false;
    }
  }

  Future<void> updateNewsfeedReact(String newsfeedId, String idUserOwn,
      String userId) async {
    try {
      // Lấy thông tin của newsfeed cụ thể
      DocumentSnapshot newsfeedSnapshot = await FirebaseFirestore.instance
          .collection('newsfeed')
          .doc(newsfeedId)
          .get();

      // Kiểm tra xem newsfeed có tồn tại không
      if (newsfeedSnapshot.exists) {
        // Lấy dữ liệu của newsfeed
        Map<String, dynamic> newsfeedData = newsfeedSnapshot.data() as Map<
            String,
            dynamic>;

        // Lấy danh sách các userId đã react
        List<String> reactUsers = List<String>.from(
            newsfeedData['react'] ?? []);
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
            .doc(newsfeedId)
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

  Future<void> updateLikeVideo(String idVideo, String idUserLike) async {
    try {
      // Lấy thông tin của newsfeed cụ thể
      DocumentSnapshot newsfeedSnapshot = await FirebaseFirestore.instance
          .collection('video')
          .doc(idVideo)
          .get();

      // Kiểm tra xem newsfeed có tồn tại không
      if (newsfeedSnapshot.exists) {
        // Lấy dữ liệu của newsfeed
        Map<String, dynamic> newsfeedData = newsfeedSnapshot.data() as Map<
            String,
            dynamic>;


        // Lấy danh sách các userId đã react
        List<String> reactUsers = List<String>.from(
            newsfeedData['react'] ?? []);
        // int reactCount = newsfeedData["reactCount"];
        // print(reactCount);
        // Kiểm tra xem userId đã có trong danh sách react chưa
        if (reactUsers.contains(idUserLike)) {
          // Nếu có, loại bỏ userId khỏi danh sách
          reactUsers.remove(idUserLike);
        } else {
          // Nếu không, thêm userId vào danh sách
          reactUsers.add(idUserLike);
        }
        // Cập nhật trường 'react' của newsfeed với danh sách mới
        await FirebaseFirestore.instance
            .collection('video')
            .doc(idVideo)
            .update({'react': reactUsers});
        print('Cập nhật ${reactUsers.length}');
        print('Cập nhật react thành công cho newsfeed có ID: $idVideo');
      } else {
        // Nếu newsfeed không tồn tại
        print('Newsfeed với ID: $idVideo không tồn tại');
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

  Future<QuerySnapshot> getUserByPhone(String phone) async {
    return await FirebaseFirestore.instance
        .collection("user").where("Phone", isEqualTo: phone).get();
  }


  Stream<QuerySnapshot> getUserByName(String name) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: name + '\uf8ff')
        .snapshots();
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

  Stream<QuerySnapshot> getIdUserDetail(String id) async* {
    yield* await FirebaseFirestore.instance
        .collection("user").where("IdUser", isEqualTo: id).snapshots();
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

  createGroupChat(String idGroup, Map<String, dynamic>chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance.collection("groupChat")
        .doc(idGroup)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      // Cập nhật thời gian vào map trước khi đặt nó vào Firestore
      return FirebaseFirestore.instance.collection("groupChat")
          .doc(idGroup)
          .set(chatRoomInfoMap);
    }
  }


  Stream<QuerySnapshot> getChatRoomMessage(chatRoomId) async* {
    yield* FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId)
        .collection("chats").orderBy("time", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRoomMessage2(chatRoomId) async* {
    yield* FirebaseFirestore.instance.collection("groupChat").doc(chatRoomId)
        .collection("chats").orderBy("time", descending: true)
        .snapshots();
  }


  Stream<QuerySnapshot> getChatRooms(String idUser) async* {
    yield* FirebaseFirestore.instance.collection("chatrooms").orderBy(
        "Time", descending: true)
        .where("user", arrayContains: idUser).snapshots();
  }


  Stream<QuerySnapshot> getGroupChatStream(String idUser) async* {
    print("Di vao ham group");
    yield* FirebaseFirestore.instance.collection("groupChat").orderBy(
        "Time", descending: true)
        .where("user", arrayContains: idUser).snapshots();
  }


  Future addMessage(String chatRoomId, Map<String, dynamic> messInfoMap) async {
    return FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId)
        .collection("chats").doc()
        .set(messInfoMap);
  }



  Future addMessage2(String chatRoomId, Map<String, dynamic> messInfoMap) async {
    return FirebaseFirestore.instance.collection("groupChat").doc(chatRoomId)
        .collection("chats").doc()
        .set(messInfoMap);
  }
 Future updateLastMessageSend(String chatRoomId, Map<String, dynamic>lastMessageInfoMap) {
    print(chatRoomId);
    return FirebaseFirestore.instance.collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  updateLastMessageSend2(String chatRoomId,
      Map<String, dynamic>lastMessageInfoMap) {
    print(chatRoomId);
    return FirebaseFirestore.instance.collection("groupChat")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future<DocumentReference?> addNews(String idUser, String idNewsfeed,
      Map<String, dynamic> newsfeedInfoMap) async {
    try {
      // Sử dụng ID tùy chỉnh được cung cấp để thêm dữ liệu vào Firestore.
      DocumentReference docRef = FirebaseFirestore.instance.collection(
          "newsfeed").doc(idNewsfeed);
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

  Future<void> addUserInfo(String idUser, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance.collection("userinfo").doc(idUser)
        .set(userInfoMap)
        .then((_) {
      print("Thêm info thành công");
    })
        .catchError((error) {
      print("lỗi info: $error");
    });
  }

  // Future<void> addStory(String idUser,String idStory, Map<String, dynamic> userInfoMap) {
  //   return FirebaseFirestore.instance.collection("story").doc(idUser).collection("newstory").doc(idStory)
  //       .set(userInfoMap)
  //       .then((_) {
  //     print("Thêm story thành công");
  //   })
  //       .catchError((error) {
  //     print("lỗi thêm story: $error");
  //   });
  // }
  Future<void> addStory(String idStory, Map<String, dynamic> userIdMap) {
    return FirebaseFirestore.instance.collection("story").doc(idStory).set(
        userIdMap);
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

  Future<void> addVideo(String idVideo, Map<String, dynamic> infoMap) {
    return FirebaseFirestore.instance.collection("video")
        .doc(idVideo).set(infoMap);
  }

  Future<DocumentReference?> addCommentDetail(String idNews,String idComment,Map<String, dynamic> commentInfoMap)  async {
    try {
      // Sử dụng ID tùy chỉnh được cung cấp để thêm dữ liệu vào Firestore.
      DocumentReference docRef = FirebaseFirestore.instance.collection(
          "comment").doc(idNews).collection("userComment").doc(idComment);
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

  Future<DocumentReference?> addReplyCommentDetail(String idNews,
      String idComment,
      Map<String, dynamic> commentInfoMap) async {
    try {
      // Sử dụng ID tùy chỉnh được cung cấp để thêm dữ liệu vào Firestore.
      DocumentReference docRef = FirebaseFirestore.instance.collection(
          "comment").doc(idNews).collection("userComment")
          .doc(idComment)
          .collection("reply")
          .doc();
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

  // Stream<QuerySnapshot> getStory(String iduser) async*{
  //   try{
  //     yield* FirebaseFirestore.instance
  //         .collection("story").doc(iduser).collection("newstory").snapshots();
  //   }catch(e){
  //     print("lỗi lấy story $e");
  //   }
  // }
  Stream<QuerySnapshot> getAllStory() {
    return FirebaseFirestore.instance
        .collection('story')
        .orderBy("times",descending: true)
        .snapshots();
  }

  Future<void> addReaction(String idStory, String idreacsion,
      Map<String, dynamic>infoMap) {
    return FirebaseFirestore.instance.collection("story")
        .doc(idStory).collection("reaction").doc(idreacsion).set(infoMap);
  }

  Future<void> updateReaction(String idStory, String idreacsion,
      Map<String, dynamic>infoMap) {
    return FirebaseFirestore.instance.collection("story")
        .doc(idStory).collection("reaction").doc(idreacsion).update(infoMap);
  }

  Future<QuerySnapshot> getStoryById(String id) {
    return FirebaseFirestore.instance.collection("story")
        .where("idstory", isEqualTo: id).get();
  }

  Future<QuerySnapshot> getSeeStory(String idStory) {
    return FirebaseFirestore.instance.collection("story")
        .doc(idStory).collection("reaction").get();
  }

  Stream<QuerySnapshot> getCommentStream(String idComment) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("comment").doc(idComment).collection("userComment")
          .snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy comment tổng : $error');
    }
  }

  Stream<QuerySnapshot> getReplyCommentStream(String news,
      String idComment) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("comment").doc(news).collection("userComment").doc(
          idComment).collection("reply")
          .orderBy("time", descending: true)
          .snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy comment tổng : $error');
    }
  }

  Future<QuerySnapshot> getUserById(String id) async {
    return await FirebaseFirestore.instance
        .collection("user").where("IdUser", isEqualTo: id).get();
  }

  Future<List<QuerySnapshot>> getSearched(String idUser) async {
    List<QuerySnapshot> listSearched = [];
    QuerySnapshot querySnapshot = await getUserById(idUser);
    if (querySnapshot.docs.isNotEmpty) {
      List<String> list = List<String>.from(querySnapshot.docs[0]["Searched"]);
      for (int i = list.length - 1; i >= 0; i--) {
        QuerySnapshot query = await getUserById(list[i]);
        listSearched.add(query);
      }
      return listSearched;
    } else {
      return [];
    }
  }

  Future<QuerySnapshot> getAllVideo() async {
    return await FirebaseFirestore.instance.collection("video")
        .orderBy("times", descending: true).get();
  }

  Future<QuerySnapshot> getUserInfoById(String idUser) async {
    return await FirebaseFirestore.instance.collection("userinfo")
        .where("id", isEqualTo: idUser).get();
  }

  Stream<QuerySnapshot> getMyNews(String idUser) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("newsfeed").where("viewers" , arrayContains: idUser)
          .orderBy("newTimestamp", descending: true)
          .snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách tin tức: $error');
    }
  }
  Stream<QuerySnapshot> getOnlyMyNews(String idUser) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("newsfeed").where("UserID" , isEqualTo: idUser)
          .orderBy("newTimestamp", descending: true)
          .snapshots();
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy danh sách tin tức: $error');
    }
  }
  Stream<QuerySnapshot> getMyNewsProfile(String idUser , String myId) async* {
    try {
      print("Id: $idUser");
      yield* FirebaseFirestore.instance
          .collection("newsfeed").where("UserID" , isEqualTo: idUser)
          .where("viewers" , arrayContains: myId)
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
    String? myId;
    myId = await SharedPreferenceHelper().getIdUser();
    List<String> friends = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        "relationship").
    doc(userId).collection("friend").where("status", isEqualTo: "friend").get();
    querySnapshot.docs.forEach((e) {
      friends.add(e.get("id"));
    });

    //print(friends);
    return friends;
  }




  Future<List<String>> getReceivered(String userId) async {
    List<String> receivered = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        "relationship").
    doc(userId).collection("friend")
        .where("status", isEqualTo: "pending")
        .get();

    querySnapshot.docs.forEach((e) {
      receivered.add(e.get("id"));
    });
    print(receivered);
    return receivered;
  }

  Stream<DocumentSnapshot> getWatched(String idUser, String idStory) async* {
    yield* FirebaseFirestore.instance
        .collection("idstory") // Hoặc collection chứa stories của bạn
        .doc(idStory)
        .collection('reaction')
        .doc(idUser)
        .snapshots();
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
          .where("status", isEqualTo: "pending")
          .snapshots()
          .asBroadcastStream();
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
        return snapshot.data()?['check'] ?? 0;
      } else {
        return 0;
      }
    } catch (error) {
      print("Đã xảy ra lỗi: $error");
      return 0;
    }
  }

  Stream<QuerySnapshot> getUserInfoByIdStream(String userId) {
    return FirebaseFirestore.instance
        .collection('userinfo')
        .where('id', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserByIdStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .snapshots();
  }

  Future<void> updateUserInfo(String idUser, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance.collection("userinfo").doc(idUser)
        .update(userInfoMap)
        .then((_) {
      print("Thêm info thành công");
    })
        .catchError((error) {
      print("lỗi info: $error");
    });
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

  Future<void> updateSearched(String id, String idSearch) async {
    try {
      await FirebaseFirestore.instance
          .collection("user").doc(id)
          .update({
        'Searched': FieldValue.arrayUnion([idSearch]),
      });
      print("cập nhật lịch sử search thành công");
    } catch (e) {
      print("Lỗi khi cập nhật searched: $e");
    }
  }

  Stream<QuerySnapshot> getMyHint(String idUser) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("relationship").doc(idUser).collection("hint")
          .snapshots().asBroadcastStream();
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

  Future<void> deleteReceived(String idUser, String idReceived) async {
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection("relationship")
          .doc(idReceived).collection("friend");
      await collectionReference.doc(idUser).delete();
      print("đã hủy kết bạn với $idReceived");
    } catch (error) {
      print("lỗi khi xóa hủy kết bạn với $idReceived");
    }
  }

  Future<List<String>> getCity() async {
    List<String> cityNames = []; // Danh sách các full_name
    final response = await http.get(
        Uri.parse('https://esgoo.net/api-tinhthanh/1/0.htm'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> citiesData = responseData['data'];
      for (var city in citiesData) {
        String cityname = city["name"];
        cityNames.add(cityname);
        // Thêm full_name vào danh sách
      }
      return cityNames;
    } else {
      print("lỗi khi lấy dữ liệu thành phố");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  Future<List<String>?> getStickers() async {
    List<String> listUrl = [];
    final response = await http.get(Uri.parse(
        "https://api.mojilala.com/v1/stickers/search?q=cat&api_key=dc6zaTOxFJmzC"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> stickerData = responseData["data"];

      for (var sticker in stickerData) {
        final Map<String, dynamic> images = sticker["images"];
        final String url = images["fixed_height"]["url"];
        listUrl.add(url);
      }
      return listUrl;
    }
  }

  Future<List<Map<String, dynamic>>?> getMusic(String music) async {
    List<Map<String, dynamic>> musicList = [];
    final response = await http.get(
        Uri.parse("https://api.deezer.com/search?q=$music"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> musicData = responseData["data"];
      for (var music in musicData) {
        final String title = music["title"];
        final String url = music["preview"];
        final String name = music["artist"]["name"];
        final String picture = music["artist"]["picture"];
        musicList.add({
          'title': title,
          'url': url,
          'name': name,
          'picture': picture,
        });
      }
      return musicList;
    }
  }

  Future<void> updateUser(String idUser, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance.collection("user")
        .doc(idUser).update(userInfoMap);
  }


  Stream<List> getMemberStream(String idChatRoom) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("groupChat")
          .doc(idChatRoom)
          .snapshots()
          .map((docSnapshot) {
        if (docSnapshot.exists) {
          // Nếu tài liệu tồn tại, trả về giá trị số lượng từ tài liệu
          return docSnapshot.data()?['user'] ??
              []; // Trả về 0 nếu không tìm thấy 'QUANTITY'
        } else {
          // Nếu tài liệu không tồn tại, trả về 0
          return [];
        }
      });
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy số lượng sản phẩm: $error');
      // Trả về một Stream trống nếu có lỗi xảy ra
      yield* Stream.empty();
    }
  }

  Stream<List> getAdminStream(String idChatRoom) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection("groupChat")
          .doc(idChatRoom).collection("info").doc(idChatRoom)
          .snapshots()
          .map((docSnapshot) {
        if (docSnapshot.exists) {
          // Nếu tài liệu tồn tại, trả về giá trị số lượng từ tài liệu
          return docSnapshot.data()?['admin'] ??
              []; // Trả về 0 nếu không tìm thấy 'QUANTITY'
        } else {
          // Nếu tài liệu không tồn tại, trả về 0
          return [];
        }
      });
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy số lượng sản phẩm: $error');
      // Trả về một Stream trống nếu có lỗi xảy ra
      yield* Stream.empty();
    }
  }
  Stream<QuerySnapshot>getWatchedStory(String idStory,String idUser)async*{
    yield* FirebaseFirestore.instance.collection("story")
        .doc(idStory).collection("reaction").where("iduser",isEqualTo: idUser).snapshots();
  }
  Stream<int> getReactVideo(String idvideo) async* {
    try {
      List temp = [];
      yield* FirebaseFirestore.instance
          .collection("video")
          .doc(idvideo)
          .snapshots()
          .map((docSnapshot) {
        if (docSnapshot.exists) {
          temp = docSnapshot.data()?['react'];
          // Nếu tài liệu tồn tại, trả về giá trị số lượng từ tài liệu
          return temp.length;
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
  Future<void> addNewFeed(String idfeed,Map<String,dynamic> infoMap){
    return FirebaseFirestore.instance.collection("newsfeed")
        .doc(idfeed).set(infoMap);
  }
  Future<void> updateVideo(String idvideo,Map<String,dynamic>infoMap){
     return FirebaseFirestore.instance.collection("video")
        .doc(idvideo).update(infoMap);
  }
}















