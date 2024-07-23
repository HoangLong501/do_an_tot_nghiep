
import 'dart:async';
import 'package:do_an_tot_nghiep/pages/add_friend/friend.dart';
import 'package:do_an_tot_nghiep/pages/lib_class_import/hintdetail.dart';
import 'package:do_an_tot_nghiep/pages/option_profile.dart';
import 'package:do_an_tot_nghiep/pages/profile.dart';
import 'package:do_an_tot_nghiep/pages/profile_friend.dart';
import 'package:do_an_tot_nghiep/pages/sigin_sigup/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tot_nghiep/service/shared_pref.dart';
import '../service/database.dart';
import 'lib_class_import/user.dart';


class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
   late List<QuerySnapshot> userlist = [];
  List items = [0, 1, 2];
  TextEditingController searchConTroller = TextEditingController();
  bool isVisible=true;
  String? myId;
  Stream<QuerySnapshot>? listUser;
  List<Person> uSers=[];
  String searchString = "";
  List searchResults = [];
  bool search=false;


  onLoad()async{
    myId=await SharedPreferenceHelper().getIdUser();
    listUser= DatabaseMethods().getMyHint(myId!);
    //listSearched=await DatabaseMethods().getSearched(id!);
    if (mounted) {
      setState(() {
        // cập nhật trạng thái ở đây
      });
    }
  }
   List<String> generateSearchKeys(String fullName) {
     List<String> names = fullName.split(" ");
     Set<String> searchKeys = {};

     // Tạo các tổ hợp con của mỗi từ
     for (String name in names) {
       for (int i = 0; i < name.length; i++) {
         for (int j = i + 1; j <= name.length; j++) {
           searchKeys.add(name.substring(i, j).toUpperCase());
         }
       }
     }

     // Tạo các tổ hợp con của các cụm từ
     for (int i = 0; i < names.length; i++) {
       String combinedName = "";
       for (int j = i; j < names.length; j++) {
         combinedName = (combinedName.isEmpty ? names[j] : "$combinedName ${names[j]}");
         for (int k = 0; k < combinedName.length; k++) {
           for (int l = k + 1; l <= combinedName.length; l++) {
             searchKeys.add(combinedName.substring(k, l).toUpperCase());
           }
         }
       }
     }

     return searchKeys.toList();
   }
   void performSearch(String query) {
     if (query.isEmpty) {
       setState(() {
         searchResults = [];
         search =false;
       });
       return;
     }

     String searchKey = query.toUpperCase();

     FirebaseFirestore.instance
         .collection('user')
         .where('SearchKey', arrayContains: searchKey)
         .get()
         .then((QuerySnapshot querySnapshot) {
       setState(() {
         searchResults = querySnapshot.docs.map((doc) => doc.data()).toList();
       });
     });
     setState(() {
       search=true;
     });

   }
   @override
  void initState() {
  super.initState();
  onLoad();
  }
   @override
  void dispose() {
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(Icons.arrow_back)),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30)
              ),
              width: MediaQuery.of(context).size.width/1.4,
              child: Container(
                padding: EdgeInsets.only(left: 20),
                child: TextField(
                  controller:  searchConTroller,
                  decoration: InputDecoration(
                      hintText: "Tìm kiếm",
                      border: InputBorder.none
                  ),
                  onChanged: (value){
                    setState(() {
                      searchString = value;
                    });
                    performSearch(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              searchString.isNotEmpty? Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200
                ),
                height: MediaQuery.of(context).size.height/2,
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: GestureDetector(
                        onTap: (){
                          if(searchResults[index]['IdUser']==myId){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)
                            =>Profile(idProfileUser: myId!)));
                          }else{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)
                            =>ProfileFriend(idProfileUser: searchResults[index]['IdUser'])));
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: Image.network(searchResults[index]['imageAvatar']).image,
                              ),
                              SizedBox(width: 10),
                              Text(searchResults[index]['Username']),
                            ],
                          ),
                        ),
                      ),
                      // Hiển thị các thông tin khác nếu cần
                    );
                  },
                ),
              ):Container(
                //Giao dien con lai
              ),
              isVisible?
              Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Những người bạn có thể biết",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Xem tất cả",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  potentianlFriends(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 250,
                          height: 5, // Đặt chiều cao của Container
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
                            itemCount: uSers.length, // Số lượng mục trong ListView
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),

                                      borderRadius:
                                      BorderRadius.circular(10), // Độ bo góc
                                    ),
                                    width: 250,
                                    // Đặt chiều rộng của Container
                                    height: 350,
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    // Đặt khoảng cách giữa các phần tử

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // Căn lề trái cho các phần tử trong cột
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(9),
                                              topRight: Radius.circular(
                                                  9)), // Độ cong của góc bo tròn
                                          child: Image.network(
                                            uSers[index].image,

                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Text(
                                            uSers[index].username,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                                    Colors.blue.shade800),
                                                // Màu nền của nút
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.0), // Bo góc của nút
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.person_add_alt_1,
                                                    color: Colors
                                                        .white, // Màu biểu tượng
                                                  ),
                                                  SizedBox(width: 5),
                                                  // Khoảng cách giữa biểu tượng và văn bản
                                                  Text(
                                                    "Thêm bạn bè",
                                                    style: TextStyle(
                                                      color: Colors
                                                          .white, // Màu văn bản
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            TextButton(
                                                onPressed: () {

                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                  Colors.grey.shade300),
                                                  shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                      )),
                                                ),
                                                child: Text(
                                                  "Xóa",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Các thước phim phổ biến bạn có thể thích",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Xem tất cả",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              width: 200,
                              height: 365, // Đặt chiều cao của Container
                              margin: EdgeInsets.only(
                                left: 10,
                              ),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // Cho phép cuộn ngang
                                  itemCount: 4,
                                  // Số lượng mục trong ListView
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                        onTap: () {
                                          // Xử lý khi GestureDetector được nhấn
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 1,
                                                ),

                                                borderRadius: BorderRadius.circular(
                                                    10), // Độ bo góc
                                              ),
                                              width: 200,
                                              // Đặt chiều rộng của Container
                                              height: 365,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 2),
                                              // Đặt khoảng cách giữa các phần tử
                                              child:   ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.network(
                                                  "https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                            )));
                                  })))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Nhóm dành cho bạn",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Xem tất cả",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 250,
                          height: 380, // Đặt chiều cao của Container
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
                            itemCount: 4, // Số lượng mục trong ListView
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  // Xử lý khi GestureDetector được nhấn
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),

                                      borderRadius:
                                      BorderRadius.circular(10), // Độ bo góc
                                    ),
                                    width: 250,
                                    // Đặt chiều rộng của Container
                                    height: 370,
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    // Đặt khoảng cách giữa các phần tử

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // Căn lề trái cho các phần tử trong cột
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(9),
                                              topRight: Radius.circular(
                                                  9)), // Độ cong của góc bo tròn
                                          child: Image.network(
                                            "https://cdn.picrew.me/app/image_maker/333657/icon_sz1dgJodaHzA1iVN.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Text(
                                            "name $index",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              height: 24,
                                              child: Text(
                                                "350 thành viên . 10 bài viết/tháng",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              // Xử lý khi nút được nhấn
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all<
                                                  Color>(
                                                  Colors.blue.shade800),
                                              // Màu nền của nút
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // Bo góc của nút
                                                ),
                                              ),
                                            ),
                                            child:  Center(

                                              child: Text(
                                                "Tham gia",
                                                style: TextStyle(
                                                  color: Colors
                                                      .white, // Màu văn bản
                                                ),
                                              ),
                                            ),

                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Thử nhiều hơn trên Facebook",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2.2,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/pf9WhKD/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/3.5,
                              margin: EdgeInsets.only(left: 1),
                              child: Text("Nhắc đến bạn",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2.2,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/TBL2dbh/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/3.5,
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Bình luận của bạn",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2.2,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/ZBq245P/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 1),
                              child: Text("Bài viết bạn đã th...",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2.2,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/n31CXVY/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 1),
                              child: Text("Sinh nhật",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2.2,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/jHT3ttL/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 1),
                              child: Text("Đã lưu",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Friends()));
                        },
                     child:  Container(

                        width: MediaQuery.of(context).size.width/2.2,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/d0tdJgN/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 1),
                              child: Text("Bạn bè",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2.2,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/QK25Gxp/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 1),
                              child: Text("Marketplace",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2.2,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/TH2YrpP/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 1),
                              child: Text("Nhóm",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2.2,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/Lx3gq6w/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 1),
                              child: Text("Reels",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2.2,
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Màu của bóng với độ mờ 50%
                              spreadRadius: 1, // Bán kính mở rộng của bóng
                              blurRadius: 1, // Độ mờ của bóng
                              offset: Offset(0, 3), // Độ dịch của bóng
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 35,
                                child:  Image.network(
                                  "https://i.ibb.co/q9L29J9/image.png",
                                ) // Hiển thị ký tự "@"
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 1),
                              child: Text("Kỷ niệm",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,)
                ],
              ): SizedBox(),
          ]
          )
          )
        ),
      );
  }
  Widget potentianlFriends (){
    return StreamBuilder<QuerySnapshot>(
        stream: listUser, // Lắng nghe thay đổi từ Firestore
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }else if(snapshot.hasError){
            return Text("lỗi rồi");
          }else if(snapshot.data==null || snapshot.data!.docs.isEmpty){
            return Text("bạn chưa có gợi ý nào");
          }
          else {
           // print("Lấy dữ liệu ?  ${snapshot.hasData}");
    return snapshot.hasData?
      Row(
      children: [
        Expanded(
          child: Container(
            width: 250,
            height: 365, // Đặt chiều cao của Container
            margin: EdgeInsets.only(
              left: 10,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
              itemCount:snapshot.data!.docs.length, // Số lượng mục trong ListView
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data =snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return HintDetail(key: ValueKey("$index ${data["id"]}"),id: data["id"],);
              },
            ),
          ),
        ),
      ],
    ):Center(child: CircularProgressIndicator(),);
          }
    }
    );
  }
}


